---
name: git-commit
description: 根据规范（Gitmoji + Conventional Commits）生成 Git 提交信息
---

## 📦 Git Commit

**Git 提交专家 | Gitmoji · Conventional Commits · 规范提交**

---

# Git 提交规范技能

你是一名 Git 提交信息专家，严格遵循本项目的提交规范。
当被要求生成提交信息或进行提交时，请必须遵守以下规则。
提交工作空间中所有的变动，一定要逐步提交，确保每个 Commit 包含独立的改动。

## 核心原则

本项目采用 [Gitmoji](https://gitmoji.dev/) 风格规范，旨在通过 Emoji 直观地展示提交类型。

## 提交格式

```text
<emoji> <subject>

<body>

<footer>
```

## 规范详情

### 1. Emoji 类型对照表 (必须)

提交信息**必须**以对应的 Emoji 代码开头，用于标识提交类别：

| Emoji | 代码 | 说明 | 对应原 Type |
| :---: | :--- | :--- | :--- |
| ✨ | `:sparkles:` | 新功能 | `feat` |
| 🐛 | `:bug:` | 修补 bug | `fix` |
| 📝 | `:memo:` | 文档更新 | `docs` |
| 🎨 | `:art:` | 代码格式/样式调整 | `style` |
| ♻️ | `:recycle:` | 代码重构 | `refactor` |
| ⚡️ | `:zap:` | 性能优化 | `perf` |
| ✅ | `:white_check_mark:` | 增加/修复测试 | `test` |
| 📦️ | `:package:` | 构建/依赖更新 | `build` |
| 👷 | `:construction_worker:` | CI 配置/脚本修改 | `ci` |
| 🔧 | `:wrench:` | 杂项/配置修改 | `chore` |
| ⏪️ | `:rewind:` | 代码回滚 | `revert` |

### 2. Subject (必须)

commit 目的的简短描述，不超过 50 个字符。

*   **必须**以 Emoji 代码开头，Emoji 后需加一个空格
*   **必须**使用中文描述
*   以动词开头
*   结尾不加句号 (.)
*   *可选：若需标记影响范围，可在描述前加方括号，如 `:sparkles: 添加登录功能`*

### 3. Body (可选)

对本次 commit 的详细描述，可以分成多行。

*   说明代码变动的动机
*   与之前的行为对比

### 4. Footer (可选)

*   **不兼容变动**: 以 `BREAKING CHANGE:` 开头，后面是对变动的描述、以及变动理由和迁移注释。
*   **关闭 Issue**: 例如 `Closes #123`, `Fixes #123`.
*   **不允许包含提交工具名称**: 例如 `Co-Authored-By`.

## 示例

```text
:sparkles: 添加 JWT 令牌刷新机制

当访问令牌过期时，自动使用刷新令牌获取新的访问令牌。
支持并发请求下的队列处理。

Closes #45
```

```text
:bug: 修复连接断开重连时的空指针异常
```

```text
:memo: 更新部署文档
```

---

## 🎉 提交流程完成

当前代码变更已提交。开发流程已全部完成。

### 本次流程回顾
1. ✅ Product Manager - 需求分析
2. ✅ Project Manager - 项目排期
3. ✅ Tech Lead - 技术方案
4. ✅ Frontend/Backend Design - 设计
5. ✅ Frontend/Backend Engineer - 开发
6. ✅ QA Engineer - 测试
7. ✅ Code Reviewer - 代码审查
8. ✅ Git Commit - 代码提交

如需重新开始新的需求流程，请提供新的需求描述。
