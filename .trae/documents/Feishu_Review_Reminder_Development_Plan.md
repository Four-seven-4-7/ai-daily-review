# 飞书复盘提醒功能开发方案 (Vercel Edge Function 版)

## 1. 架构评估与选择
您提出的基于 **Vercel Edge Function** 的方案非常专业且现代化。鉴于您的项目本身是一个 Web 应用，使用 Vercel Edge Function (或 Serverless Functions) 具有以下优势：
*   **原生集成**：如果您未来将前端部署到 Vercel (目前是 GitHub Pages，但迁移很简单)，前后端可以统一部署。
*   **定时触发**：Vercel 提供了 Cron Jobs 功能，可以精确配置定时任务。
*   **低延迟**：Edge Function 启动速度极快。

**架构确认**：
`Web (设置页)` -> `Supabase (存储用户配置)` -> `Vercel Cron (定时触发)` -> `Edge Function (逻辑判断)` -> `飞书机器人` -> `用户`

## 2. 详细执行步骤

### 第一步：飞书机器人准备 (前置条件)
*   **动作**：您需要在飞书群组中添加一个“自定义机器人”。
*   **产出**：获取 `Webhook URL` (形如 `https://open.feishu.cn/open-apis/bot/v2/hook/xxxxxxxx`).

### 第二步：数据库扩展 (Supabase)
我们需要在 `user_settings` 表中存储提醒相关的配置，以便函数知道该提醒谁、什么时候提醒。
*   **新增配置项**：
    *   `feishu_webhook_url`: 您的飞书机器人地址。
    *   `reminder_time`: 提醒时间 (例如 "23:30")。
    *   `device_id`: 关联的设备 ID (用于查询当日是否已复盘)。

### 第三步：创建 Vercel 项目结构
由于当前项目是纯静态 HTML，为了使用 Vercel Functions，我们需要建立标准的 Vercel 项目结构：
1.  创建 `api/cron/check-review.js`：这是核心云函数。
2.  创建 `vercel.json`：配置 Cron Job 触发规则。

### 第四步：编写核心云函数逻辑 (`api/cron/check-review.js`)
该函数将执行以下逻辑：
1.  **连接数据库**：使用 Supabase Client。
2.  **获取配置**：从 `user_settings` 表中读取所有开启了提醒的用户配置。
3.  **检查状态**：遍历每个用户，查询 `daily_reviews` 表，看今天 (`currentDate`) 是否有记录。
4.  **发送通知**：如果未找到记录，向该用户的 `feishu_webhook_url` 发送 POST 请求。

### 第五步：部署与配置
*   **代码提交**：将新文件推送到 GitHub。
*   **Vercel 导入**：在 Vercel 官网导入您的 GitHub 仓库。
*   **环境变量**：在 Vercel 后台配置 `SUPABASE_URL` 和 `SUPABASE_SERVICE_ROLE_KEY` (必须用 Service Role Key，因为云函数是后台管理员角色，需要跨过 RLS 查数据)。

## 3. 核心产出物
1.  **代码文件**：`api/cron/check-review.js`, `vercel.json`。
2.  **SQL 脚本**：用于在 `user_settings` 中插入您的飞书配置。
3.  **部署指南**：指导您如何将项目连接到 Vercel 并填入环境变量。

请确认是否采用此 **Vercel Edge Function + Cron** 方案？确认后我将开始编写代码。