# AI 协作团队方案

> 基于 Skills 与 Subagents 的 Feature / Bug 双主链路协作流程

## 概述

本仓库定义了一套面向 AI 编程场景的协作规范：

- 默认工作模式是 `single-repo`
- 在业务仓直接配置 `skills` / `subagents` 后即可启动 Feature / Bug 双主链路
- `split-repo` 继续受支持，但必须在 `.collaboration/shared/workspace.md` 中显式声明
- Feature 链路以 `product-manager` + `feature-coordinator` 为主
- Bug 链路以 `bug-coordinator` 为独立入口
- Skills 是事实源，Subagents 是边界清晰角色的并行执行形态

## 工作模式

### `single-repo`（默认）

- 当前仓同时维护 `.collaboration/` 文档和真实业务代码
- Feature 联合评审通过后，由 `feature-coordinator` 在当前仓并行调度 `frontend` / `backend-*` subagent
- Bug 仍先生成 handoff，但由 `bug-coordinator` 调度当前仓实现 subagent 消费

### `split-repo`（显式启用）

- 当前仓是协作仓，真实业务代码位于外部业务仓
- Feature 联合评审通过后，`feature-coordinator` 只提示是否提交并推送当前协作文档，不在协作仓继续引导进入实现类 skill
- Bug handoff 交给外部业务仓消费，后续由外部仓回传 PR、测试结果和变更摘要

### `workspace_mode` 解析顺序

1. 当前工作项文档 frontmatter 中的 `workspace_mode`
2. `.collaboration/shared/workspace.md`
3. 默认值 `single-repo`

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
  -> single-repo: frontend / backend subagents (parallel)
  -> single-repo: qa-engineer subagent
  -> single-repo: code-reviewer subagent
  -> split-repo: git-commit（协作文档提交 / 推送）
```

Feature 链路说明：

1. `product-manager` 产出 `.collaboration/features/{feature-name}/prd.md`，并写入当前生效的 `workspace_mode`
2. `feature-coordinator` 在主会话并行拉起 `project-manager`、`tech-lead`、`frontend-design`
3. 首轮需先回收 `.collaboration/features/{feature-name}/plan.md`、`.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml`、`.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md`
4. 联合评审通过后：
   - `single-repo`：`feature-coordinator` 在主会话并行调度 `frontend` 与对应 `backend-*` subagent，回收实现证据后再串行调度 `qa-engineer`、`code-reviewer`，阻塞关闭后进入 `git-commit`
   - `split-repo`：`feature-coordinator` 更新 `.collaboration/features/{feature-name}/review.md` 并提示是否提交、推送当前协作文档；当前协作会话不再进入 `frontend` / `backend-*`
5. 若 `split-repo` 模式下后续发现原需求仍有问题，回到协作仓用同一 `feature-name` 重开 `feature-coordinator`；超出原 PRD 范围则回退到 `product-manager` 新建 feature

### Bug 标准流程

```text
issue / 报警 / 用户反馈 / 日志
  -> bug-coordinator
    -> tech-lead subagent
    -> frontend-design subagent (optional)
    -> project-manager subagent (optional)
  -> frontend-handoff / backend-handoff
  -> single-repo: current repo frontend / backend subagents (parallel by scope)
  -> split-repo: frontend repo / backend repo
  -> qa-engineer subagent
  -> code-reviewer subagent
  -> git-commit
