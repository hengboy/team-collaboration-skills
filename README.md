# AI 协作团队方案

> 基于 Skills 与 Subagents 的 Feature / Bug 双主链路协作流程

## 概述

当研发团队全面使用 AI 编程时，如何通过 **Skills（技能）** 与 **Subagents（子代理）** 实现标准化流转。

- Feature 链路以 `product-manager` + `feature-coordinator` 为主
- Bug 链路以 `bug-coordinator` 为独立入口
- 协作仓负责文档、判责、评审与收口
- 前后端业务代码继续在各自业务仓实现

## 核心理念

1. **中间产物驱动** - 所有协作通过结构化文档传递
2. **双主链路** - Feature 与 Bug 分别建模，避免把缺陷修复硬塞进需求流程
3. **Skills 标准化** - 每个角色一个 Skill 定义
4. **混合协作** - 主协调链路使用 skill，清晰边界角色优先以 subagent 并行执行
5. **分仓协作** - 协作仓产出 handoff 文档，业务仓各自实现并回传结果

## 12 个核心 Skills

| Skill | 触发短语 | 用途 |
|-------|---------|------|
| `product-manager` | 作为产品经理、帮我写 PRD | 需求分析、PRD、用户故事 |
| `bug-coordinator` | 帮我协调 Bug 修复 | 缺陷 intake、判责拆单、handoff 与收口 |
| `project-manager` | 作为项目经理、帮我排期 | 项目排期、风险评估、资源分配 |
| `tech-lead` | 作为技术负责人、设计技术方案 | 架构设计、API 契约、修复策略 |
| `frontend-design` | 作为设计师、帮我设计页面 | UI/UX 设计、组件设计、缺陷设计修订 |
| `backend-typescript` | 作为后端工程师、帮我写接口 | TypeScript + NestJS |
| `backend-springboot` | 作为 Java 工程师、帮我写接口 | Java + Spring Boot |
| `frontend` | 作为前端工程师、帮我写组件 | React 19 + 现代前端技术栈 |
| `qa-engineer` | 作为测试工程师、帮我写测试 | 测试用例、自动化测试、测试汇总 |
| `code-reviewer` | 帮我审查代码 | findings-first 代码质量与风险审查 |
| `feature-coordinator` | 组织并行设计和技术方案、联合评审 | Feature 协调、多角色评审、冲突检测 |
| `git-commit` | 帮我生成提交信息 | Git 提交规范（Gitmoji） |

**注意**:

- 提供两个后端 Skill，根据技术栈选择
- 前端开发前需要先进行设计（`frontend-design` → `frontend`）
- `feature-coordinator` 只负责 Feature 主链路
- `bug-coordinator` 只负责 Bug 主链路
- Bug 修复默认不在当前协作仓直接写业务代码，而是交由前后端业务仓各自实现

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
3. 首轮需先回收 `plan.md`、`tech.md`、`api.yaml`、`design.md`、`design-components.md`
4. 联合评审通过后，前后端在各自业务仓按文档实现
5. QA、Code Review、Commit 作为统一收尾环节

### Bug 标准流程

```text
issue / 报警 / 用户反馈 / 日志
  -> bug-coordinator
    -> tech-lead subagent
    -> frontend-design subagent (optional)
    -> project-manager subagent (optional)
  -> frontend-handoff.md / backend-handoff.md
  -> frontend repo / backend repo
  -> qa-engineer
  -> code-reviewer
  -> git-commit
```

Bug 链路说明：

1. `bug-coordinator` 补齐 `.collaboration/bugs/{bug-name}/bug.md`
2. `tech-lead` 默认产出 `.collaboration/bugs/{bug-name}/fix-plan.md`
3. `bug-coordinator` 判断是前端、后端还是联调缺陷
4. 单边缺陷只生成一份 handoff；联调缺陷同时生成 `frontend-handoff.md` 与 `backend-handoff.md`
5. 前后端业务仓各自拉取 handoff 文档并编码，再回传 PR、测试结果和变更摘要
6. `bug-coordinator` 回到协作仓统一驱动 `qa-engineer`、`code-reviewer` 与 `git-commit`
7. 生产环境发现的缺陷仍走常规链路，不单独开应急特批分支，只要求补齐版本、告警和影响范围信息

