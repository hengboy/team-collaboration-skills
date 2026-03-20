# Skills 使用指南

本目录存放仓库内 12 个团队协作 skill 的事实源定义。

## 统一约定

- `skills/{name}/SKILL.md` 是事实源。
- 如存在同名 `agents/{name}/AGENT.md`，agent 只能是精简派生物，不能偏离 skill 主章节与强制约束。
- 仓库级默认模式由 `.collaboration/shared/workspace.md` 的 `workspace_mode` 指定；缺失时默认 `single-repo`。
- 双模式角色按输入路径识别工作项：
  - `.collaboration/features/{feature-name}/...` 进入 Feature 模式
  - `.collaboration/bugs/{bug-name}/...` 进入 Bug 模式
- 当前工作项文档 frontmatter 如包含 `workspace_mode`，优先于仓库级默认值。
- 路径缺失时才允许用 frontmatter 中的 `feature:` 或 `bug:` 兜底。
- 同一次调用若混入 Feature 与 Bug 两套工作项目录，相关角色必须停止并要求上游先统一上下文。
- 实现代码与自动化测试必须写入真实项目目录，禁止写入任何 `.collaboration/` 工作项目录。

## 12 个核心 Skills

| Skill | 用途 |
|-------|------|
| `product-manager` | 需求澄清、PRD 编写 |
| `bug-coordinator` | 缺陷 intake、判责拆单、handoff 与收口 |
| `project-manager` | 优先级、排期、资源与风险 |
| `tech-lead` | 技术方案、API 契约、根因分析与修复策略 |
| `frontend-design` | 设计方案、组件契约、缺陷设计修订 |
| `backend-typescript` | TypeScript 后端实现 |
| `backend-springboot` | Spring Boot 后端实现 |
| `frontend` | 前端页面与组件实现 |
| `qa-engineer` | 测试资产与测试结论 |
| `code-reviewer` | findings-first 代码审查 |
| `feature-coordinator` | Feature 协调、联合评审、冲突检测 |
| `git-commit` | Git 提交信息与提交收口 |

## 推荐工作流

默认 `single-repo` Feature 链路：

1. `product-manager`
2. `feature-coordinator`
3. `project-manager` + `tech-lead` + `frontend-design` subagent（首轮并行）
4. `frontend` / `backend-typescript` / `backend-springboot`
5. `qa-engineer`
6. `code-reviewer`
7. `git-commit`

默认 `single-repo` Bug 链路：

1. `bug-coordinator`
2. `tech-lead` subagent（默认）
3. `frontend-design` / `project-manager` subagent（按需）
4. `.collaboration/bugs/{bug-name}/frontend-handoff.md` / `.collaboration/bugs/{bug-name}/backend-handoff.md`
5. 当前仓 `frontend` / `backend-*` 实现并回传结果
6. `qa-engineer`
7. `code-reviewer`
8. `git-commit`

## 关键边界

- 普通业务 skill 不自动启动下游角色。
- `feature-coordinator` 保持在当前主会话中负责 Feature 协同。
- `bug-coordinator` 保持在当前主会话中负责 Bug intake、拆单和收口。
- `project-manager`、`frontend-design`、`tech-lead` 在协同链路中优先作为 subagent 被调度，但也支持直接以 skill 独立调用。
- `split-repo` 下，`feature-coordinator` 联合评审通过后只提示是否提交并推送当前协作文档，不在协作仓继续提示进入 `frontend` / `backend-*`。
- `frontend` Bug 模式消费 `.collaboration/bugs/{bug-name}/frontend-handoff.md`。
- `backend-typescript` 与 `backend-springboot` Bug 模式消费 `.collaboration/bugs/{bug-name}/backend-handoff.md`。
- `split-repo` 下，上述实现类 skill 只在目标业务仓运行，不在协作仓直接实现业务代码。
- `qa-engineer` Bug 模式必须读取 `.collaboration/bugs/{bug-name}/bug.md`，并同时拿到至少一项实现证据。
- `code-reviewer` 必须拿到至少一个 Feature 或 Bug 上下文文档，才能确定 `.collaboration/features/{feature-name}/code-review.md` 或 `.collaboration/bugs/{bug-name}/code-review.md` 的落点。

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

## 同步与校验脚本

脚本详解见 [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)。

常用命令：

```bash
./scripts/generate-agents-from-skills.sh
./scripts/sync-skill-agent.sh
./scripts/sync-skill-agent.sh tech-lead
./scripts/sync-platform-adapters.sh --with-skills
./scripts/verify-platform-adapters.sh
```

## 相关文档

- [README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/README.md)
- [QUICKSTART.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/QUICKSTART.md)
- [docs/workspace-modes.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/workspace-modes.md)
- [agents/README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/agents/README.md)
- [docs/skills-vs-subagents.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/skills-vs-subagents.md)
- [docs/skill-agent-sync-guide.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/skill-agent-sync-guide.md)
