# AI 协作团队方案

> 基于 Skills 的 AI 协作编程流程 - 无需脚本，直接调用

## 概述

当研发团队全面使用 AI 编程时，如何通过 **Skills（技能）** 实现标准化的需求流转。**无需任何脚本**，直接在 AI 中调用 skill 即可。

## 核心理念

1. **中间产物驱动** - 所有协作通过结构化文档传递
2. **Skills 标准化** - 每个角色一个 Skill 定义
3. **无需脚本** - 直接用 `skill(name: xxx)` 调用
4. **@引用文件** - 用 `@` 引用项目文档作为上下文

## 11 个核心 Skills

| Skill | 触发短语 | 用途 |
|-------|---------|------|
| `product-manager` | 作为产品经理、帮我写 PRD | 需求分析、PRD、用户故事 |
| `project-manager` | 作为项目经理、帮我排期 | 项目排期、风险评估、资源分配 |
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
- 提供两个后端 Skill，根据技术栈选择
- 前端开发前需要先进行设计（frontend-design → frontend）
- Master Coordinator 组织并行工作和联合评审（最多 5 轮）

## 需求流转流程

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

**流程说明**:
1. **阶段 1 - Product Manager**: 输出 PRD 文档（用户故事、功能需求、验收条件）
2. **阶段 2 - Project Manager**: 输出项目计划（并行工作）
3. **阶段 3 - Master Coordinator**: 组织 Frontend-Design 和 Tech Lead 并行工作
4. **阶段 4 - 联合评审**: 自动检测 4 个维度冲突，最多 5 轮修改
5. **阶段 5 - 并行开发**: Backend 和 Frontend 基于评审通过的设计和技术方案开发
6. **阶段 6 - QA**: 基于 PRD、API、源代码编写测试用例和测试报告
7. **阶段 7 - Code Review**: 审查代码质量，通过后上线

### 简化流程（跳过联合评审）

```
PRD → Tech Lead → 技术方案 → Backend / Frontend → 测试 → Review → 上线
      ↓
  Frontend-Design → Frontend
```

---

## 快速开始

### OpenCode（推荐）

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: product-manager)

# 3. 描述任务
请帮我创建手机号登录功能的 PRD。

## 背景
用户反馈登录流程太复杂。

## 业务目标
- 提升登录转化率 15%
```

**无需脚本** - 直接用 `skill(name: xxx)` 和 `@` 引用文件。

---

## Master Coordinator 工作流

### 完整流程（推荐）

```bash
# 1. 启动 Master Coordinator
opencode
skill(name: master-coordinator)

请组织手机号登录功能的并行设计和技术方案。

## PRD
@.collaboration/features/mobile-login/prd.md

## 要求
- Frontend-Design 输出设计方案和组件设计
- Tech Lead 输出技术方案和 API 契约
- 完成后组织联合评审
```

**执行流程**:
1. Master Coordinator 从 PRD 路径提取 feature-name
2. 启动 Frontend-Design（输出 `design.md` + `design-components.md`）
3. 启动 Tech Lead（输出 `tech.md` + `api.yaml`）
4. 等待两者完成
5. 自动检测 4 个维度冲突（技术可行性、API 匹配度、性能目标、时间线）
6. 等待用户输入"开始评审"
7. 组织联合评审（最多 5 轮）
8. 评审通过后进入开发阶段

**注意**：`feature-name` 由 Product Manager 在创建 PRD 时确定，不是由 Master Coordinator 确认。

### 联合评审

评审开始后，Master Coordinator 输出：

```markdown
## 联合评审会议

**功能**: mobile-login
**日期**: {timestamp}
**参与者**: Frontend-Design, Tech Lead, User

### 输出文件
- ✅ design.md
- ✅ design-components.md
- ✅ tech.md
- ✅ api.yaml

### 冲突检测结果

| 维度 | 状态 | 问题描述 |
|------|------|---------|
| 技术可行性 | ⚠️ | {问题} |
| API 匹配度 | ✅ | 无问题 |
| 性能目标 | ⚠️ | {问题} |
| 时间线 | ✅ | 无问题 |

### 待决议问题

1. {问题 1}
2. {问题 2}

### 操作选项

请选择：

**通过** → 进入开发阶段

**修改设计** → 提出具体修改意见

**修改技术** → 提出具体修改意见

**两者都改** → 分别提出修改意见

---

## 第 1/5 轮评审
```

### 评审通过后

```
✅ 评审通过 - 可以进入开发阶段

### 最终输出

- .collaboration/features/mobile-login/design.md (v3)
- .collaboration/features/mobile-login/design-components.md (v3)
- .collaboration/features/mobile-login/tech.md (v2)
- .collaboration/features/mobile-login/api.yaml (v2)
- .collaboration/features/mobile-login/review.md (评审记录)

### 下一步

