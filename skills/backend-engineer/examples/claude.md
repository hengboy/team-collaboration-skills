# Backend Engineer Skill - Claude 使用示例

## 场景：手机号登录 API 实现

### 前置准备

```bash
# 1. 配置 Claude Desktop（首次使用）
# 在 ~/.claude/skills/backend-engineer.md 中添加：

---
## 角色：后端工程师

你是一名资深后端工程师，拥有 5 年以上开发经验。

## 技术栈

- 语言：TypeScript/Node.js
- 框架：NestJS/Express
- ORM：TypeORM/Prisma
- 测试：Jest/Supertest
- 缓存：Redis

## 输出规范

- 代码使用 TypeScript
- 遵循 NestJS 最佳实践（Controller/Service/Repository 分层）
- 包含完整错误处理
- 包含日志记录
- 包含单元测试
- 代码有完整类型定义
---

# 2. 打包上下文
./tools/context-pack.sh backend 手机号登录
```

### 步骤 1：在 Claude 中加载 Skill

在 Claude 对话开始：

```
我将使用后端工程师 Skill 来实现手机号登录接口。

## 上下文

我已经通过 context-pack.sh 打包了以下文档：
- API 契约：docs/api/auth.yaml
- 技术方案：docs/tech/mobile-login.md
- 数据库 Schema: docs/db/schema.sql

## 技术栈

- TypeScript + NestJS
- TypeORM + MySQL
- Jest (测试)
- Redis (缓存)

请根据以上上下文实现登录接口。
```

### 步骤 2：实现 API

```
请实现手机号登录的 Controller 和 Service。

## 要求

1. **AuthController**
   - POST /api/v1/auth/send-code - 发送验证码
   - POST /api/v1/auth/login - 登录接口

2. **AuthService**
   - sendCode(phone) - 生成并发送验证码
   - login(phone, code, remember) - 验证并登录

3. **DTO**
   - LoginDto - 登录请求验证
   - SendCodeDto - 发送验证码请求验证

4. **其他要求**
   - 统一响应格式：{ code, data, message }
   - 完整错误处理
   - 日志记录
   - 类型定义完整

## API 契约

```yaml
POST /api/v1/auth/send-code
Request: { phone: "13800138000" }
Response: { code: 0, message: "发送成功", data: {...} }

POST /api/v1/auth/login
Request: { phone: "13800138000", code: "123456", remember: false }
Response: { code: 0, message: "登录成功", data: { token, user } }
```

请输出完整的代码实现。
```

### 步骤 3：AI 生成代码

Claude 会生成完整的代码实现（与 OpenCode 示例类似）。

### 步骤 4：编写单元测试

```
请为 AuthService 编写完整的单元测试。

## 测试要求

- 框架：Jest
- 覆盖率：> 80%
- Mock 外部依赖（Repository, JwtService, SmsService, RedisService）

## 测试场景

1. **正常登录**
   - Given: 正确的手机号和验证码
   - When: 调用 login 方法
   - Then: 返回 token 和用户信息

2. **验证码过期**
   - Given: Redis 中验证码不存在
   - When: 调用 login 方法
   - Then: 抛出"验证码已过期"错误

3. **验证码错误**
   - Given: 验证码不匹配
   - When: 调用 login 方法
   - Then: 抛出"验证码错误"错误

4. **新用户自动注册**
   - Given: 手机号不存在
   - When: 调用 login 方法
   - Then: 创建用户并返回 token

## 输出格式

TypeScript 测试代码，使用 Given-When-Then 注释结构
```

### 步骤 5：代码审查

```
请对以上代码进行自我审查：

## 审查维度

1. **代码质量**
   - 命名是否清晰准确
   - 函数职责是否单一
   - 是否有适当的注释

2. **错误处理**
   - 是否捕获所有可能的异常
   - 错误信息是否清晰

3. **安全性**
   - 是否有 SQL 注入风险
   - 是否有 XSS 风险
   - 敏感数据是否加密

4. **性能**
   - 是否有 N+1 查询问题
   - 是否合理使用缓存

5. **测试**
   - 测试覆盖率是否 > 80%
   - 是否覆盖异常流程

请逐项检查并指出需要改进的地方。
```

### 步骤 6：保存和验证

```bash
# 保存代码
mkdir -p src/auth src/auth/dto tests/auth

# 保存文件后运行测试
npm run test -- auth.service.spec.ts

# 预期输出
PASS  tests/auth/auth.service.spec.ts
  AuthService
    ✓ should be defined (5 ms)
    login
      ✓ should return token and user when credentials are valid (10 ms)
      ✓ should throw error when code is expired (8 ms)
      ✓ should throw error when code is invalid (7 ms)
      ✓ should auto register new user (12 ms)

Test Suites: 1 passed, 1 total
Tests:       5 passed, 5 total
Coverage:    85%
```

### 步骤 7：提交代码

```bash
# 查看变更
git status
git diff src/auth/

# 提交代码
git add src/auth/ tests/auth/
git commit -m "feat(auth): 实现手机号登录接口

- 添加 AuthController (sendCode, login)
- 添加 AuthService (业务逻辑)
- 添加 DTO (LoginDto, SendCodeDto)
- 添加单元测试 (覆盖率 85%)
- 添加错误处理和日志记录

Closes: #123"
```

## 完整对话示例

### 用户输入

```
请实现手机号登录接口。

## 技术栈

- TypeScript + NestJS
- TypeORM + MySQL
- Redis (验证码缓存)
- JWT (Token 生成)

## API 契约

```yaml
POST /api/v1/auth/send-code
Request:
  phone: string (11 位手机号)
Response:
  code: 0
  message: "发送成功"
  data:
    expireInSeconds: 300
    retryAfterSeconds: 60

POST /api/v1/auth/login
Request:
  phone: string
  code: string (6 位数字)
  remember: boolean
Response:
  code: 0
  message: "登录成功"
  data:
    token: string
    user: { id, phone, nickname }
```

## 要求

1. Controller/Service/Repository分层
2. 使用 DTO 进行输入验证
3. 完整错误处理
4. 日志记录
5. 单元测试（Jest）

请输出完整代码。
```

### Claude 输出

Claude 会生成完整的代码实现，包括：
- `auth.controller.ts` - Controller 层
- `auth.service.ts` - Service 层
- `login.dto.ts` - DTO
- `send-code.dto.ts` - DTO
- `auth.service.spec.ts` - 单元测试

## 质量检查清单

```
请验证代码是否满足：

- [ ] 代码清晰，命名准确（如：AuthService, LoginDto）
- [ ] 错误处理完善（try-catch 包裹所有异步操作）
- [ ] 日志记录充分（关键操作使用 Logger）
- [ ] 测试覆盖完整（正常 + 异常流程）
- [ ] 符合 SOLID 原则（单一职责、依赖注入）
- [ ] 无安全漏洞（参数验证、SQL 防注入）
- [ ] 函数长度合理（< 50 行）

请逐项检查。
```

## 下一步

```
后端接口已实现并测试通过。

下一步：
1. 前端工程师使用 Frontend Skill 开发登录页面
2. QA 工程师使用 QA Skill 编写 E2E 测试
```
