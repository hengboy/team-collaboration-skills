# Agents Directory

本目录存放 subagent 的逻辑源文件。

## 设计原则

- `SKILL.md` 是 skill 的单一事实源
- `AGENT.md` 是 subagent 的逻辑事实源
- `AGENT.md` 允许删减示例和长解释
- `AGENT.md` 不允许改写核心能力契约
- 各平台运行时文件由脚本生成，不直接手写维护
- `AGENT.md` 源文件只保留中性元数据：`name`、`description`

## 核心能力契约

每个 agent 必须与对应 skill 在以下方面保持一致：

- 角色定位
- 必须输入
- 可选输入
- 输出文件
- 执行规则
- 质量检查
- 下一步流程

当前通过 `## 核心契约（供 AGENT 派生）` 这一节做同步校验。

## 平台适配

运行时文件由 [sync-platform-adapters.sh](/Users/yuqiyu/AiHistorys/team-collaboration-skills/scripts/sync-platform-adapters.sh) 从 `skills/` 和 `agents/` 生成。
默认只同步 agents；skills 需要显式参数：

- Claude Code: `.claude/skills/`、`.claude/agents/`
- Gemini CLI: `.gemini/skills/`、`.gemini/agents/`
- OpenCode: `.opencode/agents/`
- Codex: `.codex/agents/`

说明：

- `skills/` 和 `agents/` 继续作为可读、可审查、可同步的源文件
- 隐藏目录下的运行时文件为生成物，不建议手动修改

## 当前 agent

- `project-manager`
- `frontend-design`
- `tech-lead`

## 校验方式

运行同步脚本：

```bash
./scripts/sync-skill-agent.sh
```

生成平台适配文件：

```bash
./scripts/sync-platform-adapters.sh
```

如需同时同步 skills：

```bash
./scripts/sync-platform-adapters.sh --with-skills
```

或检查单个 agent：

```bash
./scripts/sync-skill-agent.sh project-manager
```

脚本会：

- 扫描 `agents/*/AGENT.md`
- 检查 skill 与 agent 是否都具备统一结构
- 对比两边的 `核心契约` 是否一致
- 汇总全部差异，而不是遇到第一处差异就退出
