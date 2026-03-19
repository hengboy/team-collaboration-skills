# 研发过程"需求流转"深度分析报告

**更新日期**: 2026-03-19  
**分析对象**: AI 协作团队 Skills 需求流转链路（含 Master Coordinator、frontend-design）
**版本**: v7.0.0 - 混合流程 + 联合评审

---

## 一、完整流转链路图

### 标准流程（带联合评审）

```
                    原始需求
                       ↓
              [Product Manager]
                   ↓ PRD
            ┌──────┴──────┐
            ↓             ↓
   [Project Manager]  [Master Coordinator]
      ↓ 项目计划      ↓ 组织并行工作
            │      ┌───┴───┐
            │      ↓       ↓
            │  Frontend-Design  Tech Lead
            │  (设计方案)      (技术方案)
            │      ↓       ↓
            │      └───┬───┘
            │       联合评审
            │    (最多 5 轮)
            ↓             ↓
            └──────┬──────┘
                   ↓
           [Frontend]  [Backend]
               并行开发
                   ↓
            ┌──────┴──────┐
            ↓             ↓
       单元测试      [QA] → 测试用例 + 测试报告
                        ↓
                [Code Review] → 审查报告 → 上线
```

### 流转阶段说明

| 阶段 | Skill | 输入 | 输出 | 输出文件 | 依赖 |
|------|-------|------|------|---------|------|
| 1 | Product Manager | 原始需求 | PRD 文档 | `.collaboration/features/*/prd.md` | 无 |
| 2 | Project Manager | PRD | 项目计划 | `.collaboration/features/*/plan.md` | Product Manager |
| 2 | Tech Lead | PRD | 技术方案 + API 契约 | `.collaboration/features/*/{tech.md,api.yaml}` | Product Manager |
| 2 | Frontend-Design | PRD | 设计方案 + 组件源码 | `.collaboration/features/*/{design.md,design-components.md}` | Product Manager |
| 3 | Master Coordinator | - | 组织联合评审 | `.collaboration/features/*/review.md` | Frontend-Design + Tech Lead |
| 3 | 联合评审 | 设计方案 + 技术方案 | 评审决议 | `.collaboration/features/*/review.md` | 最多 5 轮 |
| 4 | Backend | API 契约 + 技术方案 | 后端代码 | `src/**/*.ts` | 评审通过 |
| 4 | Frontend | 设计方案 + 组件源码 + API | 前端代码 | `src/**/*.tsx` | 评审通过 |
| 5 | QA | PRD + API + 源代码 | 测试用例 + 测试报告 | `tests/**/*.test.ts` | Backend + Frontend |
| 6 | Code Review | 源代码 + 技术方案 | 审查报告 | Code Review 报告 | QA |

**关键说明**:
- **阶段 2 并行**: Project Manager、Tech Lead、Frontend-Design 三者并行工作，都依赖 Product Manager 的 PRD
- **阶段 3 联合评审**: Master Coordinator 组织，自动检测 4 个维度冲突，最多 5 轮修改
- **阶段 4 汇合**: Frontend 和 Backend 等待联合评审通过后开始开发
- **Project Manager** → 输出项目计划（排期、资源分配、风险评估）
- **Tech Lead** → 输出技术方案和 API 契约（架构设计、技术选型）
- **Frontend-Design** → 输出设计方案和组件设计源码（UI/UX 设计、组件接口定义）
- **Master Coordinator** → 组织并行工作、联合评审、冲突检测

### 新增：联合评审机制

**评审触发**: 用户输入"开始评审"或"开始联合评审"

**冲突检测维度**（4 个）:
1. **技术可行性** - 设计需求 vs 技术约束
2. **API 匹配度** - 设计交互 vs API 接口
3. **性能目标** - 设计效果 vs 性能指标
4. **时间线** - 设计复杂度 vs 项目排期

**评审轮次**: 最多 5 轮

**评审结果**:
- ✅ **通过** - 进入开发阶段
- ⚠️ **修改设计** - Frontend-Design 修改设计方案
- ⚠️ **修改技术** - Tech Lead 修改技术方案
- ⚠️ **两者都改** - 双方分别修改

**评审记录**: `.collaboration/features/{feature-name}/review.md`

---

