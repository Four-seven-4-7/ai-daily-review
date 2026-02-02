# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概览
一个极简的、基于单 HTML 文件的 React 结构化复盘工具。使用 React 18、Ant Design 和 Supabase 构建，直接在浏览器端通过 Babel 实时转换 JSX。

## 开发命令
由于项目采用极简架构，没有 `package.json` 或 Node.js 构建链。

- **运行与预览**: 直接在浏览器中打开 `index.html`。
- **本地开发模拟**: `vercel dev` (需安装 Vercel CLI)。
- **部署**: `vercel --prod`。

## 核心架构
- **单文件应用 (SFA)**: 几乎所有的 UI 结构、样式 (`<style>`) 和业务逻辑 (`<script type="text/babel">`) 都集成在 [index.html](index.html) 中。
- **本地依赖**: 核心库（React, AntD, Supabase 等）存放在 [libs/](libs/) 目录，通过本地路径加载以确保稳定性。
- **数据持久化**:
  - **LocalStorage**: 用于即时自动保存和防丢机制。
  - **Supabase**: 提供云端同步和历史记录存储。关键表：`daily_reviews`, `user_settings`。
- **AI 功能**: 通过 `ModelScope (Qwen2.5-7B)` 提供分析报告，调用逻辑位于 `handleAIAnalysis` 函数内。

## 技术规范
- **JSX 转换**: 所有的 React 组件代码必须包裹在 `<script type="text/babel">` 中。
- **代码风格**: 保持在 [index.html](index.html) 中的内联式开发，不建议在未经过重大重构前将逻辑拆分为多个文件。
- **错误处理**: 核心依赖加载失败时会有全局捕获逻辑 (line 54)。
- **数据流**: 遵循 `LocalStorage 优先 -> 后台异步同步 Supabase` 的策略。

## 关键技术栈
- React 18 (CDN 版)
- Ant Design 5 (CDN 版)
- Supabase (CDN 版)
- Day.js (时间处理)
- ModelScope API (AI 复盘分析)
