# 5 分钟快速上手

## 核心概念

本方案基于 **Skills（技能）** 实现 AI 协作编程。**无需任何脚本**，直接在 AI 中调用 skill 即可。

## 9 个核心 Skills

| Skill | 触发短语 | 用途 |
|-------|---------|------|
| `product-manager` | 作为产品经理、帮我写 PRD | 需求分析、PRD、用户故事 |
| `project-manager` | 作为项目经理、帮我排期 | 项目排期、风险评估 |
| `tech-lead` | 作为技术负责人、设计技术方案 | 架构设计、API 契约 |
| `frontend-design` | 作为设计师、帮我设计页面 | UI/UX 设计、组件设计 |
| `backend-typescript` | 作为后端工程师、帮我写接口 | TypeScript + NestJS |
| `backend-springboot` | 作为 Java 工程师、帮我写接口 | Java + Spring Boot |
| `frontend-engineer` | 作为前端工程师、帮我写组件 | React 19 + 现代前端技术栈 |
| `qa-engineer` | 作为测试工程师、帮我写测试 | 测试用例、自动化测试 |
| `code-reviewer` | 帮我审查代码 | 代码质量、安全审查 |

**注意**: 
- 提供两个后端 Skill，根据技术栈选择使用
- 前端开发前需要先进行设计（frontend-design → frontend-engineer）

---

## 使用方式（无需脚本）

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

**无需脚本** - 直接用 `skill(name: xxx)` 加载，用 `@` 引用文件。

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

请输出完整的 PRD 文档，保存到 docs/prd/mobile-login.md
```

**产出**: `docs/prd/mobile-login.md`

---

#### 2️⃣ 技术负责人 - 设计技术方案

```
skill(name: tech-lead)

请根据 PRD 设计技术方案。

## PRD
@docs/prd/mobile-login.md

## 现有技术栈
- 后端：Node.js + NestJS
- 数据库：MySQL + Redis
- 短信：阿里云 SMS

## 需要输出
1. 系统架构图（Mermaid C4Context）
2. 技术选型对比
3. API 设计（OpenAPI 3.0 YAML）
4. 工作量评估（天）
5. 风险评估

请输出完整的技术方案。
```

**产出**: `docs/tech/mobile-login.md`, `docs/api/auth.yaml`

---

#### 3️⃣ 后端开发 - 实现 API

**TypeScript 技术栈**:
```
skill(name: backend-typescript)

请实现手机号登录接口。

## API 契约
@docs/api/auth.yaml

## 技术方案
@docs/tech/mobile-login.md

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
@docs/api/auth.yaml

## 技术方案
@docs/tech/mobile-login.md

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

#### 3️⃣ 前端设计师 - 设计页面

**设计需求**:
```
skill(name: frontend-design)

请设计登录页面。

## PRD
@docs/prd/mobile-login.md

## API 契约
@docs/api/auth.yaml

## 设计要求
- 移动端优先
- 支持深色模式
- 无障碍访问 WCAG 2.1 AA
- 配色方案：品牌蓝色 (#1890ff)
- 性能要求：Lighthouse > 90
- 技术栈：React 19 + Vite 8 + Tailwind CSS 4 + Ant Design 6
```

**产出**: 
- `designs/mobile-login/design.md` - 设计文档
- `designs/mobile-login/components/` - 可复用组件代码
- `designs/mobile-login/review.md` - 设计评审报告

---

#### 4️⃣ 前端工程师 - 基于设计开发

```
skill(name: frontend-engineer)

请基于设计开发登录页面。

## UI 设计稿
@designs/mobile-login/design.md

## 设计组件代码
@designs/mobile-login/components/

## API 契约
@docs/api/auth.yaml

## 技术栈
- React 19（Server Components、Actions）
- TypeScript 5.x
- Vite 8
- TanStack Router
- Tailwind CSS 4
- Ant Design 6
- Bun workspace + Turborepo
- Biome 代码规范

## 功能
- 基于设计组件开发业务逻辑
- 集成 API（使用 TanStack Query）
- 路由（使用 TanStack Router）
- 响应式支持
- 单元测试（Vitest）

请输出完整组件代码。
```

**产出**: `src/pages/login/*.tsx`, `src/components/login/*.tsx`, `tests/login/*.test.ts`

---

#### 6️⃣ 测试工程师 - 编写测试

```
skill(name: qa-engineer)

请设计测试用例。

## PRD
@docs/prd/mobile-login.md

## API
@docs/api/auth.yaml

## 要求
- 功能测试（正常 + 异常流程）
- 边界条件测试
- 性能测试
- 安全测试

请输出测试用例表格和自动化测试代码。
```

**产出**: `tests/e2e/login.spec.ts`, 测试报告

---

#### 7️⃣ 代码审查

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
```

**产出**: Code Review 报告

---

## 配置到 AI 工具

### OpenCode（开箱即用）

Skills 已在 `.opencode/skills/` 目录，会自动发现：

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
2. **用@引用文件** - `@docs/api/auth.yaml`
3. **明确角色** - 每个步骤使用对应的 Skill
4. **检查质量** - 使用质量检查清单

### ❌ 不应该做的

1. **跳过 Skill** - 直接让 AI 生成
2. **不提供上下文** - 用@引用相关文档
3. **角色混乱** - 不要混用多个 Skill

---

## 下一步

- 📖 [README.md](README.md) - 完整方案
- 🛠️ [skills/README.md](skills/README.md) - Skills 详情
- 💡 [skills/*/examples/](skills/product-manager/examples/) - 示例

**开始使用！** 🚀

```bash
opencode
skill(name: product-manager)
```
