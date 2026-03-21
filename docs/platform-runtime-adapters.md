# 平台运行时适配

本仓库采用三层结构：

- `skills/`：skill 事实源
- `agents/`：从白名单 skill 派生的 subagent 逻辑源
- 隐藏目录：各平台 runtime 生成物

## 目录映射

### Skills

- Claude Code: `.claude/skills/<name>/SKILL.md`
- Gemini CLI: `.gemini/skills/<name>/SKILL.md`
- OpenCode: 默认继续使用仓库 `skills/` 事实源
- Codex: 默认继续使用仓库 `skills/` 事实源

### Agents

- Claude Code: `.claude/agents/<name>.md`
- Gemini CLI: `.gemini/agents/<name>.md`
- OpenCode: `.opencode/agents/<name>.md`
- Codex: `.codex/agents/<name>.toml`

## 生成脚本

相关脚本详解见 [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)。

常用命令：

```bash
./scripts/generate-agents-from-skills.sh
./scripts/sync-platform-adapters.sh --agents-only
./scripts/sync-platform-adapters.sh --with-skills
./scripts/verify-platform-adapters.sh
```

说明：

- `./scripts/sync-platform-adapters.sh` 默认只同步 agents
- `--with-skills` 会同步 `.claude/skills` 与 `.gemini/skills`
- `./scripts/verify-platform-adapters.sh` 会串联校验、重生成和 diff hygiene 检查

## 元数据策略

为避免把多家 frontmatter 混写在一份文件里，运行时适配层只生成各平台的最小安全字段集。

源文件约束：

- `skills/*/SKILL.md` 只保留 skill 通用元数据
- `agents/*/AGENT.md` 由 `./scripts/generate-agents-from-skills.sh` 从白名单 skill 派生，且只保留 agent 逻辑源需要的最小元数据：`name`、`description`
- 平台专属字段只出现在生成后的 runtime 文件里

## 平台调用提示

### OpenCode

- skill: `skill(name: xxx)`
- subagent: `@agent-name`

Feature 协同链路推荐写法：

```text
skill(name: feature-coordinator)

请继续负责当前 feature 的协调工作。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 `.collaboration/features/{feature-name}/plan.md`，@frontend-design 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始；若 `workspace_mode` 为 `single-repo`，启动后立即检查三者状态，任一未成功启动则立刻重启，直到三者并行运行。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再由你统一评审并用下面的选择框询问我是否通过：
- [ ] 通过，进入下一阶段
- [ ] 继续澄清/修订
补充意见：____
若 `workspace_mode` 为 `single-repo` 且我明确选择“通过”，继续由你并行调用 @frontend 和对应 @backend-*，实现证据齐备后再串行调用 @qa-engineer、@code-reviewer。
```

Bug 协同链路推荐写法：

```text
skill(name: bug-coordinator)

请继续负责当前 bug 的协调工作。
先补齐 `.collaboration/bugs/{bug-name}/bug.md`，并默认调用 @tech-lead 的 Bug 模式产出 `.collaboration/bugs/{bug-name}/fix-plan.md`。
如需设计修订或执行节奏规划，可按需调用 @frontend-design、@project-manager 的 Bug 模式。
如果判断是联调 / 接口边界缺陷，请分别生成 `.collaboration/bugs/{bug-name}/frontend-handoff.md` 和 `.collaboration/bugs/{bug-name}/backend-handoff.md`。
若 `workspace_mode` 为 `single-repo`，继续由你并行调用命中的实现 subagent，回收实现证据后再串行调用 @qa-engineer、@code-reviewer。
```

### Claude Code

- skill: 自动触发或 `/skill-name`
- subagent: 自动委派，或用自然语言显式要求使用某 subagent

推荐先运行：

```bash
./scripts/generate-agents-from-skills.sh
./scripts/sync-platform-adapters.sh --with-skills
```

### Gemini CLI

- skill: 通过 skill activation 或当前提示触发
- subagent: 自动委派或 `@agent-name`

推荐先运行：

```bash
./scripts/generate-agents-from-skills.sh
./scripts/sync-platform-adapters.sh --with-skills
```

### Codex

- skill: 当前仓库 `skills/` 事实源
- subagent: 使用 `.codex/agents/*.toml`

推荐先运行：

```bash
./scripts/generate-agents-from-skills.sh
./scripts/sync-platform-adapters.sh --agents-only
```

Codex Feature 协同链路推荐写法：

```text
当前主会话继续执行 feature-coordinator。
先分别用 spawn_agent 并行调用 project-manager、tech-lead 和 frontend-design subagents，且 tech-lead 不等待 `.collaboration/features/{feature-name}/plan.md`，frontend-design 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始；若 `workspace_mode` 为 `single-repo`，立即检查三者的启动状态，任一未成功启动、异常退出或未进入运行态时立刻重新 spawn，直到三者并行运行。
首轮需要先回收到 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再由 feature-coordinator 汇总并用选择框询问用户“通过”还是“继续澄清/修订”，同时允许填写补充意见。
若用户明确选择“通过”且 `workspace_mode` 为 `single-repo`，继续并行调用 frontend 和对应 backend-* subagents，回收实现证据后再串行调用 qa-engineer、code-reviewer。
```

联合评审通过后的可复制模板见 [docs/ai-tool-configs.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/ai-tool-configs.md) 中的“联合评审通过后的标准提示模板”。

## 提交前检查

生成后至少执行：

```bash
./scripts/generate-agents-from-skills.sh
./scripts/sync-skill-agent.sh
git diff --check
./scripts/verify-platform-adapters.sh
```