## 新增：Master Coordinator 角色

### 职责

1. 组织 Frontend-Design 和 Tech Lead 并行工作
2. 自动检测 4 个维度冲突
3. 组织联合评审会议（最多 5 轮）
4. 转发 Subagent 间消息
5. 记录评审过程到 review.md
6. 确保 feature-name 一致性

### 工作流

```bash
skill(name: master-coordinator)

请组织 {feature-name} 的并行设计和技术方案。

## PRD
@.collaboration/features/{feature-name}/prd.md
```

**执行流程**:
1. 从用户引用的 PRD 路径提取 `feature-name`（如 `mobile-login`）
2. 启动 Frontend-Design → `design.md` + `design-components.md`
3. 启动 Tech Lead → `tech.md` + `api.yaml`
4. 等待两者完成
5. 自动检测 4 个维度冲突
6. 等待用户输入"开始评审"
7. 组织联合评审（最多 5 轮）
8. 评审通过后进入开发阶段

**注意**：
- `feature-name` **不是由 Master Coordinator 确认**
- `feature-name` 由 **Product Manager 在创建 PRD 时确定**
- Master Coordinator 在评审主链路中负责**验证和确保一致性**
- 当前后端在独立仓库进入实现阶段时，实现 skill 仍需继续校验 `feature-name`：优先从输入路径提取，取不到再从文档 frontmatter 的 `feature:` 字段提取

**feature-name 流转链路**：
```
Product Manager → 创建 .collaboration/features/{feature-name}/prd.md
                ↓
Master Coordinator → 从 PRD 路径提取 {feature-name}
                ↓
Frontend-Design / Tech Lead → 输出到同一目录
                ↓
Frontend / Backend → 在独立仓库从输入路径或 frontmatter 继续校验 {feature-name}
```

---

## 二、各阶段流转详细分析

### 阶段 1: Product Manager → Project Manager / Tech Lead / Frontend-Design

**Product Manager** 完成 PRD 分析后，流程分为三条并行线路：
- **Project Manager** → 项目计划（排期、资源分配）
- **Tech Lead** → 技术方案（架构设计、API 契约）
- **Frontend-Design** → UI/UX 设计 + 组件设计源码（并行工作）

三者**并行工作**，互不依赖，都只需要 PRD 作为输入。

---

### 阶段 2 并行：Project Manager / Tech Lead / Frontend-Design

**Product Manager** 完成 PRD 分析后，流程分为三条并行线路：
- **Project Manager** → 项目计划（排期、资源分配、风险评估）
- **Tech Lead** → 技术方案（架构设计、API 契约）
- **Frontend-Design** → UI/UX 设计 + 组件设计源码

三者**并行工作**，互不依赖，都只需要 PRD 作为输入。

---

### 阶段 3 联合评审：Master Coordinator

**Frontend-Design** 和 **Tech Lead** 都完成后，由 **Master Coordinator** 组织联合评审。

**评审流程**:
1. 等待 Frontend-Design 和 Tech Lead 完成
2. 自动检测 4 个维度冲突
3. 等待用户输入"开始评审"
4. 输出评审界面
5. 根据用户决策转发修改请求
6. 最多 5 轮修改
7. 评审通过后进入开发阶段

**冲突检测**:
- 技术可行性：设计需求 vs 技术约束
- API 匹配度：设计交互 vs API 接口
- 性能目标：设计效果 vs 性能指标
- 时间线：设计复杂度 vs 项目排期

#### 流转验证

| 项目 | 内容 |
|------|------|
| **输出 Skill** | `project-manager` |
| **输出文件** | `.collaboration/features/{feature-name}/plan.md` |
| **输出内容** | 项目计划（任务拆解、排期、风险评估、资源分配） |
| **输入 Skill** | `backend-typescript` / `backend-springboot` / `frontend` / `qa-engineer` |
| **输入要求** | `@.collaboration/features/{feature-name}/plan.md` |
| **匹配度** | ✅ **完全匹配** |

#### 代码验证

**Project Manager 输出规范**:
```markdown
## 输出规范

- 始终使用 Markdown 格式
- 包含 YAML frontmatter
- 排期用甘特图（Mermaid）或表格
- 风险用矩阵展示
- 任务拆解到 0.5 天粒度
```

