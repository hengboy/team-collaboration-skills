# AI 工具配置指南

本文件说明如何把当前仓库的 skills / agents 接入不同 AI 工具，并保持与仓库中的事实源一致。

## 推荐前置步骤

首次接入或更新 runtime 前，先运行：

```bash
./scripts/sync-skill-agent.sh
./scripts/sync-platform-adapters.sh --with-skills
```

脚本说明见 [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)。

## OpenCode

### 建议方式

- skills 直接使用仓库中的 `skills/`
- subagent runtime 由 `.opencode/agents/` 提供

### 推荐命令

```bash
./scripts/sync-platform-adapters.sh --agents-only
cp -r skills/* ~/.config/opencode/skills/
```

### Feature 主链路示例

```text
skill(name: feature-coordinator)

请继续负责 mobile-login 的协调工作。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 `.collaboration/features/mobile-login/plan.md`，@frontend-design 直接基于 `.collaboration/features/mobile-login/prd.md` 开始。
首轮需先补齐 `.collaboration/features/mobile-login/plan.md`、`.collaboration/features/mobile-login/tech.md`、`.collaboration/features/mobile-login/api.yaml`、`.collaboration/features/mobile-login/design.md`、`.collaboration/features/mobile-login/design-components.md`，再问我是“通过”还是“继续澄清/修订”。
```

### Bug 主链路示例

```text
skill(name: bug-coordinator)

请继续协调 payment-submit-500 的缺陷修复。
先补齐 `.collaboration/bugs/payment-submit-500/bug.md`，并默认调用 @tech-lead 的 Bug 模式产出 `.collaboration/bugs/payment-submit-500/fix-plan.md`。
如果判断是联调 / 接口边界缺陷，请分别生成 `.collaboration/bugs/payment-submit-500/frontend-handoff.md` 和 `.collaboration/bugs/payment-submit-500/backend-handoff.md`。
```

## Claude Code

### 推荐命令

```bash
./scripts/sync-platform-adapters.sh --with-skills
mkdir -p ~/.claude/skills ~/.claude/agents
cp -R .claude/skills/* ~/.claude/skills/
cp .claude/agents/*.md ~/.claude/agents/
```

### 使用提示

- 主链路保持在当前会话
- `project-manager`、`tech-lead`、`frontend-design` 优先作为 subagent 使用
- 如果更新了仓库里的 `skills/` 或 `agents/`，建议重新同步整目录，而不是手动只拷某一个文件

## Gemini CLI

### 推荐命令

```bash
./scripts/sync-platform-adapters.sh --with-skills
```

生成后的 runtime 位于：

- `.gemini/skills/`
- `.gemini/agents/`

## Codex

### 推荐命令

```bash
./scripts/sync-platform-adapters.sh --agents-only
```

说明：

- Codex 继续直接使用仓库 `skills/`
- `.codex/agents/*.toml` 由脚本生成，供 subagent runtime 使用

### Codex 协同示例

```text
当前主会话继续执行 feature-coordinator。
先分别用 spawn_agent 并行调用 project-manager、tech-lead 和 frontend-design subagents。
```

## GitHub Copilot / Cursor

这两类工具没有本仓库统一维护的 runtime 生成脚本，推荐方式是：

- 直接引用对应 `skills/{name}/SKILL.md`
- 或把必要的 skill 内容复制到各自的规则文件
- 业务仓实现时，始终以 `.collaboration/...` 文档路径作为输入上下文

## 通用提示模板

### Feature

```text
skill(name: feature-coordinator)

请继续协调当前 feature。
并行调用 @project-manager、@tech-lead 和 @frontend-design。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再问我是“通过”还是“继续澄清/修订”。
```

### Bug

```text
skill(name: bug-coordinator)

请继续协调当前 bug。
先补齐 `.collaboration/bugs/{bug-name}/bug.md`，并默认调用 tech-lead 的 Bug 模式产出 `.collaboration/bugs/{bug-name}/fix-plan.md`。
如需设计修订或执行节奏规划，可按需调用 frontend-design / project-manager 的 Bug 模式。
```

## 相关文档

- [README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/README.md)
- [docs/platform-runtime-adapters.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/platform-runtime-adapters.md)
- [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)