- skill(name: backend-typescript)  # 后端开发
- skill(name: frontend)            # 前端开发
```

---

## 目录结构

```
project/
├── README.md                       # 本文档
├── QUICKSTART.md                   # 5 分钟快速上手
├── REQUIREMENT-FLOW-ANALYSIS.md    # 需求流转深度分析
├── skills/                         # Skills 定义（11 个）
│   ├── product-manager/SKILL.md
│   ├── project-manager/SKILL.md
│   ├── tech-lead/SKILL.md
│   ├── frontend-design/SKILL.md
│   ├── backend-typescript/SKILL.md
│   ├── backend-springboot/SKILL.md
│   ├── frontend/SKILL.md
│   ├── qa-engineer/SKILL.md
│   ├── code-reviewer/SKILL.md
│   ├── master-coordinator/SKILL.md
│   └── git-commit/SKILL.md
├── examples/                       # 示例文档
├── docs/                           # 补充文档
├── .collaboration/
│   ├── features/
│   │   ├── mobile-login/
│   │   │   ├── prd.md              # Product Manager 输出
│   │   │   ├── plan.md             # Project Manager 输出
│   │   │   ├── design.md           # Frontend-Design 输出
│   │   │   ├── design-components.md # Frontend-Design 输出（组件源码）
│   │   │   ├── tech.md             # Tech Lead 输出
│   │   │   ├── api.yaml            # Tech Lead 输出
│   │   │   └── review.md           # Master Coordinator 输出（评审记录）
│   │   └── {feature-name}/
│   └── shared/
│       └── coding-standards.md
├── src/
│   ├── {module}/                   # Backend 输出
│   └── pages/                      # Frontend 输出
└── tests/
    ├── unit/                       # 单元测试
    ├── e2e/                        # E2E 测试
    └── integration/                # 集成测试
```

### 文件命名规范

| 类型 | 命名规则 | 示例 |
|------|---------|------|
| PRD | `.collaboration/features/{feature-name}/prd.md` | `.collaboration/features/mobile-login/prd.md` |
| 技术方案 | `.collaboration/features/{feature-name}/tech.md` | `.collaboration/features/mobile-login/tech.md` |
| API 契约 | `.collaboration/features/{feature-name}/api.yaml` | `.collaboration/features/mobile-login/api.yaml` |
| 项目计划 | `.collaboration/features/{feature-name}/plan.md` | `.collaboration/features/mobile-login/plan.md` |
| 设计方案 | `.collaboration/features/{feature-name}/design.md` | `.collaboration/features/mobile-login/design.md` |
| 组件源码 | `.collaboration/features/{feature-name}/design-components.md` | `.collaboration/features/mobile-login/design-components.md` |
| 评审记录 | `.collaboration/features/{feature-name}/review.md` | `.collaboration/features/mobile-login/review.md` |
| 后端代码 | `src/{module}/{name}.ts` | `src/auth/auth.service.ts` |
| 前端代码 | `src/pages/{name}/{name}.tsx` | `src/pages/login/LoginPage.tsx` |
| 测试用例 | `tests/{type}/{feature}.test.ts` | `tests/e2e/login.spec.ts` |

---

## 完整工作流

详见 [QUICKSTART.md](QUICKSTART.md)

---

## 配置到 AI 工具

### OpenCode

Skills 已在 `skills/` 目录：

```bash
# 全局安装（可选）
cp -r skills/* ~/.config/opencode/skills/
```

### Claude Desktop

```bash
mkdir -p ~/.claude/skills
cp skills/backend-typescript/SKILL.md ~/.claude/skills/  # TypeScript 技术栈
cp skills/backend-springboot/SKILL.md ~/.claude/skills/  # Java 技术栈
```

### GitHub Copilot

```bash
cat skills/backend-typescript/SKILL.md >> .github/copilot-instructions.md  # TypeScript 技术栈
```

---

## 文档索引

| 文档 | 用途 |
|------|------|
| [QUICKSTART.md](QUICKSTART.md) | 5 分钟快速上手 |
| [REQUIREMENT-FLOW-ANALYSIS.md](REQUIREMENT-FLOW-ANALYSIS.md) | 需求流转深度分析 |
| [skills/README.md](skills/README.md) | Skills 使用指南 |
| [docs/ai-tool-configs.md](docs/ai-tool-configs.md) | AI 工具配置 |

---

## 版本

- **当前版本**: v7.0.0
- **更新日期**: 2026-03-19
- **特点**: 
  - 新增 Master Coordinator（组织并行工作、联合评审）
  - 前端设计→开发分离（frontend-design）
  - 支持两种后端技术栈（TypeScript/Java）
  - 新增 git-commit 提交规范
  - 联合评审机制（最多 5 轮，4 维度冲突检测）

---

## 质量检查清单

### 阶段 1: Product → Tech Lead / Project Manager

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

**开始使用**: `opencode` → `skill(name: product-manager)`