**开发团队输入要求**:
```markdown
## 项目计划
@.collaboration/features/{feature-name}/plan.md
```

#### 结论

✅ **完全匹配** - Project Manager 输出的项目计划为所有开发阶段提供排期和任务分配

**项目计划示例结构**:
```markdown
---
id: PROJ-2024-001
title: 手机号登录功能项目计划
project-manager: @team
status: draft
---

# 项目概述

## 团队资源
| 角色 | 人数 | 可用时间 |
|------|------|----------|
| 后端 | 2 | 100% |
| 前端 | 2 | 100% |
| 测试 | 1 | 100% |

## 任务拆解
| 任务 | 负责人 | 估时 | 依赖 |
|------|--------|------|------|
| PRD 完善 | @team | 1 天 | 无 |
| 技术方案 | @team | 1 天 | PRD |
| 后端开发 | @backend | 2 天 | 技术方案 |
| 前端设计 | @designer | 1 天 | PRD |
| 前端开发 | @frontend | 2 天 | 设计稿 |
| 测试 | @qa | 1 天 | 开发完成 |

## 甘特图
```mermaid
gantt
    title 项目计划
    dateFormat  YYYY-MM-DD
    section 需求
    PRD 完善 :a1, 2026-03-18, 1d
    section 技术
    技术方案 :a2, after a1, 1d
```
```

---

### 阶段 1: Product Manager → Tech Lead / Project Manager

#### 流转验证

| 项目 | 内容 |
|------|------|
| **输出 Skill** | `product-manager` |
| **输出文件** | `.collaboration/features/{feature-name}/prd.md` |
| **输出内容** | PRD 文档（用户故事、功能需求、验收条件、数据埋点） |
| **输入 Skill** | `tech-lead` |
| **输入要求** | `@.collaboration/features/{feature-name}/prd.md` |
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

@.collaboration/features/{feature-name}/prd.md
```

#### 结论

✅ **完全匹配** - Product 输出的 PRD 文档格式完全符合 Tech Lead 的输入要求

**PRD 文档示例结构**:
```markdown
---
id: PRD-2024-001
title: 手机号登录功能
product-manager: @team
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
| **输出文件** | `.collaboration/features/{feature-name}/tech.md` + `.collaboration/features/{feature-name}/api.yaml` |
| **输出内容** | 技术方案（架构图、技术选型）+ API 契约（OpenAPI 3.0） |
| **输入 Skill** | `backend-typescript` / `frontend` |
| **输入要求** | `@.collaboration/features/{feature-name}/api.yaml` + `@.collaboration/features/{feature-name}/tech.md` |
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

@.collaboration/features/{feature-name}/api.yaml

## 技术方案

@.collaboration/features/{feature-name}/tech.md
```

**独立仓库实现规则**:
- 先从 `@.collaboration/features/{feature-name}/...` 路径提取 `feature-name`
- 若只有文档内容没有路径，则从 frontmatter 的 `feature:` 字段提取
- 若两者都缺失，或值不一致，则停止实现并要求用户补充

**Frontend 输入要求**（SKILL.md line 46-48）:
```markdown
## API 契约

