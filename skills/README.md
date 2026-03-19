# Skills 使用指南

## 概述

本目录包含 11 个团队协作技能。

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
  - 下一步建议
  - 核心契约（供 AGENT 派生）

## 可用 Skills

| Skill | 用途 |
|-------|------|
| `product-manager` | 需求澄清、PRD 编写 |
| `project-manager` | 优先级、排期、风险管理 |
| `tech-lead` | 技术方案、API 契约、可行性评估 |
| `frontend-design` | 设计方案、组件设计契约 |
| `backend-typescript` | TypeScript 后端实现 |
| `backend-springboot` | Spring Boot 后端实现 |
| `frontend` | 前端页面与组件实现 |
| `qa-engineer` | 测试用例、测试建议、测试汇总 |
| `code-reviewer` | findings-first 代码审查 |
| `master-coordinator` | 设计/技术并行协同与联合评审 |
| `git-commit` | 生成提交信息，必要时提交已选定变更 |

## 工作流建议

典型链路：

1. `product-manager`
2. `master-coordinator`
3. `project-manager` subagent
4. `frontend-design` + `tech-lead` subagent
5. `frontend` / `backend-typescript` / `backend-springboot`
6. `qa-engineer`
7. `code-reviewer`
8. `git-commit`

说明：

- 普通业务 skill 不自动启动下游角色
- `master-coordinator` 保持在当前主会话中负责跨角色协同
- `project-manager`、`frontend-design`、`tech-lead` 在协同链路中优先作为 subagent 被调度
- 文档类产物输出到 `.collaboration/features/{feature-name}/`
- 实现代码与测试必须写入真实项目目录，禁止写入 `.collaboration/features/{feature-name}/`
- 进入实现阶段后，必须先根据技术栈识别仓库中实际存在的源码根目录，并使用具体路径而不是笼统的“真实项目目录”
- 在独立前后端仓库执行实现 skill 时，必须先确定唯一 `feature-name`：优先从 `.collaboration/features/{feature-name}/...` 输入路径提取，取不到再从文档 frontmatter 的 `feature:` 字段提取，仍无法确定则停止
- `frontend`、`backend-typescript`、`backend-springboot` 在流转到 `qa-engineer` 前，必须先通过强制质量门禁：代码质量检查、语法/类型或编译检查、测试与缺陷检查，并汇总实际执行命令与结果

## 示例文件

| Skill | 使用示例 | 输出示例 |
|-------|----------|----------|
| Product Manager | [examples/product-manager/opencode.md](../examples/product-manager/opencode.md), [examples/product-manager/claude.md](../examples/product-manager/claude.md) | [examples/product-manager/prd-example.md](../examples/product-manager/prd-example.md), [examples/product-manager/prd-output-example.md](../examples/product-manager/prd-output-example.md) |
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
