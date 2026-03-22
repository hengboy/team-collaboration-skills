# AI 工具配置指南

本文件说明如何把当前仓库的 skills / agents 接入不同 AI 工具，并保持与仓库中的事实源一致。

## 默认推荐拓扑

- 默认在业务仓直接配置 `skills` / `subagents` 并使用，`workspace_mode` 走 `single-repo`
- 如需兼容老的协作仓 + 业务仓分离流程，请在 `.collaboration/shared/workspace.md` 中显式声明 `workspace_mode: split-repo`
- `split-repo` 下 Feature 联合评审通过后，只用结构化选项提示是否提交并推送当前协作文档，并允许填写补充意见；支持选择框的平台可直接勾选，Codex CLI 等不支持的平台直接回复关键词，不在协作仓进入 `frontend` / `backend-*`

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
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 `.collaboration/features/mobile-login/plan.md`，@frontend-design 直接基于 `.collaboration/features/mobile-login/prd.md` 开始；若 `workspace_mode` 是 `single-repo`，启动后立即检查三者状态，任一未成功启动则立刻重启，直到三者并行运行。
首轮需先补齐 `.collaboration/features/mobile-login/plan.md`、`.collaboration/features/mobile-login/tech.md`、`.collaboration/features/mobile-login/api.yaml`、`.collaboration/features/mobile-login/design.md`、`.collaboration/features/mobile-login/design-components.md`，再用下面的结构化选项问我是否通过：
- [ ] 通过，进入下一阶段
- [ ] 继续澄清/修订
补充意见：____
如果 `workspace_mode` 是 `single-repo` 且我选择“通过”，继续由你并行调用 @frontend 和对应 @backend-*，实现证据齐备后再串行调用 @qa-engineer、@code-reviewer。
如果 `workspace_mode` 是 `split-repo`，联合评审通过后只用下面的结构化选项提示我是否提交并推送当前协作文档，不进入 `frontend` / `backend-*`。
- [ ] 提交并推送当前协作文档
- [ ] 暂不提交
补充意见：____
```

### Bug 主链路示例

```text
skill(name: bug-coordinator)

请继续协调 payment-submit-500 的缺陷修复。
先补齐 `.collaboration/bugs/payment-submit-500/bug.md`，并默认调用 @tech-lead 的 Bug 模式产出 `.collaboration/bugs/payment-submit-500/fix-plan.md`。
如果判断是联调 / 接口边界缺陷，请分别生成 `.collaboration/bugs/payment-submit-500/frontend-handoff.md` 和 `.collaboration/bugs/payment-submit-500/backend-handoff.md`。
handoff 必须保留；`single-repo` 下由你并行调用命中的实现 subagent 消费，之后再串行调用 @qa-engineer、@code-reviewer；`split-repo` 下交给外部业务仓消费。
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
- `single-repo` 正式协作链路中的 `frontend`、`backend-*`、`qa-engineer`、`code-reviewer` 也优先由协调器调度为 subagent
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
先分别用 spawn_agent 并行调用 project-manager、tech-lead 和 frontend-design subagents；若 `workspace_mode` 为 `single-repo`，立即检查三者的启动状态，任一未成功启动、异常退出或未进入运行态时立刻重新 spawn，直到三者并行运行。
如需用户确认，请要求用户直接回复关键词或完整选项标签，不要要求勾选或只回复序号。
联合评审通过且 `workspace_mode` 为 `single-repo` 后，再并行调用 frontend 和对应 backend-* subagents，最后串行调用 qa-engineer、code-reviewer。
```

## 联合评审通过后的标准提示模板

以下模板用于“联合评审已经通过，协调器需要继续推进 single-repo 实现阶段”的场景。

### OpenCode Feature

```text
skill(name: feature-coordinator)

当前联合评审已经通过，请继续保持在 feature-coordinator 主会话。
如果 `workspace_mode` 为 `single-repo`，并行调用 @frontend 和对应 @backend-* subagent 消费当前 feature 文档并实现。
要求它们各自回传：
- 变更文件路径
- 执行过的质量检查 / 测试 / 构建命令
- 结果摘要
- 剩余阻塞或风险

待前后端实现证据都齐备且无未关闭阻塞后，再串行调用 @qa-engineer。
待 QA 完成且无 Must-fix 阻塞后，再串行调用 @code-reviewer。
如 `workspace_mode` 为 `split-repo`，不要进入实现阶段，只用下面的结构化选项提示我是否提交并推送协作文档。
- [ ] 提交并推送当前协作文档
- [ ] 暂不提交
补充意见：____
```

### OpenCode Bug

```text
skill(name: bug-coordinator)

当前 bug 的 handoff 已完成，请继续保持在 bug-coordinator 主会话。
如果 `workspace_mode` 为 `single-repo`，按判责结果并行调用命中的实现 subagent：
- 前端缺陷：@frontend
- TypeScript 后端缺陷：@backend-typescript
- Spring Boot 后端缺陷：@backend-springboot
- 联调缺陷：同时调用前端与对应后端

