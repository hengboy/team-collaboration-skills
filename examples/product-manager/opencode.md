# product-manager - OpenCode 使用示例

## 使用方式

```bash
# 1. 启动 OpenCode
opencode

# 2. 先产出 PRD
skill(name: product-manager)

# 3. 完成 PRD 后，当前会话进入协调主链路
skill(name: feature-coordinator)

请继续负责当前 feature 的协调工作。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 `.collaboration/features/{feature-name}/plan.md`，@frontend-design 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再问我是“通过”还是“继续澄清/修订”。

## PRD
@.collaboration/features/{feature-name}/prd.md
```

说明：

- `product-manager` 负责产出 `.collaboration/features/{feature-name}/prd.md`
- 下一步不直接切到 `project-manager` skill
- `project-manager`、`tech-lead`、`frontend-design` 首轮并行由 `feature-coordinator` 以 subagent 方式调度
- 每轮都先回到 `feature-coordinator`，由协调器询问用户“通过”还是“继续澄清/修订”
- 首轮需先补齐计划、技术、API 与设计产物，再进入面向用户的正式联合评审

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
