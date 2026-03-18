# 研发过程"需求流转"深度分析报告

**版本**: v1.0.0  
**更新日期**: 2024-01-18  
**分析对象**: AI 协作团队 Skills 需求流转链路

---

## 一、完整流转链路图

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        需求流转全景图                                     │
└─────────────────────────────────────────────────────────────────────────┘

原始需求 → [Product Manager] → PRD → [Tech Lead] → 技术方案 + API 契约 
                                  ↓
                        ┌─────────┴─────────┐
                        ↓                   ↓
                  [Backend]           [Frontend]
                  后端代码               前端代码
                        ↓                   ↓
                        └─────────┬─────────┘
                                  ↓
                            [QA] → 测试用例 + 测试报告
                                  ↓
                            [Code Review] → 审查报告 → 上线
```

### 流转阶段说明

| 阶段 | Skill | 输入 | 输出 | 输出文件 |
|------|-------|------|------|---------|
| 1 | Product Manager | 原始需求 | PRD 文档 | `docs/prd/*.md` |
| 2 | Tech Lead | PRD | 技术方案 + API 契约 | `docs/tech/*.md` + `docs/api/*.yaml` |
| 3 | Backend | API 契约 + 技术方案 | 后端代码 | `src/**/*.ts` |
| 3 | Frontend | API 契约 + 技术方案 | 前端代码 | `src/**/*.tsx` |
| 4 | QA | PRD + API + 源代码 | 测试用例 + 测试报告 | `tests/**/*.test.ts` |
| 5 | Code Review | 源代码 + 技术方案 | 审查报告 | Code Review 报告 |

---

## 二、各阶段流转详细分析

### 阶段 1: Product Manager → Tech Lead

#### 流转验证

| 项目 | 内容 |
|------|------|
| **输出 Skill** | `product-manager` |
| **输出文件** | `docs/prd/{feature-name}.md` |
| **输出内容** | PRD 文档（用户故事、功能需求、验收条件、数据埋点） |
| **输入 Skill** | `tech-lead` |
| **输入要求** | `@docs/prd/{feature-name}.md` |
| **匹配度** | ✅ **完全匹配** |

#### 代码验证

**Product Manager 输出规范**（SKILL.md line 17-21）:
```markdown
## 输出规范

- 始终使用 Markdown 格式
- 包含 YAML frontmatter（id, title, product-manager, create-date, priority, status）
- 用户故事用表格呈现
- 验收条件用复选框列表
- 业务目标尽量量化
```

**Tech Lead 输入要求**（SKILL.md line 33-35）:
```markdown
## PRD 文档

@docs/prd/{feature-name}.md
```

#### 结论

✅ **完全匹配** - Product 输出的 PRD 文档格式完全符合 Tech Lead 的输入要求

**PRD 文档示例结构**:
```markdown
---
id: PRD-2024-001
title: 手机号登录功能
product-manager: @zhangsan
create-date: 2024-01-15
priority: P0
status: draft
---

# 需求背景
# 用户故事
# 功能需求
# 验收条件
# 数据埋点
```

---

### 阶段 2: Tech Lead → Backend/Frontend

#### 流转验证

| 项目 | 内容 |
|------|------|
| **输出 Skill** | `tech-lead` |
| **输出文件** | `docs/tech/{feature-name}.md` + `docs/api/{feature-name}.yaml` |
| **输出内容** | 技术方案（架构图、技术选型）+ API 契约（OpenAPI 3.0） |
| **输入 Skill** | `backend-engineer` / `frontend-engineer` |
| **输入要求** | `@docs/api/{feature-name}.yaml` + `@docs/tech/{feature-name}.md` |
| **匹配度** | ✅ **完全匹配** |

#### 代码验证

**Tech Lead 输出规范**（SKILL.md line 19-24）:
```markdown
## 输出规范

- 始终使用 Markdown 格式
- 包含 YAML frontmatter
- 架构图用 Mermaid（C4Context/C4Container/C4Component）
- 技术选型用对比表格（至少 3 个维度）
- API 使用 OpenAPI 3.0 YAML 格式
- 工作量评估到天，标注依赖和 buffer（10-20%）
```

**Backend 输入要求**（SKILL.md line 40-46）:
```markdown
## API 契约

