# 多仓协作最佳实践

本文件只描述显式启用 `split-repo` 时的协作方式，而不是额外的发布系统或同步平台设计。

启用方式：

```markdown
---
workspace_mode: split-repo
---
```

把上面的内容写入 `.collaboration/shared/workspace.md` 并提交到协作仓。

## 适用场景

- 协作仓与前后端业务仓分离
- 协作仓负责文档、判责、评审与收口
- 业务仓负责真实代码实现、测试和发布

## 推荐角色分工

### 协作仓负责

- Feature：`product-manager`、`feature-coordinator`、`project-manager`、`tech-lead`、`frontend-design`
- Bug：`bug-coordinator`、`tech-lead`、`frontend-design`、`project-manager`
- 收口：`qa-engineer`、`code-reviewer`、`git-commit`

### 业务仓负责

- `frontend`
- `backend-typescript`
- `backend-springboot`

## 协作文档边界

### Feature

协作仓产出：

- `.collaboration/features/{feature-name}/prd.md`
- `.collaboration/features/{feature-name}/plan.md`
- `.collaboration/features/{feature-name}/tech.md`
- `.collaboration/features/{feature-name}/api.yaml`
- `.collaboration/features/{feature-name}/design.md`
- `.collaboration/features/{feature-name}/design-components.md`
- `.collaboration/features/{feature-name}/review.md`
- `.collaboration/features/{feature-name}/test-cases.md`
- `.collaboration/features/{feature-name}/qa-report.md`（可选）
- `.collaboration/features/{feature-name}/code-review.md`
- `.collaboration/features/{feature-name}/security-review.md`（可选）

业务仓消费：

- 前端业务仓消费 `.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`、`.collaboration/features/{feature-name}/api.yaml`
- 后端业务仓消费 `.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`

### Bug

协作仓产出：

- `.collaboration/bugs/{bug-name}/bug.md`
- `.collaboration/bugs/{bug-name}/fix-plan.md`
- `.collaboration/bugs/{bug-name}/design-change.md`
- `.collaboration/bugs/{bug-name}/execution-plan.md`
- `.collaboration/bugs/{bug-name}/frontend-handoff.md`
- `.collaboration/bugs/{bug-name}/backend-handoff.md`
- `.collaboration/bugs/{bug-name}/test-cases.md`
- `.collaboration/bugs/{bug-name}/qa-report.md`
- `.collaboration/bugs/{bug-name}/code-review.md`
- `.collaboration/bugs/{bug-name}/security-review.md`（可选）

业务仓消费：

- 前端业务仓消费 `.collaboration/bugs/{bug-name}/frontend-handoff.md`
- 后端业务仓消费 `.collaboration/bugs/{bug-name}/backend-handoff.md`

## 推荐协作顺序

### Feature

1. 在协作仓运行 `product-manager`
2. 在协作仓运行 `feature-coordinator`
3. 联合评审通过后，先在协作仓确认是否提交并推送本轮协作文档到远程 Git 仓库
4. 协作仓当前会话不进入 `frontend` / `backend-*`
5. 业务仓基于已推送文档实现并回传变更摘要
6. 若后续发现原需求仍需修订，回到协作仓用同一 `feature-name` 重开 `feature-coordinator`

### Bug

1. 在协作仓运行 `bug-coordinator`
2. 由协调器判断是否需要 `tech-lead`、`frontend-design`、`project-manager`
3. 协作仓生成 handoff
4. 业务仓实现并回传 PR、测试结果和变更摘要
5. 协作仓统一做 QA / Review / Commit

## 工作项识别规则

在独立业务仓执行实现类 skill 时，不允许靠猜测决定工作项：

- 必须优先从输入路径 `.collaboration/features/{feature-name}/...` 或 `.collaboration/bugs/{bug-name}/...` 提取 slug
- 如果只有文档正文，再从 frontmatter 中的 `feature:` 或 `bug:` 提取
- 路径与 frontmatter 同时存在时必须一致
- 仍无法确定时，必须停止并要求补充输入

## 同步与校验

本仓库当前没有额外的 `sync-collab.sh`、版本冻结或 Gitea 发布流。

当前实际存在且推荐使用的脚本只有：

```bash
./scripts/generate-agents-from-skills.sh
./scripts/sync-skill-agent.sh
./scripts/sync-platform-adapters.sh --with-skills
./scripts/verify-platform-adapters.sh
```

详见 [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)。

## 最佳实践清单

- 协作仓只维护文档与收口，不承担 Feature 或 Bug 业务实现
- Feature 联合评审通过后，先提交并推送协作文档，再让业务仓消费
- 业务仓实现前，先确认唯一 `feature-name` 或 `bug-name`
- 所有提示词和文档都尽量使用完整路径模板，而不是裸文件名
- 生成了平台 runtime 后，把 `.claude/.gemini/.opencode/.codex` 生成物一并提交
- 提交前至少跑一次 `./scripts/verify-platform-adapters.sh`
