# 平台运行时适配

本仓库采用：

- `skills/` 作为 skill 内容源
- `agents/` 作为 subagent 逻辑源
- 隐藏目录作为各平台运行时适配层

## 目录映射

### Skills

- Claude Code: `.claude/skills/<name>/SKILL.md`
- Gemini CLI: `.gemini/skills/<name>/SKILL.md`
- OpenCode: 本仓库当前不生成独立 runtime 副本，继续使用仓库 `skills/` 事实源；如需全局共享，可复制到 `~/.config/opencode/skills/`
- Codex: 本仓库当前不生成独立 runtime 副本，继续使用仓库 `skills/` 事实源

### Agents

- Claude Code: `.claude/agents/<name>.md`
- Gemini CLI: `.gemini/agents/<name>.md`
- OpenCode: `.opencode/agents/<name>.md`
- Codex: `.codex/agents/<name>.toml`

## 元数据策略

为避免把多家 frontmatter 混写在一份文件里，运行时适配层只生成各平台的最小安全字段集。

源文件约束：

- `skills/*/SKILL.md` 只保留 skill 通用元数据
- `agents/*/AGENT.md` 只保留逻辑源需要的最小元数据：`name`、`description`
- 平台专属字段只出现在生成后的运行时适配文件里

### Claude Code

- `name`
- `description`
- `model`
- `tools`
- `color`

### Gemini CLI

- `name`
- `description`
- `kind: local`

### OpenCode

- `description`
- `mode: subagent`

### Codex

- `name`
- `description`
- `developer_instructions`

## 调用方式提示

不同平台的调用方式不统一，因此需要分别说明。

### OpenCode

- skill: 原生 `skill(name: xxx)` 工具
- subagent: `@agent-name`

Feature 协同链路推荐写法：

```text
skill(name: feature-coordinator)

请继续负责当前 feature 的协调工作。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 plan.md，@frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再回给你统一评审并问我是“通过”还是“继续澄清/修订”。
如果你发现评审里已经变成新增功能，而不是当前 PRD 范围内修订，请直接提示我要回到 product-manager 重头开始。
```

Bug 协同链路推荐写法：

```text
skill(name: bug-coordinator)

请继续负责当前 bug 的协调工作。
先补齐 `.collaboration/bugs/{bug-name}/bug.md`，并默认调用 @tech-lead 产出 `fix-plan.md`。
如果判断是联调 / 接口边界缺陷，请分别生成 `frontend-handoff.md` 和 `backend-handoff.md`。
业务仓回传 PR、测试结果和变更摘要后，再统一进入 qa-engineer 和 code-reviewer。
如果识别到这不是缺陷而是新增需求，请提示我回到 product-manager。
```

### Claude Code

- skill: 自动触发或 `/skill-name`
- subagent: 自动委派，或用自然语言显式要求使用某 subagent

Feature 协同链路推荐写法：

```text
请保持当前会话作为 feature-coordinator。
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 plan.md，frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再询问我是“通过”还是“继续澄清/修订”。
如果你发现评审里已经变成新增功能，而不是当前 PRD 范围内修订，请直接提示我要回到 product-manager 重头开始。
```

Bug 协同链路推荐写法：

```text
请保持当前会话作为 bug-coordinator。
先补齐 `.collaboration/bugs/{bug-name}/bug.md`，并默认使用 tech-lead subagent 产出 `fix-plan.md`。
如果判断是联调 / 接口边界缺陷，请分别生成 `frontend-handoff.md` 和 `backend-handoff.md`，交给前后端业务仓消费。
业务仓回传 PR、测试结果和变更摘要后，再统一进入 qa-engineer 和 code-reviewer。
如果识别到这不是缺陷而是新增需求，请直接提示我要回到 product-manager。
```

### Gemini CLI

- skill: 由 agent 通过 `activate_skill` 自动激活
- subagent: 自动委派或 `@agent-name`

Feature 协同链路推荐写法：

```text
激活 feature-coordinator skill。
并行调用 @project-manager、@tech-lead 和 @frontend-design，且 tech-lead 不等待 plan.md，@frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再由协调器汇总并询问我是“通过”还是“继续澄清/修订”。
如果发现新增功能，则停止当前链路并提示我回到 product-manager 重头开始。
```

Bug 协同链路推荐写法：

```text
激活 bug-coordinator skill。
先补齐 `.collaboration/bugs/{bug-name}/bug.md`，并默认调用 @tech-lead 产出 `fix-plan.md`。
如果判断是联调 / 接口边界缺陷，请生成前后端两份 handoff 文档。
业务仓回传 PR、测试结果和变更摘要后，再统一进入 qa-engineer 和 code-reviewer。
```

### Codex

- skill: 自动触发或显式 skill 调用
- subagent: 使用 `.codex/agents/*.toml` 定义，并通过 `spawn_agent` 选择对应 `agent_type`

Feature 协同链路推荐写法：

```text
当前主会话继续执行 feature-coordinator。
先分别用 spawn_agent 并行调用 project-manager、tech-lead 和 frontend-design subagents，且 tech-lead 不等待 plan.md，frontend-design 直接基于 PRD 开始。
首轮需要先回收到 plan.md、tech.md、api.yaml、design.md、design-components.md，再由 feature-coordinator 汇总并询问用户“通过”还是“继续澄清/修订”。
如果发现新增功能，则停止当前链路并提示用户回到 product-manager 重头开始。
```

Bug 协同链路推荐写法：

```text
当前主会话继续执行 bug-coordinator。
先补齐 `.collaboration/bugs/{bug-name}/bug.md`，并按需用 spawn_agent 调用 tech-lead、frontend-design、project-manager。
若判定为联调 / 接口边界缺陷，则生成 `frontend-handoff.md` 和 `backend-handoff.md`。
等待业务仓回传 PR、测试结果和变更摘要后，再统一进入 qa-engineer 和 code-reviewer。
```

## 生成命令

```bash
./scripts/sync-platform-adapters.sh
```

默认只同步 agents，不同步 skill 副本。

如需显式同步 skills：

```bash
./scripts/sync-platform-adapters.sh --with-skills
```

如需只同步 skills：

```bash
./scripts/sync-platform-adapters.sh --skills-only
```

如需显式只同步 agents：

```bash
./scripts/sync-platform-adapters.sh --agents-only
```

生成后请至少检查：

- `./scripts/sync-skill-agent.sh`
- `git diff --check`