要求实现 subagent 回传：
- 变更文件路径
- diff / 修复摘要
- 执行过的质量检查 / 测试 / 构建命令
- 结果摘要
- 剩余阻塞或风险

实现证据齐备且无未关闭阻塞后，再串行调用 @qa-engineer。
待 QA 完成且无 Must-fix 阻塞后，再串行调用 @code-reviewer。
如 `workspace_mode` 为 `split-repo`，不要在当前仓实现，只继续等待业务仓回传证据。
```

### Claude Code Feature

```text
请继续保持当前主会话为 feature-coordinator。
如果 `workspace_mode` 为 single-repo，联合评审已通过后不要切换主会话去直接调用 skill。
请并行委派 frontend 和对应 backend-* subagents 消费当前 feature 文档并实现，并要求它们分别回传变更文件路径、执行命令、结果摘要与剩余阻塞。
待实现证据齐备且无未关闭阻塞后，再委派 qa-engineer。
待 QA 完成且无 Must-fix 阻塞后，再委派 code-reviewer。
如果 `workspace_mode` 为 split-repo，则不要进入实现阶段，只用下面的结构化选项提示我是否提交并推送协作文档。
- [ ] 提交并推送当前协作文档
- [ ] 暂不提交
补充意见：____
```

### Claude Code Bug

```text
请继续保持当前主会话为 bug-coordinator。
当前 handoff 已齐备。
如果 `workspace_mode` 为 single-repo，请按判责结果并行委派命中的实现 subagents：
- frontend
- backend-typescript
- backend-springboot

要求它们回传变更文件路径、修复摘要、执行命令、结果摘要与剩余阻塞。
实现证据齐备且无未关闭阻塞后，再委派 qa-engineer。
待 QA 完成且无 Must-fix 阻塞后，再委派 code-reviewer。
如果 `workspace_mode` 为 split-repo，则不要在当前仓实现，只继续等待业务仓回传证据。
```

### Codex Feature

```text
当前主会话继续执行 feature-coordinator。
若 `workspace_mode` 为 `single-repo` 且联合评审已经通过，使用 spawn_agent 并行调用 frontend 和对应 backend-* subagents。
要求各 subagent 回传变更文件路径、执行命令、结果摘要与剩余阻塞。
待实现证据齐备且无未关闭阻塞后，再使用 spawn_agent 串行调用 qa-engineer。
待 QA 完成且无 Must-fix 阻塞后，再使用 spawn_agent 串行调用 code-reviewer。
若 `workspace_mode` 为 `split-repo`，不要进入实现阶段，只要求用户直接回复 `提交并推送当前协作文档` 或 `暂不提交`，同时允许填写补充意见；不要要求勾选或只回复序号。
补充意见：____
```

### Codex Bug

```text
当前主会话继续执行 bug-coordinator。
当前 handoff 已齐备。
若 `workspace_mode` 为 `single-repo`，按判责结果使用 spawn_agent 并行调用命中的实现 subagents：
- frontend
- backend-typescript
- backend-springboot

要求各 subagent 回传变更文件路径、修复摘要、执行命令、结果摘要与剩余阻塞。
待实现证据齐备且无未关闭阻塞后，再使用 spawn_agent 串行调用 qa-engineer。
待 QA 完成且无 Must-fix 阻塞后，再使用 spawn_agent 串行调用 code-reviewer。
若 `workspace_mode` 为 `split-repo`，不要在当前仓实现，只继续等待业务仓回传证据。
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
并行调用 @project-manager、@tech-lead 和 @frontend-design；若 `workspace_mode` 为 `single-repo`，启动后立即检查三者状态，任一未成功启动则立刻重启，直到三者并行运行。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再用下面的结构化选项问我是否通过：
- [ ] 通过，进入下一阶段
- [ ] 继续澄清/修订
补充意见：____
如 `workspace_mode` 为 `single-repo` 且我选择“通过”，继续由你并行调用 @frontend 和对应 @backend-*，实现证据齐备后再串行调用 @qa-engineer、@code-reviewer。
如 `workspace_mode` 为 `split-repo`，联合评审通过后只用下面的结构化选项提示是否提交并推送当前协作文档，不进入 `frontend` / `backend-*`。
- [ ] 提交并推送当前协作文档
- [ ] 暂不提交
补充意见：____
```

### Bug

```text
skill(name: bug-coordinator)

请继续协调当前 bug。
先补齐 `.collaboration/bugs/{bug-name}/bug.md`，并默认调用 tech-lead 的 Bug 模式产出 `.collaboration/bugs/{bug-name}/fix-plan.md`。
如需设计修订或执行节奏规划，可按需调用 frontend-design / project-manager 的 Bug 模式。
handoff 必须保留；`single-repo` 由你并行调用命中的实现 subagent 消费，之后再串行调用 @qa-engineer、@code-reviewer；`split-repo` 由外部业务仓消费。
```

## 相关文档

- [README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/README.md)
- [docs/workspace-modes.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/workspace-modes.md)
- [docs/platform-runtime-adapters.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/platform-runtime-adapters.md)
- [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)
