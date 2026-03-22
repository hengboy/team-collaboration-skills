# tech-lead - OpenCode 使用示例

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
默认调用 @tech-lead，并让它按 Bug 模式基于 `.collaboration/bugs/{bug-name}/bug.md` 输出 `.collaboration/bugs/{bug-name}/fix-plan.md`。
`.collaboration/bugs/{bug-name}/fix-plan.md` 必须覆盖根因判断、影响模块、修复策略、API 或契约变化、兼容性、回归风险与验证重点。
如果修复已经演变成新增能力或接口重设，请停止当前缺陷链路并提示我回到 product-manager。

## Bug
@.collaboration/bugs/{bug-name}/bug.md
```

说明：

- `tech-lead` 在 Feature 链路中由 `feature-coordinator` 调用，在 Bug 链路中由 `bug-coordinator` 调用
- Feature 模式输出 `.collaboration/features/{feature-name}/tech.md` 与 `.collaboration/features/{feature-name}/api.yaml`
- Bug 模式只输出 `.collaboration/bugs/{bug-name}/fix-plan.md`，不再生成 `.collaboration/features/{feature-name}/api.yaml`