@.collaboration/features/{feature-name}/api.yaml
```

**独立仓库实现规则**:
- 先从 `@.collaboration/features/{feature-name}/...` 路径提取 `feature-name`
- 若只有文档内容没有路径，则从 frontmatter 的 `feature:` 字段提取
- 若两者都缺失，或值不一致，则停止实现并要求用户补充

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
| **输出 Skill** | `backend-typescript` + `frontend` |
| **输出文件** | `src/**/*.ts` + `tests/unit/**/*.test.ts` |
| **输出内容** | 源代码 + 单元测试 |
| **输入 Skill** | `qa-engineer` |
| **输入要求** | `@.collaboration/features/{feature-name}/prd.md` + `@.collaboration/features/{feature-name}/api.yaml` + `@src/{module}/*.ts` |
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

@.collaboration/features/{feature-name}/prd.md

## API 契约

@.collaboration/features/{feature-name}/api.yaml
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

### 阶段 4 汇合：Frontend / Backend

**联合评审通过后**，流程分为两条并行线路：
- **Backend** → 后端代码实现（依赖 API 契约 + 技术方案）
- **Frontend** → 前端代码实现（依赖设计方案 + 组件设计源码 + API 契约）

两者**并行工作**，互不依赖，都只需要联合评审通过的输出即可开始。

---

### 阶段 5: QA → Code Review

#### 流转验证

| 项目 | 内容 |
|------|------|
| **输出 Skill** | `qa-engineer` |
| **输出文件** | `tests/**/*.test.ts` + `.collaboration/features/{feature-name}/test-report.md` |
| **输出内容** | 测试用例 + 自动化测试代码 + 测试报告 |
| **输入 Skill** | `code-reviewer` |
| **输入要求** | `{粘贴代码变更}` + `@.collaboration/features/{feature-name}/tech.md` + `@tests/{module}.test.ts` |
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

@.collaboration/features/{feature-name}/tech.md
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
├── .collaboration/
│   ├── features/
│   │   ├── mobile-login/
│   │   │   ├── prd.md                  # Product Manager 输出
│   │   │   ├── plan.md                 # Project Manager 输出
│   │   │   ├── design.md               # Frontend-Design 输出
│   │   │   ├── design-components.md    # Frontend-Design 输出（组件源码）
│   │   │   ├── tech.md                 # Tech Lead 输出
│   │   │   ├── api.yaml                # Tech Lead 输出
│   │   │   └── review.md               # Master Coordinator 输出（评审记录）
│   │   └── payment-feature/
│   │       ├── prd.md
│   │       ├── design.md
│   │       ├── design-components.md
│   │       ├── tech.md
│   │       ├── api.yaml
│   │       └── review.md
│   └── shared/
│       ├── coding-standards.md
│       └── db/
│           └── schema.sql
├── docs/                              # 说明文档
│   ├── ai-tool-configs.md
│   └── skills-vs-subagents.md
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
| PRD | `.collaboration/features/{feature-name}/prd.md` | `.collaboration/features/mobile-login/prd.md` |
| 技术方案 | `.collaboration/features/{feature-name}/tech.md` | `.collaboration/features/mobile-login/tech.md` |
| API 契约 | `.collaboration/features/{feature-name}/api.yaml` | `.collaboration/features/mobile-login/api.yaml` |
| 设计方案 | `.collaboration/features/{feature-name}/design.md` | `.collaboration/features/mobile-login/design.md` |
| 组件源码 | `.collaboration/features/{feature-name}/design-components.md` | `.collaboration/features/mobile-login/design-components.md` |
| 评审记录 | `.collaboration/features/{feature-name}/review.md` | `.collaboration/features/mobile-login/review.md` |
| 后端代码 | `src/{module}/{name}.ts` | `src/auth/auth.service.ts` |
| 前端代码 | `src/pages/{name}/{name}.tsx` | `src/pages/login/LoginPage.tsx` |
| 测试用例 | `tests/{type}/{feature}.test.ts` | `tests/e2e/login.spec.ts` |

**注意**：所有 `feature-name` 必须保持一致。

---

## 四、关键发现

### ✅ 流转良好的环节

| 环节 | 匹配度 | 原因 |
|------|--------|------|
| Product → Tech Lead / Frontend-Design | 100% | PRD 文档路径明确，格式标准化 |
| Frontend-Design + Tech Lead → 联合评审 | 100% | 两者输出路径一致，便于评审 |
| 联合评审 → Backend / Frontend | 100% | 评审通过后双方开始开发 |
| QA → Code Review | 100% | 测试代码 + 测试报告完整 |

### ⚠️ 需要注意的环节

| 环节 | 问题 | 建议 |
|------|------|------|
| 联合评审 | 可能超过 5 轮 | 第 5 轮强制决议（通过或降级通过） |
| feature-name 一致性 | 可能不一致 | Master Coordinator 自动检查和修正 |
| 冲突检测 | 需要准确识别 | 4 个维度检测规则需要持续优化 |
| Subagent 间通信 | 需要中转 | 通过 Master Coordinator 转发消息 |

---

## 新增：联合评审机制详细分析

### 评审触发条件

- **触发词**: "开始评审"、"开始联合评审"
- **前提条件**: Frontend-Design 和 Tech Lead 都已完成
- **输出文件**: `design.md`, `design-components.md`, `tech.md`, `api.yaml`

### 冲突检测规则

| 维度 | 检测内容 | 检测方法 |
|------|---------|---------|
| 技术可行性 | 设计需求 vs 技术约束 | 提取设计技术需求，检查技术方案是否包含 |
| API 匹配度 | 设计交互 vs API 接口 | 提取设计交互流程，检查 API 端点是否完整 |
| 性能目标 | 设计效果 vs 性能指标 | 评估设计复杂度，对比性能要求 |
| 时间线 | 设计复杂度 vs 项目排期 | 评估组件数量和页面数量，对比排期 |

### 评审轮次管理

- **当前轮次**: 1-5
- **最大轮次**: 5
- **达到上限**: 强制决议（通过或降级通过）
- **降级通过**: 遗留问题记录到 `review.md`

### 评审结果

| 结果 | 操作 |
|------|------|
| ✅ 通过 | 进入开发阶段 |
| ⚠️ 修改设计 | Frontend-Design 修改 `design.md` |
| ⚠️ 修改技术 | Tech Lead 修改 `tech.md` + `api.yaml` |
| ⚠️ 两者都改 | 双方分别修改 |

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
skill(name: backend-typescript)

请实现登录接口。

## API 契约
@.collaboration/features/mobile-login/api.yaml

## 技术方案
@.collaboration/features/mobile-login/tech.md
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
我使用 backend-typescript Skill。

请实现登录接口。

## API 契约
{手动打开 .collaboration/features/mobile-login/api.yaml，复制内容粘贴}

## 技术方案
{手动打开 .collaboration/features/mobile-login/tech.md，复制内容粘贴}
```

