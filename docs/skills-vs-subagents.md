# Skills vs Subagents 决策文档

## 结论

推荐采用混合模式：

- `product-manager`、`master-coordinator`、实现类角色保持在当前主会话，以 skill 方式工作
- `project-manager`、`frontend-design`、`tech-lead` 在协同链路中优先使用 subagent

## 核心原则

### 什么时候保留 skill

- 需要持续持有主链路上下文
- 需要监听其他角色完成情况并继续推进
- 需要汇总评审结论、记录状态、分发修订任务

适用角色：

- `product-manager`
- `master-coordinator`
- `frontend`
- `backend-typescript`
- `backend-springboot`
- `qa-engineer`
- `code-reviewer`

### 什么时候改用 subagent

- 输入边界清晰，和主链路耦合较低
- 需要并行执行
- 需要在主协调器持续监听下多轮回收和修订

适用角色：

- `project-manager`
- `frontend-design`
- `tech-lead`

## 角色分工建议

| 角色 | 推荐形态 | 原因 |
|------|----------|------|
| `product-manager` | skill | 需要在当前会话里完成需求澄清与 PRD 定稿 |
| `master-coordinator` | skill | 需要持续监听、回收结果、组织评审与修订 |
| `project-manager` | subagent | 只依赖 PRD，边界清晰，适合隔离生成 `plan.md` |
| `frontend-design` | subagent | 需要被 `master-coordinator` 并行调度并监听修订 |
| `tech-lead` | subagent | 需要被 `master-coordinator` 并行调度并监听修订 |
| 实现类角色 | skill | 与真实代码和上下文强耦合，共享主会话更高效；不要误当成 subagent 调用 |

## 标准链路

```text
product-manager
  -> master-coordinator
    -> project-manager subagent
    -> tech-lead subagent
    -> frontend-design subagent
  -> frontend / backend
```

说明：

- `product-manager` 完成后，不直接切走到 `project-manager` skill
- 当前会话继续执行 `master-coordinator`
- `master-coordinator` 首轮并行拉起 `project-manager`、`tech-lead` 和 `frontend-design` subagent
- `tech-lead` 直接基于 PRD 开始，不等待 `plan.md`
- `frontend-design` 直接基于 PRD 开始，不等待 `tech.md` 或 `api.yaml`
- 首轮需先补齐计划、技术、API 与设计产物，再进入面向用户的正式联合评审
- 各轮结果先回到 `master-coordinator`，由协调器统一询问用户“通过”还是“继续澄清/修订”
- 若评审中出现超出当前 PRD 的新增功能，则停止当前链路，提示用户回到 `product-manager` 重头开始
- 联合评审中的修订任务继续由 `master-coordinator` 分发给对应 subagent

## 平台调用提示

各平台 subagent 调用方式不同，具体语法和运行时文件位置以 [docs/platform-runtime-adapters.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/platform-runtime-adapters.md) 为准。

本文件只定义决策原则，不绑定某一家的调用语法。
