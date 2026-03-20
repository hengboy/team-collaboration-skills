# Agents Directory

本目录存放从白名单 `skills/{name}/SKILL.md` 派生出来的 subagent 逻辑源文件，供各平台 runtime 继续生成。

## 设计原则

- `agents/{name}/AGENT.md` 是派生物，不直接手工维护。
- `agents/{name}/AGENT.md` 只保存 agent 可读、可审查的逻辑源。
- 各平台运行时文件由脚本生成，不直接手写维护。
- 当前默认只为 `project-manager`、`tech-lead`、`frontend-design` 生成 agent。

## 当前 agent

- `project-manager`
- `frontend-design`
- `tech-lead`

这 3 个角色在协作链路中优先作为 subagent 使用，但也允许直接以 skill 方式独立调用。

## 平台生成物

运行时文件由 [sync-platform-adapters.sh](/Users/yuqiyu/AiHistorys/team-collaboration-skills/scripts/sync-platform-adapters.sh) 从 `agents/` 生成，`agents/` 本身由 [generate-agents-from-skills.sh](/Users/yuqiyu/AiHistorys/team-collaboration-skills/scripts/generate-agents-from-skills.sh) 从 `skills/` 派生。

- Claude Code: `.claude/agents/`
- Gemini CLI: `.gemini/agents/`
- OpenCode: `.opencode/agents/`
- Codex: `.codex/agents/`

## 推荐维护顺序

1. 先修改对应的 `skills/{name}/SKILL.md`
2. 运行 `./scripts/generate-agents-from-skills.sh`
3. 运行 `./scripts/sync-skill-agent.sh`
4. 运行 `./scripts/sync-platform-adapters.sh --agents-only` 或 `./scripts/verify-platform-adapters.sh`

## 使用示例

重生成白名单 agent 逻辑源：

```bash
./scripts/generate-agents-from-skills.sh
```

只刷新 agent runtime：

```bash
./scripts/sync-platform-adapters.sh --agents-only
```

校验 `tech-lead` 的 skill / agent 是否仍然对齐：

```bash
./scripts/sync-skill-agent.sh tech-lead
```

全量重生成并校验所有平台生成物：

```bash
./scripts/verify-platform-adapters.sh
```

## 相关文档

- [skills/README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/skills/README.md)
- [docs/skill-agent-sync-guide.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/skill-agent-sync-guide.md)
- [docs/platform-runtime-adapters.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/platform-runtime-adapters.md)
- [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)
