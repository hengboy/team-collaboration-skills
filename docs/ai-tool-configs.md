# AI 工具配置指南

## 概述

所有 Skills 均使用 Markdown 格式，可配置到主流 AI 工具。

推荐采用双主链路混合模式：

- Feature 链路：`product-manager`、`feature-coordinator` 保持在当前会话；`project-manager`、`frontend-design`、`tech-lead` 通过 subagent 调用
- Bug 链路：`bug-coordinator` 保持在当前会话；`tech-lead` 默认通过 subagent 调用，`frontend-design`、`project-manager` 按需调用
- Bug 业务实现不在当前协作仓直接执行，而是由前后端业务仓消费 `.collaboration/bugs/{bug-name}/` 下的 handoff 文档后各自编码

---

## OpenCode

如需使用 OpenCode subagent 运行时，先生成 agents 适配文件：

```bash
./scripts/sync-platform-adapters.sh
```

### Feature 主链路

```bash
opencode

skill(name: feature-coordinator)

请继续负责 mobile-login 的协调工作。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 plan.md，@frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再问我是“通过”还是“继续澄清/修订”。
如果你发现评审里已经变成新增功能，而不是当前 PRD 范围内修订，请直接提示我要回到 product-manager 重头开始。

## PRD
@.collaboration/features/mobile-login/prd.md
```

### Bug 主链路

```bash
opencode

skill(name: bug-coordinator)

请继续协调 payment-submit-500 的缺陷修复。
先补齐 `.collaboration/bugs/payment-submit-500/bug.md`，并默认调用 @tech-lead 的 Bug 模式产出 `fix-plan.md`。
如果修复涉及 UI / 交互调整，可按需调用 @frontend-design 的 Bug 模式输出 `design-change.md`。
如果修复涉及分阶段发布或跨团队协调，可按需调用 @project-manager 的 Bug 模式输出 `execution-plan.md`。
如果判断是联调 / 接口边界缺陷，请分别生成 `frontend-handoff.md` 和 `backend-handoff.md`。
业务仓回传 PR、测试结果和变更摘要后，再统一进入 qa-engineer 和 code-reviewer 的 Bug 模式。
如果识别到这不是缺陷而是新增需求，请直接提示我要回到 product-manager。

## 原始问题
- 环境：生产环境
- 影响版本：web 2.8.4 / api 3.1.7
- 现象：支付确认页点击“立即支付”后返回 500
```

### 配置全局 Skills

```bash
cp -r skills/* ~/.config/opencode/skills/
```

---

## Claude Desktop

先运行一次运行时同步：

```bash
./scripts/sync-platform-adapters.sh
```

### 配置 Skills / Agents

```bash
mkdir -p ~/.claude/skills ~/.claude/agents
cp -R skills/* ~/.claude/skills/
cp .claude/agents/project-manager.md ~/.claude/agents/
cp .claude/agents/frontend-design.md ~/.claude/agents/
cp .claude/agents/tech-lead.md ~/.claude/agents/
```

升级双模式契约后，建议重新执行整目录复制，确保 `qa-engineer`、`code-reviewer`、`frontend`、`backend-*` 等角色读取到最新约束。

### Feature 主链路用法

在对话中：

```text
请保持当前会话作为 feature-coordinator。
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 plan.md，frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再询问我是“通过”还是“继续澄清/修订”。
如果你发现评审里已经变成新增功能，而不是当前 PRD 范围内修订，请直接提示我要回到 product-manager 重头开始。

## PRD
{粘贴 .collaboration/features/mobile-login/prd.md 内容}
```

### Bug 主链路用法

```text
请保持当前会话作为 bug-coordinator。
先补齐 `.collaboration/bugs/payment-submit-500/bug.md`，并默认使用 tech-lead subagent 的 Bug 模式产出 `fix-plan.md`。
如果修复涉及 UI / 交互调整，可按需使用 frontend-design subagent 的 Bug 模式输出 `design-change.md`。
如果修复涉及分阶段发布或跨团队协调，可按需使用 project-manager subagent 的 Bug 模式输出 `execution-plan.md`。
如果判断是联调 / 接口边界缺陷，请分别生成 `frontend-handoff.md` 和 `backend-handoff.md`，交给前后端业务仓消费。
业务仓回传 PR、测试结果和变更摘要后，再统一进入 qa-engineer 和 code-reviewer 的 Bug 模式。
如果识别到这不是缺陷而是新增需求，请直接提示我要回到 product-manager。
```

---

## GitHub Copilot

### 配置 Instructions

```bash
mkdir -p .github
cat skills/backend-typescript/SKILL.md >> .github/copilot-instructions.md
```

### 使用方式

Feature 实现：

```text
作为后端工程师，请实现登录接口。

## API 契约
@.collaboration/features/mobile-login/api.yaml
```

Bug 业务仓实现：

```text
skill(name: backend-typescript)
或
skill(name: backend-springboot)

请基于最新的 `.collaboration/bugs/payment-submit-500/backend-handoff.md` 实现修复，并回传：
- PR 链接
- 测试结果
- 变更摘要
```

---

## Cursor

### 配置 Rules

```bash
cat skills/backend-typescript/SKILL.md >> .cursorrules
```

### 使用方式

Feature 实现：

```text
作为前端工程师，请实现手机号登录页面。

## 设计方案
@.collaboration/features/mobile-login/design.md
```

Bug 业务仓实现：

```text
skill(name: frontend)

请基于最新的 `.collaboration/bugs/payment-submit-500/frontend-handoff.md` 实现修复，并回传：
- PR 链接
- 测试结果
- 变更摘要
```

---

## 通用使用方法

### Feature 链路

```text
skill(name: feature-coordinator)

请继续协调当前 feature。
并行调用 @project-manager、@tech-lead 和 @frontend-design，且 @tech-lead 不等待 plan.md，@frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再问我是“通过”还是“继续澄清/修订”。
如果你发现评审里已经变成新增功能，而不是当前 PRD 范围内修订，请直接提示我要回到 product-manager 重头开始。
```

### Bug 链路

```text
skill(name: bug-coordinator)

请继续协调当前 bug。
先补齐 `.collaboration/bugs/{bug-name}/bug.md`，并默认调用 tech-lead 的 Bug 模式产出 `fix-plan.md`。
如需设计修订或执行节奏规划，可按需调用 frontend-design / project-manager 的 Bug 模式。
如果判断是联调 / 接口边界缺陷，请分别生成 `frontend-handoff.md` 和 `backend-handoff.md`。
业务仓回传 PR、测试结果和变更摘要后，再统一进入 qa-engineer 和 code-reviewer 的 Bug 模式。
如果识别到这不是缺陷而是新增需求，请直接提示我要回到 product-manager。
```

### 业务仓实现 handoff 模板

```text
请基于最新的 `.collaboration/bugs/{bug-name}/frontend-handoff.md` 或 `.collaboration/bugs/{bug-name}/backend-handoff.md` 实现修复。
前端问题使用 `frontend` Skill 的 Bug 模式，后端问题使用 `backend-typescript` 或 `backend-springboot` Skill 的 Bug 模式。
修复完成后请回传：
- PR 链接
- 测试结果
- 变更摘要
```

### 收口提示

- Feature 与 Bug 都应在 QA / Review 后再进入 `git-commit`
- Bug 场景下，协作仓只负责文档与收口，不直接在当前仓写业务代码
- 若“修复”扩大为新增功能，则从当前链路回退到 `product-manager`
