# 5 分钟快速上手

## 核心概念

本方案基于 **Skills（技能）** 实现 AI 协作编程。每个 Skill 是一个可重用的 AI 角色定义，包含：

- **角色定义** - AI 的经验和能力
- **输出规范** - 统一的输出格式
- **常用模板** - 典型场景的提示词
- **质量检查清单** - 验证输出质量

## 7 个核心 Skills

| Skill | 触发短语 | 用途 |
|-------|---------|------|
| `product-manager` | 作为产品经理、帮我写 PRD | 需求分析、PRD、用户故事 |
| `project-manager` | 作为项目经理、帮我排期 | 项目排期、风险评估 |
| `tech-lead` | 作为技术负责人、设计技术方案 | 架构设计、API 契约 |
| `backend-engineer` | 作为后端工程师、帮我写接口 | API 实现、单元测试 |
| `frontend-engineer` | 作为前端工程师、帮我写组件 | React 组件、页面开发 |
| `qa-engineer` | 作为测试工程师、帮我写测试 | 测试用例、自动化测试 |
| `code-reviewer` | 帮我审查代码 | 代码质量、安全审查 |

---

## 快速开始

### 方式 1：OpenCode（推荐）

```bash
# 1. 进入项目
cd /path/to/project

# 2. 启动 OpenCode
opencode

# 3. 加载 Skill
skill(name: backend-engineer)

# 4. 描述任务
请根据 API 契约实现登录接口
```

### 方式 2：Claude Desktop

```bash
# 1. 配置 Skill（首次使用）
cat skills/backend-engineer/SKILL.md >> ~/.claude/skills/backend-engineer.md

# 2. 启动 Claude
claude

# 3. 在对话中使用
我使用后端工程师 Skill，请帮我实现登录接口
```

### 方式 3：GitHub Copilot

```bash
# 1. 配置 Instructions
cat skills/backend-engineer/SKILL.md >> .github/copilot-instructions.md

# 2. 在 VS Code 中使用 Copilot Chat
# 输入：作为后端工程师，请实现登录接口
```

---

## 完整工作流示例

### 场景：手机号登录功能

#### 1️⃣ 产品经理 - 创建 PRD

**OpenCode:**
```
skill(name: product-manager)

请帮我创建手机号登录功能的 PRD。

## 背景
用户反馈登录流程太复杂，仅支持账号密码登录。

## 业务目标
- 提升登录转化率 15%
- 降低客服咨询量 30%
```

**Claude:**
```
我是一名产品经理，需要创建手机号登录功能的 PRD。

## 原始需求
用户反馈登录流程复杂，希望手机号 + 验证码登录。

## 业务目标
- 登录转化率：65% → 80%
- 客服咨询：100 → 70 次/天

请输出结构化 PRD 文档。
```

**产出**: `docs/prd/mobile-login.md`

---

#### 2️⃣ 技术负责人 - 设计技术方案

**OpenCode:**
```
skill(name: tech-lead)

请根据 PRD 设计技术方案。

## PRD
@docs/prd/mobile-login.md

## 技术栈
- 后端：Node.js + NestJS
- 数据库：MySQL + Redis
- 短信：阿里云 SMS
```

**Claude:**
```
我是一名技术负责人，请设计技术方案。

## PRD 摘要
- 功能：手机号 + 验证码登录
- 技术栈：Node.js, NestJS, MySQL, Redis

## 需要输出
1. 系统架构（Mermaid C4Context）
2. 技术选型对比
3. API 设计（OpenAPI 3.0）
4. 工作量评估
```

**产出**: `docs/tech/mobile-login.md`, `docs/api/auth.yaml`

---

#### 3️⃣ 后端工程师 - 实现 API

**OpenCode:**
```
skill(name: backend-engineer)

请实现手机号登录接口。

## API 契约
@docs/api/auth.yaml

## 技术方案
@docs/tech/mobile-login.md

## 任务
1. AuthController（sendCode, login）
2. AuthService（业务逻辑）
3. DTO（输入验证）
4. 单元测试
```

**Claude:**
```
我使用后端工程师 Skill，请实现登录接口。

## API 契约
POST /api/v1/auth/send-code
POST /api/v1/auth/login

## 技术栈
- TypeScript + NestJS
- TypeORM + MySQL
- Jest (测试)

请输出完整代码（Controller + Service + DTO + 测试）。
```

**产出**: `src/auth/*.ts`, `tests/auth/*.test.ts`

---

#### 4️⃣ 前端工程师 - 开发页面

**OpenCode:**
```
skill(name: frontend-engineer)

请开发登录页面。

## API 契约
@docs/api/auth.yaml

## 技术栈
- React 18 + TypeScript
- Tailwind CSS
- Zustand (状态管理)
```

