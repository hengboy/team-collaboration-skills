# product-manager - Claude 使用示例

默认在业务仓中使用。调用 `product-manager` 后，先确认工作空间模式：若 `.collaboration/shared/workspace.md` 已存在，先询问是否沿用当前值；若文件不存在，则先询问 `workspace_mode`（只允许 `single-repo` / `split-repo`），确认后创建该文件。

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
如果 `.collaboration/shared/workspace.md` 已存在，先问我：
“是否继续沿用文件中配置的 workspace_mode？当前 workspace_mode: single-repo”

如果 `.collaboration/shared/workspace.md` 不存在，先问我要配置的 workspace_mode。
workspace_mode 只允许 `single-repo` 或 `split-repo`，确认后创建 `.collaboration/shared/workspace.md`。

先使用 product-manager 完成 PRD。

PRD 完成后，请保持当前会话作为 feature-coordinator。
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 `.collaboration/features/{feature-name}/plan.md`，frontend-design 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始；若 `workspace_mode` 是 `single-repo`，启动后立即检查三者状态，任一未成功启动则立刻重启，直到三者并行运行。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再询问我是“通过”还是“继续澄清/修订”。
如果 `workspace_mode` 是 `split-repo`，联合评审通过后只提示我是否提交并推送当前协作文档，不进入 `frontend` / `backend-*`。

## PRD
{粘贴 .collaboration/features/{feature-name}/prd.md 内容}
```

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
