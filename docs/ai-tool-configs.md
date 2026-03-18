# AI 工具配置指南

## 概述

所有 Skills 均使用 Markdown 格式，可配置到主流 AI 工具。

---

## Cursor 配置

在 `.cursorrules` 文件中添加：

```markdown
# AI Team Cooperation Rules

## 可用 Skills

- Product Manager - 需求分析、PRD
- Tech Lead - 技术方案、API 设计
- Backend Engineer - API 实现
- Frontend Engineer - React 组件
- QA Engineer - 测试用例
- Code Reviewer - 代码审查

## 代码规范

- 语言：TypeScript
- 框架：NestJS (后端), React (前端)
- 测试：Jest

## 响应要求

- 使用 Markdown 格式
- 代码包含类型定义
- 包含错误处理
- 包含日志记录
```

---

## GitHub Copilot 配置

在 `.github/copilot-instructions.md` 中添加：

```markdown
# Copilot Instructions

## 项目技术栈

- Backend: NestJS + TypeScript + TypeORM
- Frontend: React + TypeScript + Tailwind CSS
- Testing: Jest + Supertest + Playwright

## 代码风格

- 使用函数式编程
- 优先使用 const
- 明确的类型定义
- 遵循 RESTful 规范
```

---

## Claude Desktop 配置

在 `claude_desktop_config.md` 中添加：

```markdown
# Custom Instructions

## 项目背景

AI 协作团队项目，使用 Skills 进行协作。

## 响应要求

- Markdown 格式
- TypeScript 代码
- 完整错误处理
- 引用相关文档
```

---

## OpenCode 配置

```bash
# 复制到 skills 目录
cp skills/backend/skill.md ~/.config/opencode/skills/backend.md
cp skills/frontend/skill.md ~/.config/opencode/skills/frontend.md
```

---

## 通用使用方法

### 1. 打包上下文

```bash
./tools/context-pack.sh backend 手机号登录
```

### 2. 复制 Skill

```bash
cat skills/backend/skill.md
```

### 3. 调用 AI

将以下内容复制到 AI 工具：
1. Skill 定义
2. context 文件内容
3. 具体任务描述

---

## 快速配置脚本

```bash
# Cursor
cat skills/backend/skill.md >> .cursorrules

# GitHub Copilot
mkdir -p .github
cat skills/backend/skill.md >> .github/copilot-instructions.md

# OpenCode
mkdir -p ~/.config/opencode/skills
cp skills/backend/skill.md ~/.config/opencode/skills/
```

---

## 版本

- **当前版本**: v2.0.0
- **格式**: Markdown
