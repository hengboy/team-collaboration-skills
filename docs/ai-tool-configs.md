# AI 工具配置指南

## 概述

所有 Skills 均使用 Markdown 格式，可配置到主流 AI 工具。

**无需脚本** - 直接用 `skill(name: xxx)` 调用。

---

## OpenCode

### 使用方式

```bash
# 启动 OpenCode
opencode

# 加载 Skill
skill(name: frontend-design)  # 前端设计
skill(name: frontend)  # 前端开发
skill(name: backend-typescript)  # 后端开发（TypeScript）

# 描述任务（用@引用文件）
请设计登录页面。

## PRD
@docs/collaboration/prd/mobile-login.md

## API 契约
@docs/collaboration/api/auth.yaml
```

### 配置全局 Skills

```bash
cp -r skills/* ~/.config/opencode/skills/
```

---

## Claude Desktop

### 配置 Skills

```bash
mkdir -p ~/.claude/skills
cp skills/frontend-design/SKILL.md ~/.claude/skills/  # 前端设计
cp skills/frontend/SKILL.md ~/.claude/skills/  # 前端开发
cp skills/backend-typescript/SKILL.md ~/.claude/skills/  # 后端开发（TypeScript）
cp skills/backend-springboot/SKILL.md ~/.claude/skills/  # 后端开发（Java）
```

### 使用方式

```bash
claude
```

在对话中：

```
我使用前端设计师 Skill。

请设计登录页面。

## PRD
{粘贴 docs/prd/mobile-login.md 内容}

## API 契约
{粘贴 docs/api/auth.yaml 内容}
```

---

## GitHub Copilot

### 配置 Instructions

```bash
mkdir -p .github
cat skills/backend-typescript/SKILL.md >> .github/copilot-instructions.md
```

### 使用方式

在 VS Code Copilot Chat 中：

```
作为后端工程师，请实现登录接口。

## API 契约
@docs/collaboration/api/auth.yaml
```

---

## Cursor

### 配置 Rules

```bash
cat skills/backend-typescript/SKILL.md >> .cursorrules
```

### 使用方式

在 Cursor Chat 中：

```
作为后端工程师，请实现登录接口。

## API 契约
@docs/collaboration/api/auth.yaml
```

---

## 通用使用方法

### OpenCode 用户

直接用@引用文件：

```
skill(name: backend-typescript)

请实现登录接口。

## API 契约
@docs/collaboration/api/auth.yaml
```

### 其他工具用户

手动粘贴相关文件：

```
我使用后端工程师 Skill。

请实现登录接口。

## API 契约
{粘贴内容}
```

---

