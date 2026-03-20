# frontend-design - Claude 使用示例

## 配置（首次使用）

```bash
mkdir -p ~/.claude/skills ~/.claude/agents
cp -R skills/feature-coordinator ~/.claude/skills/
cp -R skills/bug-coordinator ~/.claude/skills/
cp .claude/agents/frontend-design.md ~/.claude/agents/
```

## Feature 模式

```text
请保持当前会话作为 feature-coordinator。
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 plan.md，frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再询问我是“通过”还是“继续澄清/修订”。
后续评审修订继续交给 frontend-design subagent；如涉及设计与技术冲突，可并行交给 frontend-design 和 tech-lead。

## PRD
{粘贴 .collaboration/features/{feature-name}/prd.md 内容}
```

## Bug 模式

```text
请保持当前会话作为 bug-coordinator。
如果修复涉及 UI、交互、组件边界或文案调整，请使用 frontend-design subagent，并让它按 Bug 模式输出 design-change.md。
design-change.md 只描述受影响页面、组件、交互、文案和状态变化，不输出完整实现代码。

## Bug
{粘贴 .collaboration/bugs/{bug-name}/bug.md 内容}

## Fix Plan
{粘贴 .collaboration/bugs/{bug-name}/fix-plan.md 内容}
```
