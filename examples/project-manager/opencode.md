# project-manager - OpenCode 使用示例

## Feature 模式：由 feature-coordinator 调用 subagent

```bash
opencode

skill(name: feature-coordinator)

请继续协调当前 feature。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 `.collaboration/features/{feature-name}/plan.md`，@frontend-design 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始；若 `workspace_mode` 是 `single-repo`，启动后立即检查三者状态，任一未成功启动则立刻重启，直到三者并行运行。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再用选择框问我是否通过：
- [ ] 通过，进入下一阶段
- [ ] 继续澄清/修订
补充意见：____

## PRD
@.collaboration/features/{feature-name}/prd.md
```

## Bug 模式：由 bug-coordinator 调用 subagent

```bash
opencode

skill(name: bug-coordinator)

请继续协调当前 bug。
如果修复涉及跨团队、分阶段发布、资源冲突或需要节奏规划，请调用 @project-manager，并让它按 Bug 模式输出 `.collaboration/bugs/{bug-name}/execution-plan.md`。
`.collaboration/bugs/{bug-name}/execution-plan.md` 需要覆盖阶段拆分、责任人、依赖对接点、发布窗口、风险与回滚关注点。

## Bug
@.collaboration/bugs/{bug-name}/bug.md

## Fix Plan
@.collaboration/bugs/{bug-name}/fix-plan.md
```

说明：

- `project-manager` 在 Feature 模式下输出 `.collaboration/features/{feature-name}/plan.md`
- `project-manager` 在 Bug 模式下只输出 `.collaboration/bugs/{bug-name}/execution-plan.md`
- 普通缺陷不需要强行进入 `project-manager`
