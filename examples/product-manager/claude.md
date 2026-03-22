# product-manager - Claude 使用示例

默认在业务仓中使用。调用 `product-manager` 后，先用结构化选项确认工作空间模式：支持选择框的平台可直接勾选，若当前平台不支持勾选则直接回复关键词；若 `.collaboration/shared/workspace.md` 已存在，先确认是否沿用当前值；若文件不存在，则先确认 `workspace_mode`（只允许 `single-repo` / `split-repo`），确认后创建该文件。

## 配置

```bash
mkdir -p ~/.claude/skills ~/.claude/agents
cp -R skills/product-manager ~/.claude/skills/
cp -R skills/feature-coordinator ~/.claude/skills/
cp .claude/agents/project-manager.md ~/.claude/agents/
cp .claude/agents/frontend-design.md ~/.claude/agents/
cp .claude/agents/tech-lead.md ~/.claude/agents/
```

## 使用方式

```bash
claude
```

在对话中：

```
如果 `.collaboration/shared/workspace.md` 已存在，先用下面的结构化选项问我：
- [ ] 继续沿用当前 workspace_mode: single-repo
- [ ] 改为 single-repo
- [ ] 改为 split-repo
如果当前平台不支持勾选，要求我直接回复：继续沿用当前 workspace_mode / single-repo / split-repo
补充意见：____

如果 `.collaboration/shared/workspace.md` 不存在，先用下面的结构化选项问我要配置的 workspace_mode。
- [ ] single-repo
- [ ] split-repo
如果当前平台不支持勾选，要求我直接回复：single-repo / split-repo
补充意见：____

禁止要求我按序号回答。workspace_mode 只允许 `single-repo` 或 `split-repo`，确认后创建 `.collaboration/shared/workspace.md`。

先使用 product-manager 完成 PRD。
product-manager 不再主动询问技术栈；如果我主动给出技术约束，请记录进 PRD，后续由 tech-lead 按这些约束继续设计。

PRD 完成后，请保持当前会话作为 feature-coordinator。
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 `.collaboration/features/{feature-name}/plan.md`，frontend-design 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始；若 `workspace_mode` 是 `single-repo`，启动后立即检查三者状态，任一未成功启动则立刻重启，直到三者并行运行。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再用下面的结构化选项询问我是否通过：
- [ ] 通过，进入下一阶段
- [ ] 继续澄清/修订
如果当前平台不支持勾选，要求我直接回复：通过 / 继续澄清/修订
补充意见：____

如果 `workspace_mode` 是 `split-repo`，联合评审通过后只用下面的结构化选项提示我是否提交并推送当前协作文档，不进入 `frontend` / `backend-*`：
- [ ] 提交并推送当前协作文档
- [ ] 暂不提交
如果当前平台不支持勾选，要求我直接回复：提交并推送当前协作文档 / 暂不提交
补充意见：____

## PRD
{粘贴 .collaboration/features/{feature-name}/prd.md 内容}
```

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
