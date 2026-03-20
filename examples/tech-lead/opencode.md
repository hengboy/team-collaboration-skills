# tech-lead - OpenCode 使用示例

## Feature 模式：由 feature-coordinator 调用 subagent

```bash
opencode

skill(name: feature-coordinator)

请继续协调当前 feature。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 plan.md，@frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再问我是“通过”还是“继续澄清/修订”。
后续评审修订继续回派给 @tech-lead；如涉及设计与技术冲突，可并行回派给 @tech-lead 和 @frontend-design。

## PRD
@.collaboration/features/{feature-name}/prd.md

## Plan
@.collaboration/features/{feature-name}/plan.md
```

## Bug 模式：由 bug-coordinator 调用 subagent

```bash
opencode

skill(name: bug-coordinator)

请继续协调当前 bug。
默认调用 @tech-lead，并让它按 Bug 模式基于 bug.md 输出 fix-plan.md。
fix-plan.md 必须覆盖根因判断、影响模块、修复策略、API 或契约变化、兼容性、回归风险与验证重点。
如果修复已经演变成新增能力或接口重设，请停止当前缺陷链路并提示我回到 product-manager。

## Bug
@.collaboration/bugs/{bug-name}/bug.md
```

说明：

- `tech-lead` 在 Feature 链路中由 `feature-coordinator` 调用，在 Bug 链路中由 `bug-coordinator` 调用
- Feature 模式输出 `tech.md` 与 `api.yaml`
- Bug 模式只输出 `fix-plan.md`，不再生成 `api.yaml`
