# tech-lead - Claude 使用示例

## 配置

```bash
mkdir -p ~/.claude/skills ~/.claude/agents
cp -R skills/feature-coordinator ~/.claude/skills/
cp -R skills/bug-coordinator ~/.claude/skills/
cp .claude/agents/tech-lead.md ~/.claude/agents/
```

## Feature 模式

在对话中：

```text
请保持当前会话作为 feature-coordinator。
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 plan.md，frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再询问我是“通过”还是“继续澄清/修订”。
后续评审修订继续交给 tech-lead subagent；如涉及设计与技术冲突，可并行交给 tech-lead 和 frontend-design。

## PRD
{粘贴 .collaboration/features/{feature-name}/prd.md 内容}

## Plan
{粘贴 .collaboration/features/{feature-name}/plan.md 内容}
```

## Bug 模式

```text
请保持当前会话作为 bug-coordinator。
默认使用 tech-lead subagent，并让它按 Bug 模式基于 bug.md 输出 fix-plan.md。
fix-plan.md 必须覆盖根因判断、影响模块、修复策略、API 或契约变化、兼容性、回归风险与验证重点。
如果修复已经演变成新增能力或接口重设，请停止当前缺陷链路并提示我回到 product-manager。

## Bug
{粘贴 .collaboration/bugs/{bug-name}/bug.md 内容}
```
