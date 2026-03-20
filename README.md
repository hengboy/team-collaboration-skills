# AI 协作团队方案

> 基于 Skills 与 Subagents 的 Feature / Bug 双主链路协作流程

## 概述

本仓库定义了一套面向 AI 编程场景的协作规范：

- Feature 链路以 `product-manager` + `feature-coordinator` 为主
- Bug 链路以 `bug-coordinator` 为独立入口
- 协作仓负责文档、判责、评审与收口
- 前后端业务代码继续在各自业务仓实现
- Skills 是事实源，Subagents 是边界清晰角色的并行执行形态

## 12 个核心 Skills

| Skill | 用途 |
|-------|------|
| `product-manager` | 需求分析、PRD、用户故事 |
| `bug-coordinator` | 缺陷 intake、判责拆单、handoff 与收口 |
| `project-manager` | 项目排期、风险评估、资源分配 |
| `tech-lead` | 技术方案、API 契约、修复策略 |
| `frontend-design` | UI/UX 设计、组件契约、缺陷设计修订 |
| `backend-typescript` | TypeScript 后端实现 |
| `backend-springboot` | Java + Spring Boot 后端实现 |
| `frontend` | React 前端实现 |
| `qa-engineer` | 测试用例、自动化测试、测试汇总 |
| `code-reviewer` | findings-first 代码审查 |
| `feature-coordinator` | Feature 协调、多角色评审、冲突检测 |
| `git-commit` | Git 提交规范（Gitmoji） |

## 双主链路

### Feature 标准流程

```text
原始需求
  -> product-manager
  -> feature-coordinator
    -> project-manager subagent
    -> tech-lead subagent
    -> frontend-design subagent
  -> 联合评审
  -> frontend / backend
  -> qa-engineer
  -> code-reviewer
  -> git-commit
```

Feature 链路说明：

1. `product-manager` 产出 `.collaboration/features/{feature-name}/prd.md`
2. `feature-coordinator` 在主会话并行拉起 `project-manager`、`tech-lead`、`frontend-design`
3. 首轮需先回收 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`
4. 联合评审通过后，前后端在各自业务仓按文档实现
5. `qa-engineer` 产出 `.collaboration/features/{feature-name}/test-cases.md`，并按需补充 `.collaboration/features/{feature-name}/qa-report.md`
6. `code-reviewer` 产出 `.collaboration/features/{feature-name}/code-review.md`，并按需补充 `.collaboration/features/{feature-name}/security-review.md`
7. `git-commit` 作为统一提交收尾环节

### Bug 标准流程

```text
issue / 报警 / 用户反馈 / 日志
  -> bug-coordinator
    -> tech-lead subagent
    -> frontend-design subagent (optional)
    -> project-manager subagent (optional)
  -> frontend-handoff / backend-handoff
  -> frontend repo / backend repo
  -> qa-engineer
  -> code-reviewer
  -> git-commit
```

Bug 链路说明：

1. `bug-coordinator` 补齐 `.collaboration/bugs/{bug-name}/bug.md`
2. `tech-lead` 默认以 Bug 模式产出 `.collaboration/bugs/{bug-name}/fix-plan.md`
3. `bug-coordinator` 判断是前端、后端还是联调缺陷
4. 单边缺陷只生成一份 handoff；联调缺陷同时生成 `.collaboration/bugs/{bug-name}/frontend-handoff.md` 与 `.collaboration/bugs/{bug-name}/backend-handoff.md`
5. 前后端业务仓各自拉取 handoff 文档并编码，再回传 PR、测试结果和变更摘要
6. `bug-coordinator` 回到协作仓，以 Bug 模式统一驱动 `qa-engineer`、`code-reviewer` 与 `git-commit`

## 双模式角色约定

- `tech-lead`、`frontend-design`、`project-manager`、`frontend`、`backend-typescript`、`backend-springboot`、`qa-engineer`、`code-reviewer` 都支持 Feature / Bug 双模式
- 发现 `.collaboration/features/{feature-name}/...` 输入时进入 Feature 模式
- 发现 `.collaboration/bugs/{bug-name}/...` 输入时进入 Bug 模式
- 路径缺失时，才允许使用 frontmatter 的 `feature:` 或 `bug:` 作为兜底
- 同一次调用里若混入 Feature 与 Bug 两套工作项目录，相关角色必须停止并要求上游协调器先统一上下文
- 实现类角色在 Bug 模式下服务于下游业务仓：`frontend` 消费 `.collaboration/bugs/{bug-name}/frontend-handoff.md`，`backend-*` 消费 `.collaboration/bugs/{bug-name}/backend-handoff.md`

## 快速开始

### Feature 入口

```text
skill(name: product-manager)

