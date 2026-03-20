# Workspace Modes

本仓库支持两种工作模式：

- `single-repo`：默认模式。直接在业务仓中配置 `skills` / `subagents` 并运行协作链路。
- `split-repo`：兼容模式。协作仓负责文档与评审，业务代码仍在外部业务仓实现。

## 默认配置

仓库级默认模式写在 [`.collaboration/shared/workspace.md`](/Users/yuqiyu/AiHistorys/team-collaboration-skills/.collaboration/shared/workspace.md)：

```markdown
---
workspace_mode: single-repo
---
```

如需启用分仓协作，把 `workspace_mode` 改为 `split-repo` 并提交到仓库。

## 解析顺序

角色在执行前按以下顺序解析 `workspace_mode`：

1. 当前工作项文档 frontmatter 中的 `workspace_mode`
2. `.collaboration/shared/workspace.md`
3. 默认值 `single-repo`

同一次调用若拿到互相冲突的 `workspace_mode`，必须停止并要求上游先统一上下文。

## 模式差异

### `single-repo`

- 当前仓同时包含 `.collaboration/` 与真实业务代码。
- Feature 联合评审通过后，由 `feature-coordinator` 在当前仓并行调度 `frontend` / `backend-*` subagent。
- Bug 仍先产出 handoff，但由 `bug-coordinator` 调度当前仓实现 subagent 消费。
- QA / Review 可直接使用当前仓 diff、变更文件路径、测试结果和构建结果作为证据。

### `split-repo`

- 当前仓是协作仓，真实业务代码位于外部业务仓。
- Feature 联合评审通过后，`feature-coordinator` 只提示是否提交并推送当前协作文档，不在协作仓提示进入 `frontend` / `backend-*`。
- Bug 仍先产出 handoff，但由外部业务仓实现角色消费。
- QA / Review 主要读取外部业务仓 PR、diff、测试结果和构建结果。

## Feature 流转差异

### `single-repo`

1. `product-manager` 产出 `prd.md`
2. `feature-coordinator` 组织并行方案与联合评审
3. 评审通过后，`feature-coordinator` 并行调度 `frontend` / `backend-*` subagent
4. 实现证据齐备后，串行进入 `qa-engineer`、`code-reviewer` 和 `git-commit`

### `split-repo`

1. `product-manager` 产出 `prd.md`
2. `feature-coordinator` 组织并行方案与联合评审
3. 评审通过后，更新 `review.md`，并提示是否提交、推送当前协作文档
4. 当前协作会话不进入实现类 skill；业务实现由外部业务仓另行推进

## Bug 流转差异

- 两种模式都必须保留 handoff。
- `single-repo` 下，handoff 由协调器调度的当前仓 `frontend` / `backend-*` subagent 消费。
- `split-repo` 下，handoff 由外部业务仓消费并回传实现证据。

## `split-repo` 的需求回流

如果联合评审完成、会话已经关闭，后续又发现原需求有问题：

1. 回到协作仓，使用同一个 `feature-name` 新开 `feature-coordinator` 会话。
2. 输入至少包含原 `prd.md`、原 `review.md` 和业务仓反馈证据。
3. 若修订仍在原 PRD 范围内，沿用原目录更新文档，并在 `review.md` 追加 reopen / revision 记录后重新联合评审。
4. 若修订已超出原 PRD 范围，停止当前 feature，回退到 `product-manager` 新建 feature。

## 相关文档

- [README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/README.md)
- [QUICKSTART.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/QUICKSTART.md)
- [docs/multi-repo-best-practices.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/multi-repo-best-practices.md)
