# product-manager - Claude 使用示例

默认在业务仓中使用；如需跨仓协作，请先在 `.collaboration/shared/workspace.md` 中显式声明 `workspace_mode: split-repo`。

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
先使用 product-manager 完成 PRD。

PRD 完成后，请保持当前会话作为 feature-coordinator。
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 `.collaboration/features/{feature-name}/plan.md`，frontend-design 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始。
首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`，再询问我是“通过”还是“继续澄清/修订”。
如果 `workspace_mode` 是 `split-repo`，联合评审通过后只提示我是否提交并推送当前协作文档，不进入 `frontend` / `backend-*`。

## PRD
{粘贴 .collaboration/features/{feature-name}/prd.md 内容}
```

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