### GitHub Copilot 用户

**使用方式**:
在 VS Code Copilot Chat 中：
```
作为后端工程师，请实现登录接口。

## API 契约
@.collaboration/features/mobile-login/api.yaml
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

### 阶段 5: QA → Code Review

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

1. **Product → Tech Lead / Frontend-Design / Project Manager**: 完美衔接，PRD 文档作为中间产物清晰明确
2. **Frontend-Design + Tech Lead → 联合评审**: Master Coordinator 组织，自动冲突检测
3. **联合评审 → Backend/Frontend**: 评审通过后并行开发，无缝衔接
4. **QA → Code Review**: 测试代码 + 测试报告，审查维度完整

### 关键成功因素

1. ✅ **中间产物标准化** - PRD、设计方案、技术方案、组件设计源码都有明确格式
2. ✅ **文件路径约定** - `.collaboration/features/{feature-name}/` 路径清晰
3. ✅ **@引用机制** - OpenCode 自动读取引用文件，无需手动打包
4. ✅ **联合评审机制** - 自动检测冲突，最多 5 轮修改，确保质量

### v7.0.0 新增

1. **Master Coordinator** - 组织并行工作、联合评审、冲突检测
2. **联合评审机制** - 4 个维度冲突检测，最多 5 轮修改
3. **design-components.md** - Frontend-Design 输出组件设计源码
4. **design.md** - Frontend-Design 输出设计方案（路径变更）

### 实施建议

1. **使用 Master Coordinator** - 复杂功能使用联合评审机制
2. **简单功能跳过评审** - 直接由 Tech Lead 和 Frontend-Design 并行工作
3. **及时提交代码** - 每个阶段完成后及时将产出物保存到项目目录
4. **统一目录结构** - 遵循建议的目录结构，确保文件路径一致
5. **定期回顾** - 每个迭代结束后回顾流转过程，持续改进

---

## 附录

### A. Skills 列表

| Skill | 文件路径 |
|-------|---------|
| product-manager | `skills/product-manager/SKILL.md` |
| project-manager | `skills/project-manager/SKILL.md` |
| tech-lead | `skills/tech-lead/SKILL.md` |
| frontend-design | `skills/frontend-design/SKILL.md` |
| backend-typescript | `skills/backend-typescript/SKILL.md` |
| backend-springboot | `skills/backend-springboot/SKILL.md` |
| frontend | `skills/frontend/SKILL.md` |
| qa-engineer | `skills/qa-engineer/SKILL.md` |
| code-reviewer | `skills/code-reviewer/SKILL.md` |
| master-coordinator | `skills/master-coordinator/SKILL.md` |

### B. 相关文档

- [README.md](README.md) - 完整方案文档
- [QUICKSTART.md](QUICKSTART.md) - 5 分钟快速上手
- [skills/README.md](skills/README.md) - Skills 使用指南
- [docs/skills-vs-subagents.md](docs/skills-vs-subagents.md) - Skills vs Subagents 决策文档

### C. 版本历史

| 版本 | 日期 | 变更内容 |
|------|------|---------|
| v7.0.0 | 2026-03-19 | 新增 Master Coordinator、联合评审机制、4 维度冲突检测 |
| v6.0.0 | 2026-03-18 | 初始版本 |
# frontend-design Skill 实施总结

## 📋 实施概述

本次实施新增了 `frontend-design` Skill，实现了前端设计与开发的分离，并更新了 `frontend` 的技术栈。

**提交 ID**: `69a2ca1`  

---

## 🎯 实施目标

1. **新增 frontend-design Skill** - 输出高品质 UI/UX 设计和可复用组件代码
2. **更新 frontend Skill** - 基于最新技术栈（React 19、Vite 8 等）
3. **设计→开发分离** - 确保设计与开发职责清晰
4. **更新所有文档** - 确保文档与实施一致

---

## 📦 新增内容

### 1. frontend-design Skill

**文件**: `skills/frontend-design/SKILL.md`

**技术栈**:
```yaml
包管理器：Bun workspace 1.1.x
Monorepo: Turborepo 2.x
语言：TypeScript 5.x
框架：React 19（Server Components、Actions）
构建工具：Vite 8
路由：TanStack Router
样式：Tailwind CSS 4
组件库：Ant Design 6
代码质量：Biome
Git 规范：Commitlint + Lefthook
```

**核心功能**:
- 三轮需求澄清机制（需求→风格→组件）
- 设计评审机制（可访问性、性能、可行性）
- 输出设计文档 + 可复用组件代码

**产出物**:
```
designs/{feature-name}/
├── design.md                 # 设计文档
├── components/
│   ├── ui/                   # 原子组件
│   ├── composite/            # 分子组件
│   └── pages/                # 页面组件
└── review.md                 # 设计评审报告
```

### 2. frontend Skill 更新

**技术栈更新**:
```diff
- React 18 / Next.js
+ React 19（Server Components、Actions）

