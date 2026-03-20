---
workspace_mode: single-repo
---

# Workspace Mode

本仓库当前以 `single-repo` 方式运行。

- `single-repo`：当前仓同时承载 `.collaboration/` 协作文档和真实业务代码。Feature 联合评审通过后，可直接在当前仓进入 `frontend` / `backend-*`；Bug 仍先产出 handoff，但由当前仓实现角色消费。
- `split-repo`：当前仓是协作仓，真实业务代码位于外部业务仓。Feature 联合评审通过后，由 `feature-coordinator` 提示是否提交并推送当前协作文档，不在协作仓直接进入实现类 skill；Bug handoff 交给外部业务仓消费。

工作项模式解析顺序：

1. 当前工作项文档 frontmatter 中的 `workspace_mode`
2. 本文件 `.collaboration/shared/workspace.md`
3. 默认值 `single-repo`

如需切换工作空间模式，请将本文件中的 `workspace_mode` 更新为 `single-repo` 或 `split-repo`，并提交到仓库。
