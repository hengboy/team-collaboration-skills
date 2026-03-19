# product-manager - OpenCode 使用示例

## 使用方式

```bash
# 1. 启动 OpenCode
opencode

# 2. 先产出 PRD
skill(name: product-manager)

# 3. 完成 PRD 后，当前会话进入协调主链路
skill(name: master-coordinator)

请继续负责当前 feature 的协调工作。
并行调用 @project-manager 和 @tech-lead，其中 @tech-lead 不需要等待 plan.md。
每轮结果先由你汇总，再问我是“通过”还是“继续澄清/修订”。
需要时再调用 @frontend-design。

## PRD
@.collaboration/features/{feature-name}/prd.md
```

说明：

- `product-manager` 负责产出 `.collaboration/features/{feature-name}/prd.md`
- 下一步不直接切到 `project-manager` skill
- `project-manager`、`tech-lead` 首轮并行由 `master-coordinator` 以 subagent 方式调度
- 每轮都先回到 `master-coordinator`，由协调器询问用户“通过”还是“继续澄清/修订”
- `frontend-design` 按上下文成熟度继续由 `master-coordinator` 调度

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
