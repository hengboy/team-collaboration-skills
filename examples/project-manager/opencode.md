# project-manager - OpenCode 使用示例

## 推荐方式：由 feature-coordinator 调用 subagent

```bash
opencode

skill(name: feature-coordinator)

请继续协调当前 feature。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 plan.md，@frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再问我是“通过”还是“继续澄清/修订”。

## PRD
@.collaboration/features/{feature-name}/prd.md
```

说明：

- `project-manager` 在协同链路中优先作为 subagent 使用，并可与 `tech-lead`、`frontend-design` 并行启动
- 当前主会话保持在 `feature-coordinator`
- `plan.md` 产出后需与技术、设计产物一起汇总，再进入首轮联合评审

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
