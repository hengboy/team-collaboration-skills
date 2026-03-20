# tech-lead - OpenCode 使用示例

## 推荐方式：由 feature-coordinator 调用 subagent

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

说明：

- `tech-lead` 在联合评审链路中应作为 subagent 运行，并可与 `project-manager`、`frontend-design` 并行启动
- 每轮技术结果先回到 `feature-coordinator`，由协调器向用户询问“通过”还是“继续澄清/修订”
- 当前主会话保持在 `feature-coordinator`

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
