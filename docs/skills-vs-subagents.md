# Skills vs Subagents 决策文档

## 结论

推荐采用双主链路混合模式：

- 默认工作模式为 `single-repo`
- Feature 链路：`product-manager`、`feature-coordinator` 保持为 skill；`project-manager`、`frontend-design`、`tech-lead` 与 `single-repo` 下的实现 / QA / Review 角色优先使用 subagent
- Bug 链路：`bug-coordinator` 保持为 skill；`tech-lead` 默认使用 subagent，`frontend-design`、`project-manager` 按需使用 subagent；`single-repo` 下的实现 / QA / Review 角色由协调器继续调度为 subagent
- `split-repo` 继续受支持，但必须在 `.collaboration/shared/workspace.md` 显式声明 `workspace_mode: split-repo`

补充说明：

- `project-manager`、`frontend-design`、`tech-lead` 也支持直接以 skill 独立调用
- `frontend`、`backend-typescript`、`backend-springboot`、`qa-engineer`、`code-reviewer` 也保留 direct skill 入口，供 `split-repo` 目标业务仓或独立调用
- 但在正式协作链路里，仍然优先作为协调器调度的 subagent 使用

## 什么时候保留 skill

- 需要持续持有主链路上下文
- 需要监听其他角色完成情况并继续推进
- 需要汇总结论、记录状态、分发修订或 handoff

适用角色：

- `product-manager`
- `feature-coordinator`
- `bug-coordinator`
- `git-commit`

## 什么时候改用 subagent

- 输入边界清晰，和主链路耦合较低
- 需要并行执行
- 需要在协调器持续监听下多轮回收和修订

适用角色：

- `project-manager`
- `frontend-design`
- `tech-lead`
- `frontend`
- `backend-typescript`
- `backend-springboot`
- `qa-engineer`
- `code-reviewer`

## Feature 标准链路

```text
product-manager
  -> feature-coordinator
    -> project-manager subagent
    -> tech-lead subagent
    -> frontend-design subagent
  -> single-repo: frontend / backend subagents
  -> single-repo: qa-engineer subagent
  -> single-repo: code-reviewer subagent
  -> split-repo: git-commit（协作文档提交 / 推送）
```

说明：

- `feature-coordinator` 首轮并行拉起 `project-manager`、`tech-lead` 和 `frontend-design`
- `tech-lead` 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始，不等待 `.collaboration/features/{feature-name}/plan.md`
- `frontend-design` 直接基于 `.collaboration/features/{feature-name}/prd.md` 开始，不等待 `.collaboration/features/{feature-name}/tech.md` 或 `.collaboration/features/{feature-name}/api.yaml`
- 首轮需先补齐 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`
- `single-repo` 下，评审通过后由 `feature-coordinator` 并行调度 `frontend` 与对应 `backend-*` subagent，之后再串行调度 `qa-engineer`、`code-reviewer`
- `split-repo` 下，评审通过后只提示是否提交并推送当前协作文档，不在当前协作会话进入实现类 skill

## Bug 标准链路

```text
bug-coordinator
  -> tech-lead subagent
  -> frontend-design subagent (optional)
  -> project-manager subagent (optional)
  -> frontend-handoff / backend-handoff
  -> single-repo: current repo frontend / backend subagents
  -> split-repo: frontend repo / backend repo
  -> qa-engineer subagent
  -> code-reviewer subagent
  -> git-commit
```

说明：

- `bug-coordinator` 是独立 Bug 主链路入口，不与 `feature-coordinator` 混用
- `tech-lead` 默认以 Bug 模式参与，输出 `.collaboration/bugs/{bug-name}/fix-plan.md`
- `frontend-design` 仅在 UI / 交互修订时以 Bug 模式参与
- `project-manager` 仅在分阶段修复或资源协调时以 Bug 模式参与
- 单边缺陷只生成对应一侧 handoff；联调缺陷同时生成 `.collaboration/bugs/{bug-name}/frontend-handoff.md` 和 `.collaboration/bugs/{bug-name}/backend-handoff.md`
- `single-repo` 下，handoff 由 `bug-coordinator` 并行调度的当前仓实现 subagent 消费，回收证据后再串行进入 QA / Review
- `split-repo` 下，协作仓不直接承担前后端业务代码实现，handoff 交给外部业务仓消费

## 平台调用提示

各平台具体语法见 [docs/platform-runtime-adapters.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/platform-runtime-adapters.md)。

本文件只定义决策原则，不绑定某一家的调用细节。