---

## 快速开始

### Feature 入口

```bash
opencode
skill(name: product-manager)

请帮我创建手机号登录功能的 PRD。

## 背景
用户反馈登录流程太复杂。

## 业务目标
- 提升登录转化率 15%
```

### Bug 入口

```bash
opencode
skill(name: bug-coordinator)

请继续协调支付确认页点击“立即支付”后返回 500 的缺陷修复。

## 原始问题
- 环境：生产环境
- 首次发现：2026-03-20 09:45 CST
- 影响版本：web 2.8.4 / api 3.1.7
- 现象：支付确认页点击“立即支付”后返回 500
- 证据：Sentry issue、Nginx 错误日志、客服反馈截图
```

**主链路直接调用** - 用 `skill(name: xxx)` 和 `@` 引用文件；如需 subagent 运行时，再执行同步脚本。

---

## Feature 工作流

### Feature Coordinator 工作流

```bash
opencode
skill(name: feature-coordinator)

请继续负责手机号登录功能的协调工作。

## PRD
@.collaboration/features/mobile-login/prd.md

## 要求
- 首轮并行调用 @project-manager、@tech-lead 和 @frontend-design
- @tech-lead 不需要等待 plan.md
- @frontend-design 直接基于 PRD 开始
- 每轮先汇总结果，再问我是“通过”还是“继续澄清/修订”
- 如果识别到新增功能，停止当前链路并提示我回到 product-manager
```

Feature 最终产物：

- `.collaboration/features/mobile-login/prd.md`
- `.collaboration/features/mobile-login/plan.md`
- `.collaboration/features/mobile-login/tech.md`
- `.collaboration/features/mobile-login/api.yaml`
- `.collaboration/features/mobile-login/design.md`
- `.collaboration/features/mobile-login/design-components.md`
- `.collaboration/features/mobile-login/review.md`

### Feature 评审通过后

```text
✅ 评审通过 - 可以进入开发阶段

下一步：
- 前端业务仓消费 design.md、design-components.md、api.yaml
- 后端业务仓消费 tech.md、api.yaml
- 不要让 feature-coordinator 继续代替实现角色写业务代码
```

---

## Bug 工作流

### Bug Coordinator 工作流

```bash
opencode
skill(name: bug-coordinator)

请继续协调支付确认页点击“立即支付”后返回 500 的缺陷修复。

## 原始问题
- 环境：生产环境
- 首次发现：2026-03-20 09:45 CST
- 影响版本：web 2.8.4 / api 3.1.7
- 用户影响：支付确认页无法完成下单，影响核心转化
- 证据：Sentry issue、Nginx 错误日志、客服反馈截图

## 要求
- 先补齐 `.collaboration/bugs/payment-submit-500/bug.md`
- 默认调用 @tech-lead 产出 `fix-plan.md`
- 若判定为联调缺陷，分别生成 `frontend-handoff.md` 和 `backend-handoff.md`
- 前后端业务仓回传 PR、测试结果和变更摘要后，再统一进入 QA / Review
- 若识别到这不是缺陷而是新增需求，请提示我回到 product-manager
```

Bug 常见产物：

- `.collaboration/bugs/payment-submit-500/bug.md`
- `.collaboration/bugs/payment-submit-500/fix-plan.md`
- `.collaboration/bugs/payment-submit-500/frontend-handoff.md`
- `.collaboration/bugs/payment-submit-500/backend-handoff.md`
- `.collaboration/bugs/payment-submit-500/test-cases.md`
- `.collaboration/bugs/payment-submit-500/qa-report.md`
- `.collaboration/bugs/payment-submit-500/code-review.md`

### Bug 收口要求

- 前端业务仓只修复前端问题
- 后端业务仓只修复后端问题
- 联调缺陷由 `bug-coordinator` 先判责再拆单
- 业务仓必须回传 PR 链接、测试结果和变更摘要
- `qa-engineer` 覆盖原始复现、修复后路径、边界条件和回归风险
- `code-reviewer` 以 findings-first 输出阻塞项与残余风险

---

## 目录结构

