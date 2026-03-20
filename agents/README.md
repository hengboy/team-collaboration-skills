# Agents Directory

本目录存放 subagent 的逻辑源文件，是各平台 runtime agent 的统一事实源。

## 设计原则

- `agents/{name}/AGENT.md` 只保存 agent 可读、可审查的逻辑源。
- 各平台运行时文件由脚本生成，不直接手写维护。
- `AGENT.md` 允许精简背景说明与示例，但不能偏离对应 skill 的主章节与强制约束。

## 当前 agent

- `project-manager`
- `frontend-design`
- `tech-lead`

这 3 个角色在协作链路中优先作为 subagent 使用，但也允许直接以 skill 方式独立调用。

## 平台生成物

运行时文件由 [sync-platform-adapters.sh](/Users/yuqiyu/AiHistorys/team-collaboration-skills/scripts/sync-platform-adapters.sh) 从 `agents/` 生成。

- Claude Code: `.claude/agents/`
- Gemini CLI: `.gemini/agents/`
- OpenCode: `.opencode/agents/`
- Codex: `.codex/agents/`

## 推荐维护顺序

1. 先修改对应的 `skills/{name}/SKILL.md`
2. 再修改 `agents/{name}/AGENT.md`
3. 运行 `./scripts/sync-skill-agent.sh`
4. 运行 `./scripts/sync-platform-adapters.sh --agents-only` 或 `./scripts/verify-platform-adapters.sh`

## 使用示例

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
