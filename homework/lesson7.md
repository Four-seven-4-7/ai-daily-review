# AI 编程第七课：复盘项目专项（核心 MVP）

> **项目公网链接**：[https://four-seven-4-7.github.io/ai-daily-review/](https://four-seven-4-7.github.io/ai-daily-review/)
> **作业导航**：
> [第一课：痛点挖掘](lesson1.md) | [第二课：全栈实现](lesson2.md) | [第三课：AI 接入](lesson3.md) | [第四课：效率工具](lesson4.md)
> [第五课：开发迭代](lesson5.md) | [第六课：部署发版](lesson6.md) | [第七课：项目专项](lesson7.md) | [第八课：毕业路演](lesson8.md)

---

![Project](https://images.unsplash.com/photo-1454165833767-027ffea9e61d?auto=format&fit=crop&q=80&w=1000)

## 7.1 找到值得做的产品场景
**核心痛点**：flomo 记录虽快，但“只记不看”等于白记。
**解决方案**：一个强迫你“当日总结+明日计划”，并通过飞书催促你执行的闭环系统。

## 7.2 第一个 MVP 版本实现与自动化工作流

### 核心功能闭环
1.  **输入**：支持今日计划完成度打分。
2.  **流转**：基于 `LocalStorage` 实现明日变今日的自动填充逻辑。
3.  **提醒**：基于 GitHub Actions 的定时飞书推送。

### 🤖 飞书提醒工作流详细说明
为了解决“总是忘记复盘”的问题，我设计了以下自动化链路：

#### 1. 工作流架构图
`定时任务 (21:30)` -> `GitHub Actions 运行环境` -> `Node.js 执行脚本` -> `查询今日复盘状态` -> `发送飞书 Webhook`

#### 2. 实现要点
*   **触发机制**：使用 GitHub Actions 的 `cron` 表达式定时触发。
*   **数据校验**：脚本会通过 Supabase 查询用户今日是否已提交复盘。若未提交，则触发告警。
*   **安全保护**：Webhook 地址存储在 GitHub Repository Secrets 中，避免泄露。

#### 3. 运行效果
> 💡 **手动操作提示**：导入飞书后，请将本地 `screen/screenshot_05.jpg` 拖拽到下方区域。

![飞书截图](screen/screenshot_05.jpg)
*图：每天定时收到的飞书自动化提醒，确保复盘不遗漏*

---
© 2026 AI 编程课程作业 - 先做起来，比什么都重要