- TypeScript
+ TypeScript 5.x

- Tailwind CSS / CSS Modules
+ Tailwind CSS 4

+ TanStack Router
+ Vite 8
+ Ant Design 6
+ Bun workspace + Turborepo
+ Biome（替代 ESLint/Prettier）
+ Commitlint + Lefthook
```

**前置条件**（新增）:
```markdown
在开始前端开发前，必须确认：
- [ ] 设计稿已完成并通过评审
- [ ] 设计组件代码已提供
- [ ] API 契约已确定
- [ ] 技术方案已评审
```

---

## 🔄 工作流变更

### 变更前
```
需求 → PRD → 技术方案 → API → 开发 → 测试 → Review → 上线
                              ↑
                         frontend
```

### 变更后
```
需求 → PRD → 技术方案 → API → 设计 → 评审 → 开发 → 测试 → Review → 上线
                              ↑      ↑      ↑
                     frontend-design 前端工程师 (基于设计开发)
```

**新增阶段**:
1. **设计阶段** - frontend-design 输出设计文档和组件代码
2. **设计评审** - 确保设计可访问性、性能、开发可行性
3. **前端开发** - 基于设计组件代码进行业务逻辑开发

---

## 📁 文件变更统计

| 类别 | 新增 | 更新 | 删除 |
|------|------|------|------|
| **Skill 定义** | 1 (frontend-design) | 1 (frontend) | 0 |
| **示例文件** | 2 (opencode.md, claude.md) | 0 | 0 |
| **文档** | 0 | 4 (README, QUICKSTART, skills/README, ai-tool-configs) | 0 |
| **总计** | **3** | **5** | **0** |

**代码行数变更**: +1,214 行，-104 行

---

## 🎨 设计原则

### 1. 移动优先（Mobile First）
- 从小屏幕到大屏幕渐进增强
- 响应式断点：sm (640px), md (768px), lg (1024px), xl (1280px), 2xl (1536px)

### 2. 无障碍访问（WCAG 2.1 AA）
- 语义化 HTML
- 键盘导航支持
- 屏幕阅读器友好
- 颜色对比度符合标准

### 3. 性能优先
- Lighthouse 性能评分 > 90
- 首屏加载 < 1.5s
- 组件按需加载
- 图片懒加载

### 4. 组件复用
- 原子设计原则（Atomic Design）
- 设计系统思维
- 高内聚低耦合

### 5. 开发体验
- TypeScript 完整类型
- 组件 Props 清晰定义
- 代码注释完整
- 示例代码可运行

---

## 📋 需求澄清机制

### 第一轮：设计需求澄清
```
### 业务目标
- 这个页面的核心目标是什么？
- 期望用户完成什么操作？

