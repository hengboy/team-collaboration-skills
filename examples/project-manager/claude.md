# project-manager - Claude 使用示例

## 配置

```bash
mkdir -p ~/.claude/skills ~/.claude/agents
cp -R skills/feature-coordinator ~/.claude/skills/
cp -R skills/bug-coordinator ~/.claude/skills/
cp .claude/agents/project-manager.md ~/.claude/agents/
```

## Feature 模式

```text
请保持当前会话作为 feature-coordinator。
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 `.collaboration/features/{feature-name}/plan.md`，frontend-design 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再询问我是“通过”还是“继续澄清/修订”。

## PRD
{粘贴 .collaboration/features/{feature-name}/prd.md 内容}
```

## Bug 模式

```text
请保持当前会话作为 bug-coordinator。
如果修复涉及跨团队、分阶段发布、资源冲突或需要节奏规划，请使用 project-manager subagent，并让它按 Bug 模式输出 `.collaboration/bugs/{bug-name}/execution-plan.md`。
`.collaboration/bugs/{bug-name}/execution-plan.md` 需要覆盖阶段拆分、责任人、依赖对接点、发布窗口、风险与回滚关注点。

## Bug
{粘贴 .collaboration/bugs/{bug-name}/bug.md 内容}

## Fix Plan
{粘贴 .collaboration/bugs/{bug-name}/fix-plan.md 内容}
```
