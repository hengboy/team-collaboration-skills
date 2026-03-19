# Agents Directory

本目录存放 subagent 的逻辑源文件。

## 设计原则

- `AGENT.md` 允许精简示例和长解释
- 各平台运行时文件由脚本生成，不直接手写维护
- `AGENT.md` 源文件只保留中性元数据：`name`、`description`

## 平台适配

运行时文件由 [sync-platform-adapters.sh](/Users/yuqiyu/AiHistorys/team-collaboration-skills/scripts/sync-platform-adapters.sh) 从 `agents/` 生成。

- Claude Code: `.claude/agents/`
- Gemini CLI: `.gemini/agents/`
- OpenCode: `.opencode/agents/`
- Codex: `.codex/agents/`

说明：

- `agents/` 继续作为可读、可审查的源文件
- 隐藏目录下的运行时文件为生成物，不建议手动修改

## 当前 agent

- `project-manager`
- `frontend-design`
- `tech-lead`

## 生成平台适配文件

```bash
./scripts/sync-platform-adapters.sh
```
