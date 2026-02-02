# 回退并重构密钥管理方案

您提出的观点非常正确。既然我们已经使用了 Supabase 作为后端，那么**所有的敏感配置（包括 Supabase 自身的 URL/Key 和第三方 API Key）理应由服务端（或数据库）统一管理**，而不是让前端用户手动去 `localStorage` 里配置，这既不安全也不优雅。

然而，这里有一个**架构上的悖论**：前端必须先知道 Supabase 的连接信息（URL 和 Key），才能连接到 Supabase 去读取其他的配置（如 Moonshot API Key）。

为了解决这个悖论，同时满足“代码脱敏上传 GitHub”和“本地/线上无缝运行”的需求，我为您设计了以下**分层密钥管理方案**。

## 1. 核心思路：配置分级

我们将配置分为两类，采用不同的管理策略：

### 第一类：连接级配置 (Bootstrap Config)
*   **内容**：`SUPABASE_URL`, `SUPABASE_ANON_KEY`。
*   **性质**：这是前端连接后端的“钥匙”。**Anon Key 本身设计就是可以公开的**（它受 RLS 策略限制，不包含管理员权限），所以在代码中保留它并没有严重的安全风险。
*   **策略**：
    *   **回退**：将这两个值恢复写入到 `index.html` 中。
    *   **解释**：这是单页应用（SPA）的标准做法。只要您的数据库 RLS（行级安全策略）配置正确（我们已经配置好了），暴露 Anon Key 是安全的。

### 第二类：敏感级配置 (Secret Config)
*   **内容**：`Moonshot/ModelScope API Key`。
*   **性质**：绝对不能暴露在前端代码中，否则会被盗用额度。
*   **策略**：
    *   **存储**：继续保留在 Supabase 的 `user_settings` 表中。
    *   **获取**：前端通过 RLS 保护的接口动态读取。
    *   **代码**：代码中只保留读取逻辑，不包含任何 Key 字符串。

## 2. 执行计划

### 第一步：回退代码 (Rollback)
*   将 `index.html` 中的 `SUPABASE_URL`和 `SUPABASE_ANON_KEY` 恢复为真实的硬编码值。
*   删除从 `localStorage` 读取这些值的逻辑（因为这增加了用户的使用负担）。

### 第二步：清理敏感文件 (Clean)
*   删除 `supabase/migrations/init_ai_settings.sql` 中的真实 API Key，只保留表结构定义。
    *   原因：SQL 文件也会上传到 GitHub，如果里面写了 `INSERT ... 'ms-xxx'`，Key 就泄露了。
    *   替代：提供一个 SQL 模板，提示用户在 Supabase 后台 SQL 编辑器中手动执行 `INSERT` 语句。

### 第三步：验证 RLS 安全性 (Verify)
*   再次确认 `daily_reviews` 和 `user_settings` 表的 RLS 策略是否严密。只要策略正确，暴露 Supabase Anon Key 就是安全的，您可以放心地将包含 Anon Key 的代码上传到 GitHub。

## 3. 为什么这个方案更好？
1.  **用户体验好**：用户打开网页就能用，不需要按 F12 去输命令配置。
2.  **安全性可控**：真正敏感的 Moonshot Key 依然在数据库里，GitHub 上只有连接信息。
3.  **符合标准**：Firebase, Supabase 等 BaaS 服务都采用这种“公开 Anon Key + 数据库权限控制”的模式。

如果您同意，我将立即执行回退和清理操作。