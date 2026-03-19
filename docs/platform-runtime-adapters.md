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

说明：

- `model` 与 `tools` 来自 Claude Code subagent 官方 frontmatter 能力
- `color` 来自 Claude Code `/agents` 交互式创建流程的实际产物与 UI 选项
- 截至 `2026-03-19`，官方“Supported frontmatter fields”表中未明确列出 `color`，因此本仓库将其视为 CLI 实际兼容字段，而不是文档已正式承诺的核心字段

### Gemini CLI

- `name`
- `description`
- `kind: local`

### OpenCode

- `description`
- `mode: subagent`

说明：

- OpenCode Markdown agent 的名字由文件名决定，因此不额外写 `name`
- `tools` 在 OpenCode 文档中已标记为 deprecated，本仓库适配层默认不生成

### Codex

- `name`
- `description`
- `developer_instructions`

说明：

- Codex subagent 运行时格式是 TOML，不是 Markdown frontmatter
- 因此 Codex 必须单独生成 `.toml` 文件，不能直接复用 `AGENT.md`

## 调用方式提示

不同平台的调用方式不统一，因此需要分别说明。

### OpenCode

- skill: 原生 `skill(name: xxx)` 工具
- subagent: `@agent-name`

协同链路推荐写法：

```text
skill(name: master-coordinator)

请继续负责当前 feature 的协调工作。

并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 plan.md，@frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再回给你统一评审并问我是“通过”还是“继续澄清/修订”。
如果你发现评审里已经变成新增功能，而不是当前 PRD 范围内修订，请直接提示我要回到 product-manager 重头开始。
后续评审修订继续回派给对应 subagent。
```

### Claude Code

- skill: 自动触发或 `/skill-name`
- subagent: 自动委派，或用自然语言显式要求使用某 subagent

协同链路推荐写法：

```text
请保持当前会话作为 master-coordinator。
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 plan.md，frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再询问我是“通过”还是“继续澄清/修订”。
如果你发现评审里已经变成新增功能，而不是当前 PRD 范围内修订，请直接提示我要回到 product-manager 重头开始。
后续修订继续交给对应 subagents 处理，不要直接切换成对应 skill。
```

### Gemini CLI

- skill: 由 agent 通过 `activate_skill` 自动激活
- subagent: 自动委派或 `@agent-name`

协同链路推荐写法：

```text
激活 master-coordinator skill。
并行调用 @project-manager、@tech-lead 和 @frontend-design，且 tech-lead 不等待 plan.md，@frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再由协调器汇总并询问我是“通过”还是“继续澄清/修订”。
如果发现新增功能，则停止当前链路并提示我回到 product-manager 重头开始。
```

### Codex

- skill: 自动触发或显式 skill 调用
- subagent: 使用 `.codex/agents/*.toml` 定义，并通过 `spawn_agent` 选择对应 `agent_type`

协同链路推荐写法：

```text
当前主会话继续执行 master-coordinator。
先分别用 spawn_agent 并行调用 project-manager、tech-lead 和 frontend-design subagents，且 tech-lead 不等待 plan.md，frontend-design 直接基于 PRD 开始。
首轮需要先回收到 plan.md、tech.md、api.yaml、design.md、design-components.md，再由 master-coordinator 汇总并询问用户“通过”还是“继续澄清/修订”。
如果发现新增功能，则停止当前链路并提示用户回到 product-manager 重头开始。
后续修订继续 send_input 给对应 subagent，不要让主会话直接改成这些角色。
```

实现阶段推荐写法：

```text
联合评审已通过。
当前主会话不要继续用 spawn_agent 调用 frontend、backend-typescript 或 backend-springboot，这些实现类角色不是 subagent。

请直接在当前主会话中进入 skill(name: frontend)。
输入 design.md、design-components.md、api.yaml，并完成前端实现、质量检查和结果汇总。

请直接在当前主会话中进入 skill(name: backend-springboot)。
输入 tech.md、api.yaml，并完成后端实现、质量检查和结果汇总。
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
