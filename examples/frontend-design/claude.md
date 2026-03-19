# frontend-design - Claude 使用示例

## 配置（首次使用）

```bash
mkdir -p ~/.claude/skills ~/.claude/agents
cp skills/master-coordinator/SKILL.md ~/.claude/skills/
cp .claude/agents/frontend-design.md ~/.claude/agents/
cp .claude/agents/tech-lead.md ~/.claude/agents/
```

## 使用方式（无需脚本）

```bash
claude
```

在对话中：

```
请保持当前会话作为 master-coordinator。
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 plan.md，frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再询问我是“通过”还是“继续澄清/修订”。
后续评审修订继续交给 frontend-design subagent；如涉及设计与技术冲突，可并行交给 frontend-design 和 tech-lead。

## PRD
{粘贴 .collaboration/features/mobile-login/prd.md 内容}

## API 契约
{粘贴 .collaboration/features/mobile-login/api.yaml 内容}

## 设计要求
- 移动端优先
- 支持深色模式
- 无障碍访问 WCAG 2.1 AA
- 配色方案：品牌蓝色 (#1890ff)
```

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
