# Skills 使用指南

## 概述

本目录包含 12 个团队协作技能。

统一约定：

- `SKILL.md` 是事实源
- 如存在同名 `AGENT.md`，它只能是精简派生物
- 所有 skill 统一使用同一套能力契约结构：
  - 角色定位
  - 适用场景
  - 必须输入
  - 可选输入
  - 输出文件
  - 执行规则
  - 质量检查
  - 下一步流程
  - 核心契约（供 AGENT 派生）

## 可用 Skills

| Skill | 用途 |
|-------|------|
| `product-manager` | 需求澄清、PRD 编写 |
| `bug-coordinator` | 缺陷 intake、判责拆单、handoff 与收口 |
| `project-manager` | 优先级、排期、风险管理 |
| `tech-lead` | 技术方案、API 契约、可行性评估 |
| `frontend-design` | 设计方案、组件设计契约 |
| `backend-typescript` | TypeScript 后端实现 |
| `backend-springboot` | Spring Boot 后端实现 |
| `frontend` | 前端页面与组件实现 |
| `qa-engineer` | 测试用例、测试建议、测试汇总 |
| `code-reviewer` | findings-first 代码审查 |
| `feature-coordinator` | 设计/技术并行协同与联合评审 |
| `git-commit` | 生成提交信息，必要时提交已选定变更 |

## 工作流建议

Feature 链路：

1. `product-manager`
2. `feature-coordinator`
3. `project-manager` + `tech-lead` + `frontend-design` subagent（首轮并行）
4. `frontend` / `backend-typescript` / `backend-springboot`
5. `qa-engineer`
6. `code-reviewer`
7. `git-commit`

Bug 链路：

1. `bug-coordinator`
2. `tech-lead` subagent（默认）
3. `frontend-design` / `project-manager` subagent（按需）
4. `frontend-handoff.md` / `backend-handoff.md`
5. 前端业务仓 / 后端业务仓实现并回传结果
6. `qa-engineer`
7. `code-reviewer`
8. `git-commit`

说明：

- 普通业务 skill 不自动启动下游角色
- `feature-coordinator` 保持在当前主会话中负责跨角色协同
- `bug-coordinator` 保持在当前主会话中负责缺陷 intake、拆单和收口
- `project-manager`、`frontend-design`、`tech-lead` 在协同链路中优先作为 subagent 被调度
- Feature 文档类产物输出到 `.collaboration/features/{feature-name}/`
- Bug 文档类产物输出到 `.collaboration/bugs/{bug-name}/`
- `tech-lead`、`frontend-design`、`project-manager`、`frontend`、`backend-typescript`、`backend-springboot`、`qa-engineer`、`code-reviewer` 都支持 Feature / Bug 双模式
- 双模式角色按输入路径识别工作项：`.collaboration/features/{feature-name}/...` 进入 Feature 模式，`.collaboration/bugs/{bug-name}/...` 进入 Bug 模式；路径缺失时才允许用 frontmatter 兜底
- 同一次调用里若混入 Feature 与 Bug 两套工作项目录，相关 skill 必须停止并要求上游先统一上下文
- 实现代码与测试必须写入真实项目目录，禁止写入任何 `.collaboration/` 工作项目录
- Bug 链路的业务代码不在当前协作仓实现，而是由前后端业务仓消费 handoff 文档后各自编码
- 进入实现阶段后，必须先根据技术栈识别仓库中实际存在的源码根目录，并使用具体路径而不是笼统的“真实项目目录”
- 在独立前后端仓库执行实现 skill 时，必须先确定唯一 `feature-name` 或 `bug-name`：优先从工作项输入路径提取，取不到再从文档 frontmatter 提取，仍无法确定则停止
- `frontend` Bug 模式消费 `frontend-handoff.md`
- `backend-typescript` 与 `backend-springboot` Bug 模式消费 `backend-handoff.md`
- `qa-engineer` Bug 模式必须读取 `bug.md`，并同时拿到至少一项实现证据
- `code-reviewer` 在正式协作链路里必须拿到至少一个 Feature 或 Bug 上下文文档，才能确定 `code-review.md` 的落点
- `frontend`、`backend-typescript`、`backend-springboot` 在流转到 `qa-engineer` 前，必须先通过强制质量门禁：代码质量检查、语法/类型或编译检查、测试与缺陷检查，并汇总实际执行命令与结果

## 示例文件

| Skill | 使用示例 | 输出示例 |
|-------|----------|----------|
| Product Manager | [examples/product-manager/opencode.md](../examples/product-manager/opencode.md), [examples/product-manager/claude.md](../examples/product-manager/claude.md) | [examples/product-manager/prd-example.md](../examples/product-manager/prd-example.md), [examples/product-manager/prd-output-example.md](../examples/product-manager/prd-output-example.md) |
| Bug Coordinator | [examples/bug-coordinator/opencode.md](../examples/bug-coordinator/opencode.md), [examples/bug-coordinator/claude.md](../examples/bug-coordinator/claude.md) | - |
| Project Manager | [examples/project-manager/opencode.md](../examples/project-manager/opencode.md), [examples/project-manager/claude.md](../examples/project-manager/claude.md) | [examples/project-manager/project-plan-example.md](../examples/project-manager/project-plan-example.md) |
| Tech Lead | [examples/tech-lead/opencode.md](../examples/tech-lead/opencode.md), [examples/tech-lead/claude.md](../examples/tech-lead/claude.md) | [examples/tech-lead/tech-example.md](../examples/tech-lead/tech-example.md), [examples/tech-lead/tech-design-example.md](../examples/tech-lead/tech-design-example.md) |
| Frontend Design | [examples/frontend-design/opencode.md](../examples/frontend-design/opencode.md), [examples/frontend-design/claude.md](../examples/frontend-design/claude.md) | - |
| Backend TypeScript | [examples/backend-typescript/opencode.md](../examples/backend-typescript/opencode.md), [examples/backend-typescript/claude.md](../examples/backend-typescript/claude.md) | [examples/backend-typescript/code-example.md](../examples/backend-typescript/code-example.md) |
| Backend SpringBoot | [examples/backend-springboot/opencode.md](../examples/backend-springboot/opencode.md), [examples/backend-springboot/claude.md](../examples/backend-springboot/claude.md) | - |
| Frontend | [examples/frontend/opencode.md](../examples/frontend/opencode.md), [examples/frontend/claude.md](../examples/frontend/claude.md) | [examples/frontend/component-example.md](../examples/frontend/component-example.md) |
| QA Engineer | [examples/qa-engineer/opencode.md](../examples/qa-engineer/opencode.md), [examples/qa-engineer/claude.md](../examples/qa-engineer/claude.md) | [examples/qa-engineer/test-cases-example.md](../examples/qa-engineer/test-cases-example.md) |
| Code Reviewer | [examples/code-reviewer/opencode.md](../examples/code-reviewer/opencode.md), [examples/code-reviewer/claude.md](../examples/code-reviewer/claude.md) | [examples/code-reviewer/code-review-example.md](../examples/code-reviewer/code-review-example.md) |
| Git Commit | [examples/git-commit/opencode.md](../examples/git-commit/opencode.md), [examples/git-commit/claude.md](../examples/git-commit/claude.md) | - |

## 同步与校验

对存在 subagent 的 skill，请运行：

```bash
./scripts/sync-skill-agent.sh
```

该脚本会校验 skill 与 agent 的统一结构及 `核心契约` 一致性。
