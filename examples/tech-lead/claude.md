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
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 `.collaboration/features/{feature-name}/plan.md`，frontend-design 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始；若 `workspace_mode` 是 `single-repo`，启动后立即检查三者状态，任一未成功启动则立刻重启，直到三者并行运行。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再用下面的结构化选项询问我是否通过：
- [ ] 通过，进入下一阶段
- [ ] 继续澄清/修订
如果当前平台不支持勾选，要求我直接回复：通过 / 继续澄清/修订
补充意见：____
后续评审修订继续交给 tech-lead subagent；如涉及设计与技术冲突，可并行交给 tech-lead 和 frontend-design。

## PRD
{粘贴 .collaboration/features/{feature-name}/prd.md 内容}

## Plan
{粘贴 .collaboration/features/{feature-name}/plan.md 内容}
```

## Bug 模式

```text
请保持当前会话作为 bug-coordinator。
默认使用 tech-lead subagent，并让它按 Bug 模式基于 `.collaboration/bugs/{bug-name}/bug.md` 输出 `.collaboration/bugs/{bug-name}/fix-plan.md`。
`.collaboration/bugs/{bug-name}/fix-plan.md` 必须覆盖根因判断、影响模块、修复策略、API 或契约变化、兼容性、回归风险与验证重点。
如果修复已经演变成新增能力或接口重设，请停止当前缺陷链路并提示我回到 product-manager。

## Bug
{粘贴 .collaboration/bugs/{bug-name}/bug.md 内容}
```
