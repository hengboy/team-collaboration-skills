# 5 分钟快速上手

## 核心概念

本方案基于 **Skills（技能）** 与 **Subagents（子代理）** 实现 AI 协作编程，并拆分成两条主链路：

- Feature 链路：`product-manager` → `feature-coordinator`
- Bug 链路：`bug-coordinator`

主链路直接调用 skill；需要平台 subagent 运行时文件时，再执行同步脚本。

## 12 个核心 Skills

| Skill | 触发短语 | 用途 |
|-------|---------|------|
| `product-manager` | 作为产品经理、帮我写 PRD | 需求分析、PRD、用户故事 |
| `bug-coordinator` | 帮我协调 Bug 修复 | 缺陷 intake、判责拆单、handoff 与收口 |
| `project-manager` | 作为项目经理、帮我排期 | 项目排期、风险评估 |
| `tech-lead` | 作为技术负责人、设计技术方案 | 架构设计、API 契约、修复策略 |
| `frontend-design` | 作为设计师、帮我设计页面 | UI/UX 设计、组件设计、缺陷设计修订 |
| `backend-typescript` | 作为后端工程师、帮我写接口 | TypeScript + NestJS |
| `backend-springboot` | 作为 Java 工程师、帮我写接口 | Java + Spring Boot |
| `frontend` | 作为前端工程师、帮我写组件 | React 19 + 现代前端技术栈 |
| `qa-engineer` | 作为测试工程师、帮我写测试 | 测试用例、自动化测试 |
| `code-reviewer` | 帮我审查代码 | 代码质量、安全审查 |
| `feature-coordinator` | 组织并行设计和技术方案、联合评审 | Feature 协调、多角色评审 |
| `git-commit` | 帮我生成提交信息 | Git 提交规范（Gitmoji） |

**注意**:

- 提供两个后端 Skill，根据技术栈选择使用
- 前端开发前需要先进行设计（`frontend-design` → `frontend`）
- Feature 文档协同链路由 `feature-coordinator` 统一调度 `project-manager`、`tech-lead`、`frontend-design`
- Bug 文档协同链路由 `bug-coordinator` 统一负责 intake、判责、handoff 和收口
- Bug 业务代码不在当前协作仓实现，而是由前后端业务仓各自消费 handoff 文档并编码

---

## 使用方式（主链路直接调用）

### Feature 入口

```bash
opencode

skill(name: product-manager)

请帮我创建手机号登录功能的 PRD。

## 背景
用户反馈登录流程太复杂。

## 业务目标
- 提升登录转化率 15%
- 降低客服咨询量 30%
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

**主链路直接调用** - 直接用 `skill(name: xxx)` 加载，用 `@` 引用文件；如需 subagent 运行时，再执行同步脚本。

---

## 完整工作流示例

### 场景 A：手机号登录功能（Feature）

#### 1️⃣ 产品经理 - 创建 PRD

```text
skill(name: product-manager)

请帮我创建手机号登录功能的 PRD。

## 背景
当前登录流程存在问题：
- 仅支持账号密码登录
- 忘记密码需要邮件申诉（平均 2 天）
- 新用户流失率 35%

## 业务目标
- 登录转化率：65% → 80%（+15%）
- 客服咨询：100 → 70 次/天（-30%）
- NPS: 35 → 45（+10 分）

请输出完整的 PRD 文档，保存到 .collaboration/features/mobile-login/prd.md
```

**产出**: `.collaboration/features/mobile-login/prd.md`

#### 2️⃣ Feature 协调器 - 并行组织方案与评审

```text
skill(name: feature-coordinator)

请继续负责手机号登录功能的协调工作。

## PRD
@.collaboration/features/mobile-login/prd.md

