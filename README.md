# AI 协作团队方案

> 基于 Skills 的 AI 协作编程流程 - 无需脚本，直接调用

## 概述

当研发团队全面使用 AI 编程时，如何通过 **Skills（技能）** 实现标准化的需求流转。**无需任何脚本**，直接在 AI 中调用 skill 即可。

## 核心理念

1. **中间产物驱动** - 所有协作通过结构化文档传递
2. **Skills 标准化** - 每个角色一个 Skill 定义
3. **无需脚本** - 直接用 `skill(name: xxx)` 调用
4. **@引用文件** - 用 `@` 引用项目文档作为上下文

## 10 个核心 Skills

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
| `git-commit` | 帮我生成提交信息 | Git 提交规范（Gitmoji） |

**注意**: 
- 提供两个后端 Skill，根据技术栈选择
- 前端开发前需要先进行设计（frontend-design → frontend）

## 需求流转流程

```
                    原始需求
                       ↓
              [Product Manager]
                   ↓ PRD
            ┌──────┴──────┐
            ↓             ↓
   [Project Manager]  [Tech Lead]
      ↓ 项目计划      ↓ 技术方案 + API 契约
            └──────┬──────┘
                   ↓
            ┌──────┴──────┐
            ↓             ↓
       [Backend]   [Frontend-Design]
       后端代码        UI/UX 设计
       （并行）        （并行）
            ↓             ↓
            └──────┬──────┘
                   ↓
           [Frontend]
               前端代码
                   ↓
            ┌──────┴──────┐
            ↓             ↓
       单元测试      [QA] → 测试用例 + 测试报告
                        ↓
                [Code Review] → 审查报告 → 上线
```

**流程说明**:
1. **阶段 1 - Product Manager**: 输出 PRD 文档（用户故事、功能需求、验收条件）
2. **阶段 2 - 并行**: Project Manager（项目计划）和 Tech Lead（技术方案）并行工作
3. **阶段 3 - 并行**: Backend（后端代码）和 Frontend-Design（UI/UX 设计）并行工作
4. **阶段 4 - 汇合**: Frontend 等待 Backend 和 Frontend-Design 完成后开始
5. **阶段 5 - QA**: 基于 PRD、API、源代码编写测试用例和测试报告
6. **阶段 6 - Code Review**: 审查代码质量，通过后上线

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

## 目录结构

```
project/
├── README.md                       # 本文档
├── QUICKSTART.md                   # 5 分钟快速上手
├── REQUIREMENT-FLOW-ANALYSIS.md    # 需求流转深度分析
├── skills/                         # Skills 定义（10 个）
│   ├── product-manager/SKILL.md
│   ├── project-manager/SKILL.md
│   ├── tech-lead/SKILL.md
│   ├── frontend-design/SKILL.md
│   ├── backend-typescript/SKILL.md
│   ├── backend-springboot/SKILL.md
│   ├── frontend/SKILL.md
│   ├── qa-engineer/SKILL.md
│   ├── code-reviewer/SKILL.md
│   └── git-commit/SKILL.md
├── examples/                       # 示例文档
├── docs/                           # 补充文档
├── .collaboration/
│   ├── features/
│   │   ├── mobile-login/
│   │   │   ├── prd.md
│   │   │   ├── tech.md
│   │   │   ├── api.yaml
│   │   │   ├── plan.md
│   │   │   └── test-report.md
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

- **当前版本**: v6.0.0
- **更新日期**: 2026-03-18
- **特点**: 
  - 前端设计→开发分离（frontend-design）
  - 支持两种后端技术栈（TypeScript/Java）
  - 新增 git-commit 提交规范
  - 完整的需求流转链路分析

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
