# project-manager - OpenCode 使用示例

## 推荐方式：由 master-coordinator 调用 subagent

```bash
opencode

skill(name: master-coordinator)

请继续协调当前 feature。
并行调用 @project-manager 和 @tech-lead，其中 @tech-lead 不需要等待 plan.md。
每轮结果先由你汇总，再问我是“通过”还是“继续澄清/修订”。

## PRD
@.collaboration/features/{feature-name}/prd.md
```

说明：

- `project-manager` 在协同链路中优先作为 subagent 使用，并可与 `tech-lead` 并行启动
- 当前主会话保持在 `master-coordinator`
- `plan.md` 产出后由协调器汇总本轮结果，再询问用户“通过”还是“继续澄清/修订”

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
