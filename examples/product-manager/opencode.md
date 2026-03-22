# product-manager - OpenCode 使用示例

默认在业务仓中使用。调用 `product-manager` 后，先用结构化选项确认工作空间模式：支持选择框的平台可直接勾选，若当前平台不支持勾选则直接回复关键词；若 `.collaboration/shared/workspace.md` 已存在，先确认是否沿用当前值；若文件不存在，则先确认 `workspace_mode`（只允许 `single-repo` / `split-repo`），确认后创建该文件。

## 使用方式

```bash
# 1. 启动 OpenCode
opencode

# 2. 先产出 PRD
skill(name: product-manager)

# product-manager 首轮先做 workspace_mode 确认
# - 若 `.collaboration/shared/workspace.md` 已存在，先用结构化选项问：
#   - [ ] 继续沿用当前 workspace_mode: single-repo
#   - [ ] 改为 single-repo
#   - [ ] 改为 split-repo
#   - 若当前平台不支持勾选，要求我直接回复：继续沿用当前 workspace_mode / single-repo / split-repo
#   补充意见：____
# - 若文件不存在，先用结构化选项问要使用的 workspace_mode（仅允许 `single-repo` / `split-repo`）：
#   - [ ] single-repo
#   - [ ] split-repo
#   - 若当前平台不支持勾选，要求我直接回复：single-repo / split-repo
#   补充意见：____
# - 禁止要求我按序号回答；确认后创建 `.collaboration/shared/workspace.md`
# - product-manager 不再主动询问技术栈；若我主动提供技术约束，只记录到 PRD，后续由 @tech-lead 按这些约束继续设计

# 3. 完成 PRD 后，当前会话进入协调主链路
skill(name: feature-coordinator)

请继续负责当前 feature 的协调工作。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 `.collaboration/features/{feature-name}/plan.md`，@frontend-design 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始；若 `workspace_mode` 是 `single-repo`，启动后立即检查三者状态，任一未成功启动则立刻重启，直到三者并行运行。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再用结构化选项问我是否通过：
- [ ] 通过，进入下一阶段
- [ ] 继续澄清/修订
如果当前平台不支持勾选，要求我直接回复：通过 / 继续澄清/修订
补充意见：____
如果 `workspace_mode` 是 `split-repo`，联合评审通过后只用结构化选项提示我是否提交并推送当前协作文档，不进入 `frontend` / `backend-*`：
- [ ] 提交并推送当前协作文档
- [ ] 暂不提交
如果当前平台不支持勾选，要求我直接回复：提交并推送当前协作文档 / 暂不提交
补充意见：____

## PRD
@.collaboration/features/{feature-name}/prd.md
```

说明：

- `product-manager` 负责产出 `.collaboration/features/{feature-name}/prd.md`
- 下一步不直接切到 `project-manager` skill
- `project-manager`、`tech-lead`、`frontend-design` 首轮并行由 `feature-coordinator` 以 subagent 方式调度
- 每轮都先回到 `feature-coordinator`，由协调器用结构化选项询问用户“通过”还是“继续澄清/修订”，并允许填写补充意见；若当前平台不支持勾选，则直接回复关键词
- 首轮需先补齐计划、技术、API 与设计产物，再进入面向用户的正式联合评审

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