```text
project/
├── README.md
├── QUICKSTART.md
├── REQUIREMENT-FLOW-ANALYSIS.md
├── skills/                         # Skills 定义（12 个）
│   ├── product-manager/SKILL.md
│   ├── bug-coordinator/SKILL.md
│   ├── project-manager/SKILL.md
│   ├── tech-lead/SKILL.md
│   ├── frontend-design/SKILL.md
│   ├── backend-typescript/SKILL.md
│   ├── backend-springboot/SKILL.md
│   ├── frontend/SKILL.md
│   ├── qa-engineer/SKILL.md
│   ├── code-reviewer/SKILL.md
│   ├── feature-coordinator/SKILL.md
│   └── git-commit/SKILL.md
├── examples/
│   └── bug-coordinator/
├── docs/
├── .collaboration/
│   ├── features/
│   │   └── {feature-name}/
│   ├── bugs/
│   │   └── {bug-name}/
│   └── shared/
└── scripts/
```

### 文件命名规范

| 类型 | 命名规则 | 示例 |
|------|---------|------|
| PRD | `.collaboration/features/{feature-name}/prd.md` | `.collaboration/features/mobile-login/prd.md` |
| Feature 技术方案 | `.collaboration/features/{feature-name}/tech.md` | `.collaboration/features/mobile-login/tech.md` |
| Feature API 契约 | `.collaboration/features/{feature-name}/api.yaml` | `.collaboration/features/mobile-login/api.yaml` |
| Feature 评审记录 | `.collaboration/features/{feature-name}/review.md` | `.collaboration/features/mobile-login/review.md` |
| Bug 主文档 | `.collaboration/bugs/{bug-name}/bug.md` | `.collaboration/bugs/payment-submit-500/bug.md` |
| Bug 修复策略 | `.collaboration/bugs/{bug-name}/fix-plan.md` | `.collaboration/bugs/payment-submit-500/fix-plan.md` |
| 前端交接文档 | `.collaboration/bugs/{bug-name}/frontend-handoff.md` | `.collaboration/bugs/payment-submit-500/frontend-handoff.md` |
| 后端交接文档 | `.collaboration/bugs/{bug-name}/backend-handoff.md` | `.collaboration/bugs/payment-submit-500/backend-handoff.md` |
| QA 报告 | `.collaboration/bugs/{bug-name}/qa-report.md` | `.collaboration/bugs/payment-submit-500/qa-report.md` |
| Code Review | `.collaboration/bugs/{bug-name}/code-review.md` | `.collaboration/bugs/payment-submit-500/code-review.md` |

---

## 配置到 AI 工具

### OpenCode

如需使用 OpenCode subagent 运行时，请先生成：

```bash
./scripts/sync-platform-adapters.sh
```

Skills 继续以仓库中的 `skills/` 作为事实源：

```bash
cp -r skills/* ~/.config/opencode/skills/
```

### Claude Desktop

```bash
mkdir -p ~/.claude/skills
cp skills/bug-coordinator/SKILL.md ~/.claude/skills/
cp skills/backend-typescript/SKILL.md ~/.claude/skills/
cp skills/backend-springboot/SKILL.md ~/.claude/skills/
```

---

## 文档索引

| 文档 | 用途 |
|------|------|
| [QUICKSTART.md](QUICKSTART.md) | 5 分钟快速上手 |
| [REQUIREMENT-FLOW-ANALYSIS.md](REQUIREMENT-FLOW-ANALYSIS.md) | Feature 需求流转深度分析 |
| [skills/README.md](skills/README.md) | Skills 使用指南 |
| [docs/ai-tool-configs.md](docs/ai-tool-configs.md) | AI 工具配置 |
| [docs/skills-vs-subagents.md](docs/skills-vs-subagents.md) | Skill / Subagent 决策说明 |

---

## 版本

- **当前版本**: v8.0.0
- **更新日期**: 2026-03-20
- **特点**:
  - 新增 `bug-coordinator`，建立独立 Bug 主链路
  - Feature 与 Bug 分离为两套标准流程
  - Bug 修复支持前后端分仓 handoff 与统一收口
  - 保留 `feature-coordinator` 的 Feature 联合评审机制
