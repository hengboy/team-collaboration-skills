# tech-lead - OpenCode 使用示例

## 推荐方式：由 master-coordinator 调用 subagent

```bash
opencode

skill(name: master-coordinator)

请继续协调当前 feature。
并行调用 @project-manager 和 @tech-lead，其中 @tech-lead 不需要等待 plan.md。
每轮结果先由你汇总，再问我是“通过”还是“继续澄清/修订”。
需要时再调用 @frontend-design，后续评审修订继续回派给 @tech-lead。

## PRD
@.collaboration/features/{feature-name}/prd.md

## Plan
@.collaboration/features/{feature-name}/plan.md
```

说明：

- `tech-lead` 在联合评审链路中应作为 subagent 运行，并可与 `project-manager` 并行启动
- 每轮技术结果先回到 `master-coordinator`，由协调器向用户询问“通过”还是“继续澄清/修订”
- 当前主会话保持在 `master-coordinator`

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
