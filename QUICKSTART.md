# 5 分钟快速上手

## 核心概念

本方案基于 **Skills（技能）** 与 **Subagents（子代理）** 实现 AI 协作编程。主链路直接调用 skill；需要平台 subagent 运行时文件时，再执行同步脚本。

## 11 个核心 Skills

| Skill | 触发短语 | 用途 |
|-------|---------|------|
| `product-manager` | 作为产品经理、帮我写 PRD | 需求分析、PRD、用户故事 |
| `project-manager` | 作为项目经理、帮我排期 | 项目排期、风险评估 |
| `tech-lead` | 作为技术负责人、设计技术方案 | 架构设计、API 契约 |
| `frontend-design` | 作为设计师、帮我设计页面 | UI/UX 设计、组件设计 |
| `backend-typescript` | 作为后端工程师、帮我写接口 | TypeScript + NestJS |
| `backend-springboot` | 作为 Java 工程师、帮我写接口 | Java + Spring Boot |
| `frontend` | 作为前端工程师、帮我写组件 | React 19 + 现代前端技术栈 |
| `qa-engineer` | 作为测试工程师、帮我写测试 | 测试用例、自动化测试 |
| `code-reviewer` | 帮我审查代码 | 代码质量、安全审查 |
| `master-coordinator` | 组织并行设计和技术方案、联合评审 | 协调多角色、冲突检测 |
| `git-commit` | 帮我生成提交信息 | Git 提交规范（Gitmoji） |

**注意**: 
- 提供两个后端 Skill，根据技术栈选择使用
- 前端开发前需要先进行设计（frontend-design → frontend）
- 文档协同链路由 `master-coordinator` 统一调度 `project-manager`、`tech-lead`、`frontend-design`

---

## 使用方式（主链路直接调用）

### OpenCode（推荐）

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: product-manager)

# 3. 描述任务（用@引用文件）
请帮我创建手机号登录功能的 PRD。

## 背景
用户反馈登录流程太复杂。

## 业务目标
- 提升登录转化率 15%
- 降低客服咨询量 30%
```

**主链路直接调用** - 直接用 `skill(name: xxx)` 加载，用 `@` 引用文件；如需 subagent 运行时，再执行同步脚本。

---

## 完整工作流示例

### 场景：手机号登录功能

#### 1️⃣ 产品经理 - 创建 PRD

```
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

---

#### 2️⃣ 主协调器 - 并行组织方案与评审

```
skill(name: master-coordinator)

请继续负责手机号登录功能的协调工作。

## PRD
@.collaboration/features/mobile-login/prd.md

## 协同要求
- 首轮并行调用 @project-manager 和 @tech-lead
- @tech-lead 不需要等待 plan.md
- 在计划和技术上下文成熟后，再调用 @frontend-design
- 每轮先汇总结果，再问我是“通过”还是“继续澄清/修订”
- 如果识别到新增功能，停止当前链路并提示我回到 product-manager
```

**产出**: `.collaboration/features/mobile-login/plan.md`, `.collaboration/features/mobile-login/tech.md`, `.collaboration/features/mobile-login/api.yaml`, `.collaboration/features/mobile-login/design.md`, `.collaboration/features/mobile-login/design-components.md`, `.collaboration/features/mobile-login/review.md`

---

#### 3️⃣ 后端开发 - 实现 API

**TypeScript 技术栈**:
```
skill(name: backend-typescript)

请实现手机号登录接口。

## API 契约
@.collaboration/features/mobile-login/api.yaml

## 技术方案
@.collaboration/features/mobile-login/tech.md

## 技术栈
- TypeScript + NestJS
- TypeORM + MySQL
- Jest (测试)

## 任务
1. AuthController（sendCode, login）
2. AuthService（业务逻辑）
3. DTO（LoginDto, SendCodeDto）
4. 单元测试

请输出完整代码。
```

