# frontend-design - OpenCode 使用示例

## Feature 模式：由 feature-coordinator 调用 subagent

```bash
opencode

skill(name: feature-coordinator)

请继续协调当前 feature。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 plan.md，@frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再问我是“通过”还是“继续澄清/修订”。
后续评审修订继续回派给 @frontend-design；如涉及设计与技术冲突，可并行回派给 @frontend-design 和 @tech-lead。

## PRD
@.collaboration/features/{feature-name}/prd.md
```

## Bug 模式：由 bug-coordinator 调用 subagent

```bash
opencode

skill(name: bug-coordinator)

请继续协调当前 bug。
如果修复涉及 UI、交互、组件边界或文案调整，请调用 @frontend-design，并让它按 Bug 模式输出 design-change.md。
design-change.md 只描述受影响页面、组件、交互、文案和状态变化，不输出完整实现代码。

## Bug
@.collaboration/bugs/{bug-name}/bug.md

## Fix Plan
@.collaboration/bugs/{bug-name}/fix-plan.md
```

说明：

- `frontend-design` 在 Feature 模式下输出 `design.md` 与 `design-components.md`
- `frontend-design` 在 Bug 模式下只输出 `design-change.md`
- 不建议在协调链路里直接切成 `skill(name: frontend-design)`
