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
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 plan.md，frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再询问我是“通过”还是“继续澄清/修订”。
后续评审修订继续交给 tech-lead subagent；如涉及设计与技术冲突，可并行交给 tech-lead 和 frontend-design。

## PRD
{粘贴 .collaboration/features/{feature-name}/prd.md 内容}

## Plan
{粘贴 .collaboration/features/{feature-name}/plan.md 内容}
```

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
