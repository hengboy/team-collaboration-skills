# Skills vs Subagents 决策文档

## 结论

推荐采用双主链路混合模式：

- Feature 链路：`product-manager`、`feature-coordinator` 和实现类角色保持为 skill；`project-manager`、`frontend-design`、`tech-lead` 优先使用 subagent
- Bug 链路：`bug-coordinator` 保持为 skill；`tech-lead` 默认使用 subagent，`frontend-design`、`project-manager` 按需使用 subagent；业务代码实现通过 handoff 文档交给前后端业务仓

## 核心原则

### 什么时候保留 skill

- 需要持续持有主链路上下文
- 需要监听其他角色完成情况并继续推进
- 需要汇总结论、记录状态、分发修订或 handoff

适用角色：

- `product-manager`
- `feature-coordinator`
- `bug-coordinator`
- `frontend`（Feature 模式消费设计产物，Bug 模式消费 `frontend-handoff.md`）
- `backend-typescript`（Feature 模式消费 `api.yaml` / `tech.md`，Bug 模式消费 `backend-handoff.md`）
- `backend-springboot`（Feature 模式消费 `api.yaml` / `tech.md`，Bug 模式消费 `backend-handoff.md`）
- `qa-engineer`（Feature / Bug 双模式分别输出到对应工作项目录）
- `code-reviewer`（Feature / Bug 双模式分别输出到对应工作项目录）

### 什么时候改用 subagent

- 输入边界清晰，和主链路耦合较低
- 需要并行执行
- 需要在 `feature-coordinator` 持续监听下多轮回收和修订

适用角色：

- `project-manager`
- `frontend-design`
- `tech-lead`

## 角色分工建议

| 角色 | 推荐形态 | 原因 |
|------|----------|------|
| `product-manager` | skill | 需要在当前会话里完成需求澄清与 PRD 定稿 |
| `feature-coordinator` | skill | 负责 Feature 主链路的评审、状态推进和修订分发 |
| `bug-coordinator` | skill | 负责 Bug 主链路的 intake、判责拆单、handoff 与收口 |
| `project-manager` | subagent | 只依赖上游文档，边界清晰，适合隔离生成 `plan.md` 或 `execution-plan.md` |
| `frontend-design` | subagent | 既可用于 Feature 设计，也可按需处理 Bug 的 UI / 交互修订 |
| `tech-lead` | subagent | 既可产出 Feature 技术方案，也可产出 Bug 的 `fix-plan.md` |
| 实现类角色 | skill（在业务仓内） | 与真实代码强耦合，Feature 在实现仓内直接工作；Bug 在协作仓中不直接实现，而是通过 handoff 交给业务仓 |

## Feature 标准链路

```text
product-manager
  -> feature-coordinator
    -> project-manager subagent
    -> tech-lead subagent
    -> frontend-design subagent
  -> frontend / backend
```

说明：

- `product-manager` 完成后，不直接切走到 `project-manager` skill
- 当前会话继续执行 `feature-coordinator`
- `feature-coordinator` 首轮并行拉起 `project-manager`、`tech-lead` 和 `frontend-design` subagent
- `tech-lead` 直接基于 PRD 开始，不等待 `plan.md`
- `frontend-design` 直接基于 PRD 开始，不等待 `tech.md` 或 `api.yaml`
- 首轮需先补齐计划、技术、API 与设计产物，再进入面向用户的正式联合评审
- 联合评审中的修订任务继续由 `feature-coordinator` 分发给对应 subagent
- 评审通过后，前后端在对应业务仓中继续以实现类 skill 工作

## Bug 标准链路

```text
bug-coordinator
  -> tech-lead subagent
  -> frontend-design subagent (optional)
  -> project-manager subagent (optional)
  -> frontend-handoff.md / backend-handoff.md
  -> frontend repo / backend repo
  -> qa-engineer
  -> code-reviewer
  -> git-commit
```

说明：

- `bug-coordinator` 是独立 Bug 主链路入口，不与 `feature-coordinator` 混用
- `tech-lead` 默认以 Bug 模式参与，输出 `.collaboration/bugs/{bug-name}/fix-plan.md`
- `frontend-design` 仅在 UI / 交互修订时以 Bug 模式参与，`project-manager` 仅在分阶段修复或资源协调时以 Bug 模式参与
- `bug-coordinator` 先判定是前端、后端还是联调缺陷，再生成 handoff 文档
- 单边缺陷只生成对应一侧 handoff，联调缺陷同时生成 `frontend-handoff.md` 和 `backend-handoff.md`
- 协作仓不直接承担前后端业务代码实现；前后端业务仓各自消费 handoff 文档后编码并回传 PR、测试结果和变更摘要
- `qa-engineer` 与 `code-reviewer` 也都以 Bug 模式回到 `.collaboration/bugs/{bug-name}/` 统一收口
- 若发现“修复”实为新增需求，则停止 Bug 链路并回退到 `product-manager`

## 平台调用提示

各平台 subagent 调用方式不同，具体语法和运行时文件位置以 [docs/platform-runtime-adapters.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/platform-runtime-adapters.md) 为准。

本文件只定义决策原则，不绑定某一家的调用语法。
