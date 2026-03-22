# frontend-design - OpenCode 使用示例

## Feature 模式：由 feature-coordinator 调用 subagent

```bash
opencode

skill(name: feature-coordinator)

请继续协调当前 feature。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 `.collaboration/features/{feature-name}/plan.md`，@frontend-design 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始；若 `workspace_mode` 是 `single-repo`，启动后立即检查三者状态，任一未成功启动则立刻重启，直到三者并行运行。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再用结构化选项问我是否通过：
- [ ] 通过，进入下一阶段
- [ ] 继续澄清/修订
如果当前平台不支持勾选，要求我直接回复：通过 / 继续澄清/修订
补充意见：____
后续评审修订继续回派给 @frontend-design；如涉及设计与技术冲突，可并行回派给 @frontend-design 和 @tech-lead。

## PRD
@.collaboration/features/{feature-name}/prd.md
```

## Bug 模式：由 bug-coordinator 调用 subagent

```bash
opencode

skill(name: bug-coordinator)

请继续协调当前 bug。
如果修复涉及 UI、交互、组件边界或文案调整，请调用 @frontend-design，并让它按 Bug 模式输出 `.collaboration/bugs/{bug-name}/design-change.md`。
`.collaboration/bugs/{bug-name}/design-change.md` 只描述受影响页面、组件、交互、文案和状态变化，不输出完整实现代码。

## Bug
@.collaboration/bugs/{bug-name}/bug.md

## Fix Plan
@.collaboration/bugs/{bug-name}/fix-plan.md
```

说明：

- `frontend-design` 在 Feature 模式下输出 `.collaboration/features/{feature-name}/design.md` 与 `.collaboration/features/{feature-name}/design-components.md`
- `frontend-design` 在 Bug 模式下只输出 `.collaboration/bugs/{bug-name}/design-change.md`
- 不建议在协调链路里直接切成 `skill(name: frontend-design)`