```

Bug 链路说明：

1. `bug-coordinator` 补齐 `.collaboration/bugs/{bug-name}/bug.md`，并写入当前生效的 `workspace_mode`
2. `tech-lead` 默认以 Bug 模式产出 `.collaboration/bugs/{bug-name}/fix-plan.md`
3. `bug-coordinator` 判断是前端、后端还是联调缺陷
4. 单边缺陷只生成一份 handoff；联调缺陷同时生成 `.collaboration/bugs/{bug-name}/frontend-handoff.md` 与 `.collaboration/bugs/{bug-name}/backend-handoff.md`
5. `single-repo` 下，`bug-coordinator` 按判责结果并行调度当前仓实现 subagent 消费 handoff 并回传 diff、测试结果或构建结果
6. `split-repo` 下，外部业务仓消费 handoff 并回传 PR、测试结果和变更摘要
7. `bug-coordinator` 回收实现证据后，以 Bug 模式串行驱动 `qa-engineer`、`code-reviewer` 与 `git-commit`

## 双模式角色约定

- 仓库级默认模式由 `.collaboration/shared/workspace.md` 的 `workspace_mode` 指定；缺失时默认 `single-repo`
- `tech-lead`、`frontend-design`、`project-manager`、`frontend`、`backend-typescript`、`backend-springboot`、`qa-engineer`、`code-reviewer` 都支持 Feature / Bug 双模式
- 发现 `.collaboration/features/{feature-name}/...` 输入时进入 Feature 模式
- 发现 `.collaboration/bugs/{bug-name}/...` 输入时进入 Bug 模式
- 路径缺失时，才允许使用 frontmatter 的 `feature:` 或 `bug:` 作为兜底
- 当前工作项文档 frontmatter 如包含 `workspace_mode`，优先于仓库级默认值
- 同一次调用里若混入 Feature 与 Bug 两套工作项目录，相关角色必须停止并要求上游协调器先统一上下文
- `single-repo` 下，正式协作链路中的实现类与收口角色优先由协调器以 subagent 调度；这些角色仍保留 direct skill 入口，供独立调用或 `split-repo` 目标业务仓使用
- `split-repo` 下，实现类角色只在目标业务仓运行；Bug 模式由 `frontend` 消费 `.collaboration/bugs/{bug-name}/frontend-handoff.md`，`backend-*` 消费 `.collaboration/bugs/{bug-name}/backend-handoff.md`

## 快速开始

### 仓库默认模式

```markdown
---
workspace_mode: single-repo
---
```

把上面的内容保存到 `.collaboration/shared/workspace.md`。如需启用分仓协作，把值改成 `split-repo`。

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

### 仓库级

- `.collaboration/shared/workspace.md`

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
│       └── workspace.md
└── scripts/
```

## 维护脚本

脚本详解见 [docs/scripts.md](docs/scripts.md)。

### 1. 从 skill 生成 AGENT 逻辑源

```bash
./scripts/generate-agents-from-skills.sh
./scripts/generate-agents-from-skills.sh tech-lead
```

### 2. 校验 skill / agent 对齐

```bash
./scripts/sync-skill-agent.sh
./scripts/sync-skill-agent.sh tech-lead
```

### 3. 生成平台运行时

```bash
./scripts/sync-platform-adapters.sh --agents-only
./scripts/sync-platform-adapters.sh --with-skills
```

### 4. 提交前全量校验

```bash
./scripts/verify-platform-adapters.sh
```

## 配置到 AI 工具

### OpenCode

- skills 继续以仓库中的 `skills/` 作为事实源
- 如需 OpenCode subagent runtime，请先运行 `./scripts/generate-agents-from-skills.sh`，再运行 `./scripts/sync-platform-adapters.sh --agents-only`

### Claude / Gemini

- 如需复制生成后的 skills / agents，请先运行 `./scripts/generate-agents-from-skills.sh`，再运行 `./scripts/sync-platform-adapters.sh --with-skills`
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
| [docs/workspace-modes.md](docs/workspace-modes.md) | `single-repo` / `split-repo` 模式说明 |
| [docs/skills-vs-subagents.md](docs/skills-vs-subagents.md) | Skill / Subagent 决策说明 |
| [docs/platform-runtime-adapters.md](docs/platform-runtime-adapters.md) | 平台运行时适配 |
| [docs/skill-agent-sync-guide.md](docs/skill-agent-sync-guide.md) | Skill / Agent 同步指南 |
| [docs/skill-vs-agent-mapping.md](docs/skill-vs-agent-mapping.md) | Skill / Agent 映射规则 |
| [docs/multi-repo-best-practices.md](docs/multi-repo-best-practices.md) | 多仓协作最佳实践 |
| [REQUIREMENT-FLOW-ANALYSIS.md](REQUIREMENT-FLOW-ANALYSIS.md) | 当前协作链路深度分析 |

## 当前状态

- 当前版本：v8.0.0
- 最近一次文档口径对齐：2026-03-20
- 当前同步模型：`skills/` 事实源 -> `agents/` 派生物 -> runtime 生成物
