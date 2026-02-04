# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概览
一个极简的、基于单 HTML 文件的 React 结构化复盘工具。使用 React 18、Ant Design 5 和 Supabase 构建，直接在浏览器端通过 Babel 实时转换 JSX。

## 开发命令
项目采用极简架构，无标准 Node.js 构建链。
- **运行与预览**: 直接在浏览器中打开 [index.html](index.html)。
- **本地开发模拟**: `vercel dev` (需安装 Vercel CLI)。
- **部署**: `vercel --prod`。
- **提醒脚本测试**: `node scripts/daily_check.js` (需配置环境变量 `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `FEISHU_WEBHOOK`, `DEVICE_ID`)。

## 核心架构
- **单文件应用 (SFA)**: 几乎所有的 UI、样式和逻辑都集成在 [index.html](index.html) 中。
  - `window.onerror`: 全局错误捕获，处理核心库加载失败。
  - `supabaseService`: 封装 Supabase 数据操作，采用单例模式。
  - `App` 组件: 核心状态管理，包含数据初始化、自动保存、AI 分析等逻辑。
- **本地依赖**: 核心库存放在 [libs/](libs/)，通过相对路径加载。
- **数据流**:
  - **读取**: 初始化时顺序尝试 `本地 LocalStorage` -> `云端 Supabase 今日数据` -> `云端/本地 上一日继承数据`。
  - **写入**: 遵循 `LocalStorage 优先同步保存 -> Supabase 异步后台同步` 策略。
  - **自动保存**: 使用 `useDebounce` hook 实现 1 秒延迟的 LocalStorage 自动保存。

## 技术规范
- **JSX 开发**: 代码必须在 `<script type="text/babel">` 块中。
- **代码分割**: 严禁将逻辑拆分为多文件，除非进行重大架构重构。
- **变量命名**:
  - `STORAGE_KEY_PREFIX`: `daily_review_`
  - `META_KEY`: `daily_review_meta` (存储主/副主题等元数据)
- **AI 功能**: 调用 `ModelScope (Qwen2.5-7B-Instruct)` API，入口函数为 `handleAIAnalysis`。

## 关键技术栈
- React 18 / ReactDOM 18 (Local)
- Ant Design 5 (Local)
- Supabase JS Client (Local)
- Day.js (Time management)
- ModelScope API (AI analysis)
- Feishu Webhook (Notifications)
