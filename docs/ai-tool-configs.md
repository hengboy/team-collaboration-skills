# AI 工具配置指南

## 概述

所有 Skills 均使用 Markdown 格式，可配置到主流 AI 工具。

---

## OpenCode（推荐）

OpenCode 内置 skill 工具，会自动从项目加载 Skills。

### 使用方式

```bash
# 启动 OpenCode
opencode

# 加载 Skill
skill(name: backend-engineer)

# 描述任务（用@引用文件）
请实现登录接口。

## API 契约
@docs/api/auth.yaml

## 技术方案
@docs/tech/mobile-login.md
```

### 配置全局 Skills

```bash
# 复制到全局目录
cp -r skills/* ~/.config/opencode/skills/
```

---

## Claude Desktop

### 配置 Skills

```bash
# 全局配置
mkdir -p ~/.claude/skills
cp skills/backend-engineer/SKILL.md ~/.claude/skills/backend-engineer.md
```

### 使用方式

```bash
# 打包上下文
./tools/skill-run.sh backend-engineer -c 手机号登录

# 复制上下文
cat .ai-context/context_* | pbcopy

# 在 Claude 中粘贴并描述任务
```

---

## GitHub Copilot

### 配置 Instructions

```bash
# 项目配置
mkdir -p .github
cat skills/backend-engineer/SKILL.md >> .github/copilot-instructions.md
```

### 使用方式

在 VS Code 中使用 Copilot Chat：

```
作为后端工程师，请实现登录接口。

## API 契约
@docs/api/auth.yaml
```

---

## Cursor

### 配置 Rules

```bash
# 添加到 .cursorrules
cat skills/backend-engineer/SKILL.md >> .cursorrules
```

### 使用方式

在 Cursor Chat 中：

```
作为后端工程师，请实现登录接口。

## API 契约
@docs/api/auth.yaml
```

---

## 通用使用方法

### OpenCode 用户

**无需打包上下文**，直接用@引用文件：

```
skill(name: backend-engineer)

请实现登录接口。

## API 契约
@docs/api/auth.yaml

## 技术方案
@docs/tech/mobile-login.md
```

### Claude/Copilot/Cursor 用户

这些工具也支持@引用文件，用法相同。

---

## 版本

- **当前版本**: v2.0.0
- **格式**: Markdown