@docs/api/{feature-name}.yaml

## 技术方案

@docs/tech/{feature-name}.md
```

**Frontend 输入要求**（SKILL.md line 46-48）:
```markdown
## API 契约

@docs/api/{feature-name}.yaml
```

#### 结论

✅ **完全匹配** - Tech Lead 输出的 API 契约和技术方案完全符合后端/前端的输入要求

**API 契约示例结构**:
```yaml
openapi: 3.0.0
info:
  title: 用户认证 API
  version: 1.0.0
paths:
  /api/v1/auth/login:
    post:
      summary: 用户登录
      operationId: loginUser
      tags: [Auth]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/LoginRequest'
```

---

### 阶段 3: Backend/Frontend → QA

#### 流转验证

| 项目 | 内容 |
|------|------|
| **输出 Skill** | `backend-engineer` + `frontend-engineer` |
| **输出文件** | `src/**/*.ts` + `tests/unit/**/*.test.ts` |
| **输出内容** | 源代码 + 单元测试 |
| **输入 Skill** | `qa-engineer` |
| **输入要求** | `@docs/prd/{feature-name}.md` + `@docs/api/{feature-name}.yaml` + `@src/{module}/*.ts` |
| **匹配度** | ⚠️ **部分匹配** |

#### 代码验证

**Backend 输出规范**（SKILL.md line 26-31）:
```markdown
## 输出规范

- 代码使用 TypeScript
- 遵循 NestJS 最佳实践（Controller/Service/Repository 分层）
- 包含完整错误处理
- 包含日志记录
- 包含单元测试
- 代码有完整类型定义
```

**QA 输入要求**（SKILL.md line 41-47）:
```markdown
## PRD 文档

@docs/prd/{feature-name}.md

## API 契约

@docs/api/{feature-name}.yaml
```

**QA 输入要求**（SKILL.md line 163-168）:
```markdown
## 测试代码

@tests/{module}.test.ts

## 源代码

@src/{module}/*.ts
```

#### 结论

- ✅ QA 可以直接引用 PRD 和 API 契约（来自前两阶段）
- ✅ QA 可以访问 Backend/Frontend 生成的源代码
- ⚠️ **需要确保代码提交到项目目录**，QA 才能通过 `@` 引用

**建议**:
1. 开发完成后及时提交代码到 Git
2. 确保测试代码也提交到 `tests/` 目录
3. QA 使用 `@` 引用时文件必须存在

---

### 阶段 4: QA → Code Review

#### 流转验证

| 项目 | 内容 |
|------|------|
| **输出 Skill** | `qa-engineer` |
| **输出文件** | `tests/**/*.test.ts` + `docs/tests/{feature-name}-report.md` |
| **输出内容** | 测试用例 + 自动化测试代码 + 测试报告 |
| **输入 Skill** | `code-reviewer` |
| **输入要求** | `{粘贴代码变更}` + `@docs/tech/{feature-name}.md` + `@tests/{module}.test.ts` |
| **匹配度** | ✅ **完全匹配** |

#### 代码验证

**QA 输出规范**（SKILL.md line 27-32）:
```markdown
## 输出规范

- 测试用例用 Markdown 表格（用例 ID、优先级、前置条件、步骤、预期结果）
- 自动化测试使用 TypeScript
- 测试独立，无依赖
- 使用 Given-When-Then 结构
- 覆盖正常流程和异常流程
- 标注优先级（P0/P1/P2）
```

**Code Reviewer 输入要求**（SKILL.md line 163-168）:
```markdown
## 测试代码

@tests/{module}.test.ts

## 源代码