**Claude:**
```
我使用前端工程师 Skill，请开发登录页面。

## 功能
- 手机号输入（格式化）
- 验证码获取（60 秒倒计时）
- 登录提交

## 技术栈
- React + TypeScript
- Tailwind CSS
```

**产出**: `src/pages/login/*.tsx`

---

#### 5️⃣ 测试工程师 - 编写测试

**OpenCode:**
```
skill(name: qa-engineer)

请设计测试用例。

## PRD
@docs/prd/mobile-login.md

## API
@docs/api/auth.yaml

## 要求
- 功能测试（正常 + 异常）
- 边界条件
- 性能测试
- 安全测试
```

**Claude:**
```
我使用测试工程师 Skill，请设计测试用例。

## 覆盖范围
1. 功能测试（P0/P1/P2）
2. 边界条件（手机号格式、验证码位数）
3. 异常流程（验证码错误、过期）
4. 性能测试（QPS、延迟）
5. 安全测试（SQL 注入、限流）
```

**产出**: `tests/e2e/login.spec.ts`, 测试报告

---

#### 6️⃣ 代码审查

**OpenCode:**
```
skill(name: code-reviewer)

请审查以下代码。

## PR
https://github.com/xxx/xxx/pull/123

## 审查维度
1. 代码质量
2. 架构设计
3. 错误处理
4. 安全性
5. 性能
6. 测试覆盖
```

**Claude:**
```
请使用代码审查 Skill 审查以下代码。

## 代码
{粘贴代码}

## 审查重点
- 错误处理
- 安全性
- 测试覆盖
```

**产出**: Code Review 报告

---

## 工具脚本

### context-pack.sh - 打包上下文

```bash
# 用法
./tools/context-pack.sh <任务类型> <功能名称>

# 示例
./tools/context-pack.sh backend 手机号登录
./tools/context-pack.sh frontend 登录页面
./tools/context-pack.sh qa 支付功能
```

### new-prd.sh - 创建 PRD

```bash
# 用法
./tools/new-prd.sh <需求名称> [选项]

# 选项
-p, --priority    优先级 (P0|P1|P2)
-a, --author      作者 (@username)

# 示例
./tools/new-prd.sh "手机号登录" -p P0
./tools/new-prd.sh "购物车优化" -a @zhangsan
```

### api-validate.sh - API 验证

```bash
# 用法
./tools/api-validate.sh <API 文件> [选项]

# 选项
-s, --strict    严格模式
-r, --report    输出详细报告

# 示例
./tools/api-validate.sh docs/api/auth.yaml -r
```

---

## 配置到 AI 工具

### OpenCode（开箱即用）

Skills 已在 `.opencode/skills/` 目录，OpenCode 会自动发现：

```bash
# 全局安装（所有项目可用）
cp -r skills/* ~/.config/opencode/skills/
```

### Claude Desktop

```bash
# 全局配置
mkdir -p ~/.claude/skills
cp skills/backend-engineer/SKILL.md ~/.claude/skills/backend-engineer.md

# 项目配置
mkdir -p .claude/skills
cp skills/backend-engineer/SKILL.md .claude/skills/
```

### GitHub Copilot

```bash
# 项目配置
mkdir -p .github
cat skills/backend-engineer/SKILL.md >> .github/copilot-instructions.md
```

### Cursor

```bash
# 添加到 .cursorrules
cat skills/backend-engineer/SKILL.md >> .cursorrules
```

---

## 质量检查

每个 Skill 都包含质量检查清单，使用时请验证：

### Product Manager

```
- [ ] 需求背景清晰，有数据支撑
- [ ] 用户故事完整
- [ ] 验收条件可量化
- [ ] 优先级明确
- [ ] 数据埋点完整
```

### Backend Engineer

```
- [ ] 代码清晰，命名准确
- [ ] 错误处理完善
- [ ] 日志记录充分
- [ ] 测试覆盖完整（> 80%）
- [ ] 符合 SOLID 原则
```

---

## 下一步

- 📖 [README.md](README.md) - 完整方案文档
- 🛠️ [skills/README.md](skills/README.md) - Skills 使用指南
- 📝 [docs/ai-tool-configs.md](docs/ai-tool-configs.md) - AI 工具配置
- 💡 [skills/*/examples/opencode.md](skills/product-manager/examples/opencode.md) - OpenCode 示例
- 💡 [skills/*/examples/claude.md](skills/product-manager/examples/claude.md) - Claude 示例

---

**开始你的第一个 AI 协作任务！** 🚀

```bash
# 选择你的角色
cd skills/
ls -1

# 开始使用
opencode
skill(name: <skill-name>)
```
