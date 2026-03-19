# tech-lead - Claude 使用示例

## 配置

```bash
mkdir -p ~/.claude/skills ~/.claude/agents
cp skills/master-coordinator/SKILL.md ~/.claude/skills/
cp .claude/agents/frontend-design.md ~/.claude/agents/
cp .claude/agents/tech-lead.md ~/.claude/agents/
```

## 使用方式

```bash
claude
```

在对话中：

```
请保持当前会话作为 master-coordinator。
并行使用 project-manager 和 tech-lead subagents，其中 tech-lead 不需要等待 plan.md。
每轮结果先由你统一汇总，再询问我是“通过”还是“继续澄清/修订”。
需要时再使用 frontend-design subagent，后续评审修订继续交给 tech-lead subagent。

## PRD
{粘贴 .collaboration/features/{feature-name}/prd.md 内容}

## Plan
{粘贴 .collaboration/features/{feature-name}/plan.md 内容}
```

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