请帮我创建手机号登录功能的 PRD。

## 背景
用户反馈登录流程太复杂。

## 业务目标
- 提升登录转化率 15%
```

### Bug 入口

```text
skill(name: bug-coordinator)

请继续协调支付确认页点击“立即支付”后返回 500 的缺陷修复。

## 原始问题
- 环境：生产环境
- 首次发现：2026-03-20 09:45 CST
- 影响版本：web 2.8.4 / api 3.1.7
- 现象：支付确认页点击“立即支付”后返回 500
- 证据：Sentry issue、Nginx 错误日志、客服反馈截图
```

## 常见产物

### Feature

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

### Bug

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

## 目录结构

```text
project/
├── README.md
├── QUICKSTART.md
├── skills/
├── agents/
├── examples/
├── docs/
├── .collaboration/
│   ├── features/
│   ├── bugs/
│   └── shared/
└── scripts/
```

## 维护脚本

脚本详解见 [docs/scripts.md](docs/scripts.md)。

### 1. 校验 skill / agent 对齐

```bash
./scripts/sync-skill-agent.sh
./scripts/sync-skill-agent.sh tech-lead
```

### 2. 生成平台运行时

```bash
./scripts/sync-platform-adapters.sh --agents-only
./scripts/sync-platform-adapters.sh --with-skills
```

### 3. 提交前全量校验

```bash
./scripts/verify-platform-adapters.sh
```

## 配置到 AI 工具

### OpenCode

- skills 继续以仓库中的 `skills/` 作为事实源
- 如需 OpenCode subagent runtime，请运行 `./scripts/sync-platform-adapters.sh --agents-only`

### Claude / Gemini

- 如需复制生成后的 skills / agents，请先运行 `./scripts/sync-platform-adapters.sh --with-skills`
- 生成物分别位于 `.claude/` 与 `.gemini/`

详细说明见 [docs/platform-runtime-adapters.md](docs/platform-runtime-adapters.md) 与 [docs/ai-tool-configs.md](docs/ai-tool-configs.md)。

## 文档索引

| 文档 | 用途 |
|------|------|
| [QUICKSTART.md](QUICKSTART.md) | 5 分钟快速上手 |
| [skills/README.md](skills/README.md) | Skills 使用指南 |
| [agents/README.md](agents/README.md) | Agent 逻辑源与生成物说明 |
| [docs/scripts.md](docs/scripts.md) | 仓库脚本说明与示例 |
| [docs/ai-tool-configs.md](docs/ai-tool-configs.md) | AI 工具配置 |
| [docs/skills-vs-subagents.md](docs/skills-vs-subagents.md) | Skill / Subagent 决策说明 |
| [docs/platform-runtime-adapters.md](docs/platform-runtime-adapters.md) | 平台运行时适配 |
| [docs/skill-agent-sync-guide.md](docs/skill-agent-sync-guide.md) | Skill / Agent 同步指南 |
| [docs/skill-vs-agent-mapping.md](docs/skill-vs-agent-mapping.md) | Skill / Agent 映射规则 |
| [docs/multi-repo-best-practices.md](docs/multi-repo-best-practices.md) | 多仓协作最佳实践 |
| [REQUIREMENT-FLOW-ANALYSIS.md](REQUIREMENT-FLOW-ANALYSIS.md) | 当前协作链路深度分析 |

## 当前状态

- 当前版本：v8.0.0
- 最近一次文档口径对齐：2026-03-20
- 当前同步模型：主章节直接对齐 + 强制约束精确校验