@src/{module}/*.ts

## 技术方案

@docs/tech/{feature-name}.md
```

#### 结论

✅ **完全匹配** - QA 生成的测试代码和测试报告完全符合 Code Reviewer 的输入要求

**测试报告示例结构**:
```markdown
# 测试报告：手机号登录功能

## 测试概述
- 测试周期：2024-01-22 ~ 2024-01-25
- 测试负责人：@zhoushiu

## 测试结果汇总
| 类型 | 总数 | 通过 | 失败 | 通过率 |
|------|------|------|------|--------|
| 功能测试 | 25 | 25 | 0 | 100% |

## 发布建议
✅ **建议发布**
```

---

## 三、文档目录结构建议

为确保流转顺畅，建议使用以下标准目录结构：

```
project/
├── docs/
│   ├── prd/                           # Product 输出
│   │   ├── mobile-login.md
│   │   └── payment-feature.md
│   ├── tech/                          # Tech Lead 输出
│   │   ├── mobile-login.md
│   │   └── payment-feature.md
│   ├── api/                           # Tech Lead 输出
│   │   ├── auth.yaml
│   │   └── payment.yaml
│   ├── tests/                         # QA 输出
│   │   ├── mobile-login-report.md
│   │   └── payment-report.md
│   └── bugs/                          # Bug 报告
│       └── bug-001.md
├── src/
│   ├── auth/                          # Backend 输出
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   └── dto/
│   │       ├── login.dto.ts
│   │       └── send-code.dto.ts
│   ├── users/
│   │   └── users.controller.ts
│   └── pages/
│       └── login/                     # Frontend 输出
│           ├── LoginPage.tsx
│           └── LoginComponents.tsx
└── tests/
    ├── unit/                          # Backend 单元测试
    │   ├── auth.service.test.ts
    │   └── users.service.test.ts
    ├── e2e/                           # QA E2E 测试
    │   ├── login.spec.ts
    │   └── payment.spec.ts
    └── integration/                   # 集成测试
        └── auth-flow.spec.ts
```

### 文件命名规范

| 类型 | 命名规则 | 示例 |
|------|---------|------|
| PRD | `docs/prd/{feature-name}.md` | `docs/prd/mobile-login.md` |
| 技术方案 | `docs/tech/{feature-name}.md` | `docs/tech/mobile-login.md` |
| API 契约 | `docs/api/{feature-name}.yaml` | `docs/api/auth.yaml` |
| 后端代码 | `src/{module}/{name}.ts` | `src/auth/auth.service.ts` |
| 前端代码 | `src/pages/{name}/{name}.tsx` | `src/pages/login/LoginPage.tsx` |
| 测试用例 | `tests/{type}/{feature}.test.ts` | `tests/e2e/login.spec.ts` |

---

## 四、关键发现

### ✅ 流转良好的环节

| 环节 | 匹配度 | 原因 |
|------|--------|------|
| Product → Tech Lead | 100% | PRD 文档路径明确，格式标准化 |
| Tech Lead → Backend | 100% | API 契约使用 OpenAPI 标准 |
| Tech Lead → Frontend | 100% | API 契约 + 技术方案双输入 |
| QA → Code Review | 100% | 测试代码 + 测试报告完整 |

### ⚠️ 需要注意的环节

| 环节 | 问题 | 建议 |
|------|------|------|
| Backend/Frontend → QA | QA 需要访问源代码 | 确保代码提交到项目目录 |
| 所有阶段 | 依赖 `@` 引用机制 | OpenCode 用户无障碍，Claude 用户需手动粘贴 |
| Code Review | 需要完整的代码变更 | 使用 Git PR/MR 提供变更链接 |

---

## 五、AI 工具使用建议

### OpenCode 用户（推荐）

**优势**:
- ✅ 自动读取 `@` 引用的文件
- ✅ skill 工具自动加载项目文件
- ✅ 无需手动打包上下文

**使用方式**:
```bash
opencode
skill(name: backend-engineer)

请实现登录接口。

## API 契约
@docs/api/auth.yaml

## 技术方案
@docs/tech/mobile-login.md
```

### Claude 用户

**注意**:
- ⚠️ 不支持 `@` 引用
- ⚠️ 需要手动粘贴文件内容

**使用方式**:
```bash
claude
```

在对话中：
```
我使用 backend-engineer Skill。

请实现登录接口。

## API 契约
{手动打开 docs/api/auth.yaml，复制内容粘贴}

## 技术方案
{手动打开 docs/tech/mobile-login.md，复制内容粘贴}
```

### GitHub Copilot 用户

**使用方式**:
在 VS Code Copilot Chat 中：
```
作为后端工程师，请实现登录接口。

## API 契约
@docs/api/auth.yaml
```

---

## 六、质量检查清单

### 阶段 1: Product → Tech Lead

- [ ] PRD 文档包含 YAML frontmatter
- [ ] 用户故事完整（至少 5 个）
- [ ] 验收条件可量化、可测试
- [ ] 优先级明确（P0/P1/P2）
- [ ] 数据埋点完整

### 阶段 2: Tech Lead → Backend/Frontend

- [ ] 技术方案包含架构图（Mermaid）
- [ ] API 契约使用 OpenAPI 3.0 YAML
- [ ] 技术选型有对比和理由
- [ ] 工作量评估包含 10-20% buffer
- [ ] 风险评估完整

### 阶段 3: Backend/Frontend → QA

- [ ] 代码已提交到项目目录
- [ ] 单元测试覆盖率 > 80%
- [ ] 代码符合 Linter 规范
- [ ] 错误处理完善

### 阶段 4: QA → Code Review

- [ ] 测试用例覆盖正常和异常流程
- [ ] 自动化测试代码可执行
- [ ] 测试报告包含发布建议
- [ ] P0 用例通过率 100%

### 阶段 5: Code Review → 上线

- [ ] Must Fix 问题已全部修复
- [ ] 代码审查通过
- [ ] 所有测试通过
- [ ] 性能测试达标

---

## 七、风险评估与缓解

| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|---------|
| PRD 不清晰 | Tech Lead 理解偏差 | 中 | Product 使用检查清单自验证 |
| API 契约变更 | 前后端不一致 | 中 | API 变更需同步通知双方 |
| 代码未及时提交 | QA 无法访问 | 高 | 建立代码提交流程规范 |
| Claude 用户效率低 | 手动粘贴耗时 | 高 | 推荐使用 OpenCode |

---

## 八、总结

### 整体评估：✅ **流转畅通**

1. **Product → Tech Lead**: 完美衔接，PRD 文档作为中间产物清晰明确
2. **Tech Lead → Backend/Frontend**: API 契约作为标准接口，前后端并行开发无障碍
3. **Backend/Frontend → QA**: 源代码 + API 契约 + PRD 三维度输入，测试覆盖完整
4. **QA → Code Review**: 测试代码 + 测试报告，审查维度完整

### 关键成功因素

1. ✅ **中间产物标准化** - PRD、API 契约、技术方案都有明确格式
2. ✅ **文件路径约定** - `docs/prd/`, `docs/api/`, `src/` 等路径清晰
3. ✅ **@引用机制** - OpenCode 自动读取引用文件，无需手动打包

### 实施建议

1. **使用 OpenCode** - 充分利用 `@` 引用机制，流转最顺畅
2. **及时提交代码** - 每个阶段完成后及时将产出物保存到项目目录
3. **统一目录结构** - 遵循建议的目录结构，确保文件路径一致
4. **定期回顾** - 每个迭代结束后回顾流转过程，持续改进

---

## 附录

### A. Skills 列表

| Skill | 文件路径 |
|-------|---------|
| product-manager | `skills/product-manager/SKILL.md` |
| project-manager | `skills/project-manager/SKILL.md` |
| tech-lead | `skills/tech-lead/SKILL.md` |
| backend-engineer | `skills/backend-engineer/SKILL.md` |
| frontend-engineer | `skills/frontend-engineer/SKILL.md` |
| qa-engineer | `skills/qa-engineer/SKILL.md` |
| code-reviewer | `skills/code-reviewer/SKILL.md` |

### B. 相关文档

- [README.md](README.md) - 完整方案文档
- [QUICKSTART.md](QUICKSTART.md) - 5 分钟快速上手
- [skills/README.md](skills/README.md) - Skills 使用指南

### C. 版本历史

| 版本 | 日期 | 变更内容 |
|------|------|---------|
| v1.0.0 | 2024-01-18 | 初始版本 |
