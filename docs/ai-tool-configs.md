# AI 工具配置指南

本文件说明如何把当前仓库的 skills / agents 接入不同 AI 工具，并保持与仓库中的事实源一致。

## 默认推荐拓扑

- 默认在业务仓直接配置 `skills` / `subagents` 并使用，`workspace_mode` 走 `single-repo`
- 如需兼容老的协作仓 + 业务仓分离流程，请在 `.collaboration/shared/workspace.md` 中显式声明 `workspace_mode: split-repo`
- `split-repo` 下 Feature 联合评审通过后，只提示是否提交并推送当前协作文档，不在协作仓进入 `frontend` / `backend-*`

## 推荐前置步骤

首次接入或更新 runtime 前，先运行：

```bash
./scripts/generate-agents-from-skills.sh
./scripts/sync-skill-agent.sh
./scripts/sync-platform-adapters.sh --with-skills
```

脚本说明见 [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)。

## OpenCode

### 建议方式

- 默认在业务仓直接使用仓库中的 `skills/`
- subagent runtime 由 `.opencode/agents/` 提供

### 推荐命令

```bash
./scripts/generate-agents-from-skills.sh
./scripts/sync-platform-adapters.sh --agents-only
cp -r skills/* ~/.config/opencode/skills/
```

### Feature 主链路示例

```text
skill(name: feature-coordinator)

请继续负责 mobile-login 的协调工作。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 `.collaboration/features/mobile-login/plan.md`，@frontend-design 直接基于 `.collaboration/features/mobile-login/prd.md` 开始。
首轮需先补齐 `.collaboration/features/mobile-login/plan.md`、`.collaboration/features/mobile-login/tech.md`、`.collaboration/features/mobile-login/api.yaml`、`.collaboration/features/mobile-login/design.md`、`.collaboration/features/mobile-login/design-components.md`，再问我是“通过”还是“继续澄清/修订”。
如果 `workspace_mode` 是 `split-repo`，联合评审通过后只提示我是否提交并推送当前协作文档，不进入 `frontend` / `backend-*`。
```

### Bug 主链路示例

```text
skill(name: bug-coordinator)

请继续协调 payment-submit-500 的缺陷修复。
先补齐 `.collaboration/bugs/payment-submit-500/bug.md`，并默认调用 @tech-lead 的 Bug 模式产出 `.collaboration/bugs/payment-submit-500/fix-plan.md`。
如果判断是联调 / 接口边界缺陷，请分别生成 `.collaboration/bugs/payment-submit-500/frontend-handoff.md` 和 `.collaboration/bugs/payment-submit-500/backend-handoff.md`。
handoff 必须保留；`single-repo` 下由当前仓实现角色消费，`split-repo` 下交给外部业务仓消费。
```

## Claude Code

### 推荐命令

```bash
./scripts/generate-agents-from-skills.sh
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
./scripts/generate-agents-from-skills.sh
./scripts/sync-platform-adapters.sh --with-skills
```

生成后的 runtime 位于：

- `.gemini/skills/`
- `.gemini/agents/`

## Codex

### 推荐命令

```bash
./scripts/generate-agents-from-skills.sh
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
- 默认在业务仓中以 `.collaboration/...` 文档路径作为输入上下文
- 如采用 `split-repo`，请先在协作仓提交 `.collaboration/shared/workspace.md` 并显式声明 `split-repo`

## 通用提示模板

### Feature

```text
skill(name: feature-coordinator)

请继续协调当前 feature。
并行调用 @project-manager、@tech-lead 和 @frontend-design。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再问我是“通过”还是“继续澄清/修订”。
如 `workspace_mode` 为 `split-repo`，联合评审通过后只提示是否提交并推送当前协作文档，不进入 `frontend` / `backend-*`。
```

### Bug

```text
skill(name: bug-coordinator)

请继续协调当前 bug。
先补齐 `.collaboration/bugs/{bug-name}/bug.md`，并默认调用 tech-lead 的 Bug 模式产出 `.collaboration/bugs/{bug-name}/fix-plan.md`。
如需设计修订或执行节奏规划，可按需调用 frontend-design / project-manager 的 Bug 模式。
handoff 必须保留；`single-repo` 由当前仓实现角色消费，`split-repo` 由外部业务仓消费。
```

## 相关文档

- [README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/README.md)
- [docs/workspace-modes.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/workspace-modes.md)
- [docs/platform-runtime-adapters.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/platform-runtime-adapters.md)
- [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)