## 协同要求
- 首轮并行调用 @project-manager、@tech-lead 和 @frontend-design
- @tech-lead 不需要等待 plan.md
- @frontend-design 直接基于 PRD 开始
- 每轮先汇总结果，再问我是“通过”还是“继续澄清/修订”
- 如果识别到新增功能，停止当前链路并提示我回到 product-manager
```

**产出**: `.collaboration/features/mobile-login/plan.md`, `.collaboration/features/mobile-login/tech.md`, `.collaboration/features/mobile-login/api.yaml`, `.collaboration/features/mobile-login/design.md`, `.collaboration/features/mobile-login/design-components.md`, `.collaboration/features/mobile-login/review.md`

**进入实现阶段时**:

- 前端业务仓消费 `design.md`、`design-components.md`、`api.yaml`
- 后端业务仓消费 `tech.md`、`api.yaml`
- `feature-coordinator` 不继续代替实现角色写业务代码

#### 3️⃣ 收口

```text
skill(name: qa-engineer)
skill(name: code-reviewer)
skill(name: git-commit)
```

---

### 场景 B：支付确认页 500（Bug）

#### 1️⃣ 缺陷协调器 - intake 与判责

```text
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
- 如果判定为联调 / 接口边界问题，分别生成 `frontend-handoff.md` 和 `backend-handoff.md`
- 业务仓回传 PR、测试结果和变更摘要后，再统一进入 QA / Review
- 如果识别到这不是缺陷而是新增需求，请提示我回到 product-manager
```

**产出**: `.collaboration/bugs/payment-submit-500/bug.md`, `.collaboration/bugs/payment-submit-500/fix-plan.md`, `.collaboration/bugs/payment-submit-500/frontend-handoff.md`, `.collaboration/bugs/payment-submit-500/backend-handoff.md`

#### 2️⃣ 业务仓实现

前端业务仓：

```text
请基于最新的 `.collaboration/bugs/payment-submit-500/frontend-handoff.md` 实现修复，并回传：
- PR 链接
- 测试结果
- 变更摘要
```

后端业务仓：

```text
请基于最新的 `.collaboration/bugs/payment-submit-500/backend-handoff.md` 实现修复，并回传：
- PR 链接
- 测试结果
- 变更摘要
```

#### 3️⃣ 回协作仓统一收口

```text
skill(name: qa-engineer)

请基于以下输入整理测试用例与测试结论：
- @.collaboration/bugs/payment-submit-500/bug.md
- @.collaboration/bugs/payment-submit-500/fix-plan.md
- 业务仓 PR 链接、测试结果和变更摘要
```

```text
skill(name: code-reviewer)

请以 findings-first 方式审查该缺陷修复，重点关注：
- 根因是否闭环
- 是否存在回归风险
- 测试覆盖是否足够
```

**最终产出**: `.collaboration/bugs/payment-submit-500/test-cases.md`, `.collaboration/bugs/payment-submit-500/qa-report.md`, `.collaboration/bugs/payment-submit-500/code-review.md`

---

## 配置到 AI 工具

### OpenCode（开箱即用）

如需使用 OpenCode subagent 运行时，先生成：

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

## 最佳实践

### ✅ 应该做的

1. **直接用 skill 调用** - `skill(name: xxx)`
2. **用@引用文件** - `@.collaboration/features/mobile-login/api.yaml`
3. **明确链路** - Feature 用 `feature-coordinator`，Bug 用 `bug-coordinator`
4. **让协调器负责协同** - 不要手动串联文档角色
5. **先交接后实现** - Bug 场景先产出 handoff，再由业务仓各自编码
6. **统一收口** - 业务仓回传结果后，再回协作仓做 QA / Review

### ❌ 不应该做的

1. **跳过 Skill** - 直接让 AI 生成
2. **不提供上下文** - 不给 issue、日志、文档或 PR
3. **链路混用** - 不要让 `feature-coordinator` 直接接 Bug，也不要让 `bug-coordinator` 去代替 Feature 联合评审
4. **在协作仓直接写 Bug 业务代码** - 缺陷实现应留在前后端业务仓

---

## 下一步

- 📖 [README.md](README.md) - 完整方案
- 🛠️ [skills/README.md](skills/README.md) - Skills 详情
- 💡 [examples/](examples/) - 各 Skill 示例

```bash
opencode
skill(name: bug-coordinator)
```