### 目标用户
- 主要目标用户是谁？
- 用户使用场景？

### 设计风格
- 是否有品牌规范？
- 偏好风格？
- 竞品参考？
```

### 第二轮：设计风格确认
```
### 配色方案
- 主色：{品牌色}
- 辅助色
- 深色模式支持

### 字体系统
- 中文字体
- 英文字体
- 字号系统

### 组件风格
- 圆角：小/中/大
- 阴影：轻微/中等/强烈
```

### 第三轮：组件设计确认
```
### 页面布局
- 布局结构
- 响应式方案

### 组件列表
- 原子组件
- 分子组件
- 页面组件

### 交互流程
- 用户操作流程
- 状态流转
```

**只有用户确认"无异议"后才开始输出设计**。

---

## 📊 使用示例

### 前端设计师工作流

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: frontend-design)

# 3. 描述任务
请设计登录页面。

## PRD
@.collaboration/features/mobile-login/prd.md

## API 契约
@.collaboration/features/mobile-login/api.yaml

## 设计要求
- 移动端优先
- 支持深色模式
- 无障碍访问 WCAG 2.1 AA
- 配色方案：品牌蓝色 (#1890ff)
- 性能要求：Lighthouse > 90
```

### 前端工程师工作流

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: frontend)

# 3. 描述任务
请基于设计开发登录页面。

## UI 设计稿
@designs/mobile-login/design.md

## 设计组件代码
@designs/mobile-login/components/

## API 契约
@.collaboration/features/mobile-login/api.yaml
```

---

## ✅ 质量检查清单

### frontend-design

**设计文档质量**:
- [ ] 页面布局清晰
- [ ] 组件结构合理
- [ ] 交互流程完整
- [ ] 响应式方案明确
- [ ] 无障碍访问说明

**组件代码质量**:
- [ ] TypeScript 类型完整
- [ ] Props 接口清晰
- [ ] 响应式支持
- [ ] 无障碍访问支持
- [ ] 代码注释完整
- [ ] 示例代码可运行

### frontend

**技术栈检查**:
- [ ] 使用 React 19
- [ ] 使用 TypeScript 5.x
- [ ] 使用 Tailwind CSS 4
- [ ] 使用 Ant Design 6
- [ ] 使用 TanStack Router
- [ ] 使用 Vite 8
- [ ] 使用 Biome

**设计稿一致性**:
- [ ] 与设计稿保持一致
- [ ] 使用设计组件代码
- [ ] 响应式符合设计要求
- [ ] 无障碍访问符合 WCAG 2.1 AA

---

## 🚀 下一步行动

### 1. 团队培训
- 介绍 frontend-design Skill 的使用
- 演示设计→开发工作流
- 分享最佳实践

### 2. 试点项目
- 选择一个项目试点使用
- 收集反馈
- 持续优化

### 3. 组件库建设
- 基于设计组件构建可复用组件库
- 建立设计系统
- 文档化组件使用

---

## 📚 相关文档

- [skills/frontend-design/SKILL.md](skills/frontend-design/SKILL.md)
- [skills/frontend/SKILL.md](skills/frontend/SKILL.md)
- [skills/README.md](skills/README.md)
- [README.md](README.md)
- [QUICKSTART.md](QUICKSTART.md)

---

**更新日期**: 2026-03-18  
**作者**: AI Team Cooperation