**Java 技术栈**:
```
skill(name: backend-springboot)

请实现手机号登录接口。

## API 契约
@.collaboration/features/mobile-login/api.yaml

## 技术方案
@.collaboration/features/mobile-login/tech.md

## 技术栈
- Java 21 + Spring Boot
- MyBatis-Plus + PostgreSQL
- JUnit 5 (测试)

## 任务
1. AuthController（@RestController）
2. AuthService（@Service）
3. AuthMapper（@Mapper）
4. Entity/DTO（Record + Lombok）
5. 单元测试

请输出完整代码。
```

**产出**: `src/auth/*.ts` / `src/main/java/**/*.java`, `tests/**/*.test.ts` / `src/test/java/**/*.java`

---

#### 4️⃣ 前端开发 - 实现页面与交互

```
skill(name: frontend)

请实现手机号登录页面。

## 设计方案
@.collaboration/features/mobile-login/design.md

## 组件契约
@.collaboration/features/mobile-login/design-components.md

## API 契约
@.collaboration/features/mobile-login/api.yaml

## 技术方案
@.collaboration/features/mobile-login/tech.md

请输出符合现有仓库结构的前端实现代码。
```

**产出**: `src/pages/**/*.tsx` 或仓库中的前端真实源码路径

---

#### 5️⃣ 测试工程师 - 汇总测试用例与测试建议

```
skill(name: qa-engineer)

请基于 PRD、API 契约和实现结果整理测试用例与测试建议。

## PRD
@.collaboration/features/mobile-login/prd.md

## API 契约
@.collaboration/features/mobile-login/api.yaml

## 技术方案
@.collaboration/features/mobile-login/tech.md
```

**产出**: 测试用例、测试建议、测试汇总

---

#### 6️⃣ 代码审查

```
skill(name: code-reviewer)

请审查以下代码。

## PR
https://github.com/xxx/xxx/pull/123

## 审查维度
1. 代码质量（命名、注释、函数长度）
2. 架构设计（分层、职责）
3. 错误处理（try-catch、日志）
4. 安全性（注入、认证）
5. 性能（查询、缓存）
6. 测试覆盖

请输出 Code Review 报告。

## 技术方案
@.collaboration/features/mobile-login/tech.md
```

**产出**: Code Review 报告

---

## 配置到 AI 工具

### OpenCode（开箱即用）

如需使用 OpenCode subagent 运行时，先生成：

```bash
./scripts/sync-platform-adapters.sh
```

Skills 继续以仓库中的 `skills/` 作为事实源：

```bash
# 全局安装（可选）
cp -r skills/* ~/.config/opencode/skills/
```

### Claude Desktop

```bash
# 配置 Skills
mkdir -p ~/.claude/skills
cp skills/backend-typescript/SKILL.md ~/.claude/skills/  # TypeScript 技术栈
cp skills/backend-springboot/SKILL.md ~/.claude/skills/  # Java 技术栈
```

### GitHub Copilot

```bash
# 配置 Instructions
mkdir -p .github
cat skills/backend-typescript/SKILL.md >> .github/copilot-instructions.md  # TypeScript 技术栈
```

### Cursor

```bash
# 配置 Rules
cat skills/backend-typescript/SKILL.md >> .cursorrules  # TypeScript 技术栈
```

---

## 最佳实践

### ✅ 应该做的

1. **直接用 skill 调用** - `skill(name: xxx)`
2. **用@引用文件** - `@.collaboration/features/mobile-login/api.yaml`
3. **明确角色** - 每个步骤使用对应的 Skill
4. **让 master-coordinator 负责文档协同链路** - 不要手动串联文档角色
5. **检查质量** - 使用质量检查清单

### ❌ 不应该做的

1. **跳过 Skill** - 直接让 AI 生成
2. **不提供上下文** - 用@引用相关文档
3. **角色混乱** - 不要混用多个 Skill

---

## 下一步

- 📖 [README.md](README.md) - 完整方案
- 🛠️ [skills/README.md](skills/README.md) - Skills 详情
- 💡 [examples/](examples/) - 各 Skill 示例

**开始使用！** 🚀

```bash
opencode
skill(name: product-manager)
```
