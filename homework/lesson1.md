# AI 编程第一课：痛点挖掘与 MVP 架构

> **项目公网链接**：[https://four-seven-4-7.github.io/ai-daily-review/](https://four-seven-4-7.github.io/ai-daily-review/)
> **作业导航**：
> [第一课：痛点挖掘](lesson1.md) | [第二课：全栈实现](lesson2.md) | [第三课：AI 接入](lesson3.md) | [第四课：效率工具](lesson4.md)
> [第五课：开发迭代](lesson5.md) | [第六课：部署发版](lesson6.md) | [第七课：项目专项](lesson7.md) | [第八课：毕业路演](lesson8.md)

---

![Banner](https://images.unsplash.com/photo-1512314889357-e157c22f938d?auto=format&fit=crop&q=80&w=1000)

## 1.1 【初阶作业】痛点挖掘机

### 🔍 场景描述：flomo 碎片的“搬运地狱”
作为一个 flomo 的重度用户，我每天会记录大量的灵感和计划。但到了复盘时，我必须打开 flomo 网页版，手动一条条复制内容到 AI 工具中进行分析。

### 💡 痛点深度解析
*   **用户角色**：追求高效率的 flomo 知识工作者。
*   **当前做法**：`手动复制 flomo 内容` -> `打开 AI 对话框` -> `输入分析指令`。
*   **摔键盘瞬间**：当记录超过 20 条时，这种机械化的复制粘贴简直是生命浪费，极易遗漏且打断思考流。
*   **核心需求**：实现碎片记录到结构化复盘的**全自动流转**。

## 1.2 【进阶作业】MVP 架构师

### 🚀 产品方案：自动化复盘闭环
**核心链路**：用户在单页 Web 端输入，数据实时存入 Supabase，一键调用 AI 洞察。

### 乐高组件清单
| 模块 | 工具选择 | 作用 |
| :--- | :--- | :--- |
| **UI 界面** | React 18 + Ant Design 5 | 提供丝滑的输入与交互体验 |
| **数据引擎** | Supabase | 替代复杂后端，实现实时云同步 |
| **智能内核** | ModelScope (Qwen2.5) | 自动化提取行为规律 |
| **发布渠道** | GitHub + Vercel | 实现秒级公网预览 |

### MVP 功能截图
> 💡 **手动操作提示**：导入飞书后，请将本地 `screen/screenshot_01.png` 拖拽到下方区域。

![MVP 首页](screen/screenshot_01.png)
*图：基于 Ant Design 橙色视觉体系搭建的极简输入界面*

---
© 2026 AI 编程课程作业 - 专注真实痛点解决
