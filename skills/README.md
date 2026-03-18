# Skills 使用指南

## 概述

本目录包含 7 个 AI Skills，用于 AI 协作团队的各个角色。

## 可用 Skills

| Skill | 触发短语 | 用途 |
|-------|---------|------|
| **product-manager** | 作为产品经理、帮我写 PRD | 需求分析、PRD |
| **project-manager** | 作为项目经理、帮我排期 | 项目排期、风险评估 |
| **tech-lead** | 作为技术负责人、设计技术方案 | 架构设计、API 契约 |
| **backend-engineer** | 作为后端工程师、帮我写接口 | API 实现、单元测试 |
| **frontend-engineer** | 作为前端工程师、帮我写组件 | React 组件、页面开发 |
| **qa-engineer** | 作为测试工程师、帮我写测试 | 测试用例、自动化测试 |
| **code-reviewer** | 帮我审查代码 | 代码质量、安全审查 |

---

## 使用方式

### OpenCode（推荐）

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: backend-engineer)

# 3. 描述任务（用@引用文件）
请实现登录接口。

## API 契约
@docs/api/auth.yaml

## 技术方案
@docs/tech/mobile-login.md
```

**无需手动打包上下文** - OpenCode 会自动读取 `@` 引用的文件。

### Claude Desktop

```bash
# 1. 打包上下文
./tools/skill-run.sh backend-engineer -c 手机号登录

# 2. 复制上下文
cat .ai-context/context_* | pbcopy

# 3. 在 Claude 中粘贴并描述任务
```

### GitHub Copilot

```bash
# 1. 配置 Instructions
cat skills/backend-engineer/SKILL.md >> .github/copilot-instructions.md

# 2. 在 VS Code 中使用 Copilot Chat
作为后端工程师，请实现登录接口。
```

---

## 完整工作流

```bash
# 1. 产品经理
skill(name: product-manager)
# 创建 PRD

# 2. 技术负责人
skill(name: tech-lead)
# 设计技术方案

# 3. 后端开发
skill(name: backend-engineer)
# 实现 API

# 4. 前端开发
skill(name: frontend-engineer)
# 开发组件

# 5. 测试
skill(name: qa-engineer)
# 编写测试

# 6. 代码审查
skill(name: code-reviewer)
# 审查代码
```

---

## 示例文件

每个 Skill 配有示例输出：

| Skill | 示例文件 |
|-------|---------|
| Product | examples/opencode.md, examples/claude.md |
| Project Manager | examples/opencode.md, examples/claude.md |
| Tech Lead | examples/opencode.md, examples/claude.md |
| Backend | examples/opencode.md, examples/claude.md |
| Frontend | examples/opencode.md, examples/claude.md |
| QA | examples/opencode.md, examples/claude.md |
| Code Review | examples/opencode.md, examples/claude.md |

---

## 工具集成

### skill-run.sh

用于 Claude 等不支持@引用的工具：

```bash
./tools/skill-run.sh <skill-name> -c <功能名称>
```

### new-prd.sh

快速创建 PRD 框架：

```bash
./tools/new-prd.sh <需求名称> [-p P0|P1|P2] [-a @author]
```

### api-validate.sh

验证 OpenAPI 契约规范性：

```bash
./tools/api-validate.sh <API 文件> [-s] [-r]
```

---

## 最佳实践

### ✅ 应该做的

1. 用@引用文件（OpenCode）
2. 明确角色（skill(name: xxx)）
3. 引用文档（@docs/...）
4. 检查质量（使用检查清单）

### ❌ 不应该做的

1. 跳过 Skill 加载
2. 角色混乱
3. 不提供背景信息

---

## 反馈

- GitHub Issues
- 团队周会

**版本**: v2.0.0
