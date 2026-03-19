# Skills 使用指南

## 概述

本目录包含 **11 个 AI Skills**，用于 AI 协作团队的各个角色。

**无需任何脚本** - 直接在 AI 中调用 `skill(name: xxx)` 即可。

## 可用 Skills

| Skill | 触发短语 | 用途 |
|-------|---------|------|
| **product-manager** | 作为产品经理、帮我写 PRD | 需求分析、PRD |
| **project-manager** | 作为项目经理、帮我排期 | 项目排期、风险评估 |
| **tech-lead** | 作为技术负责人、设计技术方案 | 架构设计、API 契约 |
| **frontend-design** | 作为设计师、帮我设计页面 | UI/UX 设计、组件设计 |
| **backend-typescript** | 作为后端工程师、帮我写接口 | TypeScript + NestJS |
| **backend-springboot** | 作为 Java 工程师、帮我写接口 | Java + Spring Boot |
| **frontend** | 作为前端工程师、帮我写组件 | React 19 + 现代前端技术栈 |
| **qa-engineer** | 作为测试工程师、帮我写测试 | 测试用例、自动化测试 |
| **code-reviewer** | 帮我审查代码 | 代码质量、安全审查 |
| **master-coordinator** | 组织并行设计和技术方案、联合评审 | 协调多角色、冲突检测 |
| **git-commit** | 帮我生成提交信息 | Git 提交规范（Gitmoji） |

**注意**: 
- 提供两个后端 Skill，根据技术栈选择
- 前端开发前需要先进行设计（frontend-design）
- Master Coordinator 组织并行工作和联合评审（最多 5 轮）

---

## 使用方式

### OpenCode

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: backend-typescript)  # 或 backend-springboot

# 3. 描述任务（用@引用文件）
请实现登录接口。

## API 契约
@.collaboration/features/mobile-login/api.yaml

## 技术方案
@.collaboration/features/mobile-login/tech.md
```

**无需脚本** - OpenCode 会自动读取 `@` 引用的文件。

### Claude Desktop

```bash
# 1. 配置 Skills
mkdir -p ~/.claude/skills
cp skills/backend-typescript/SKILL.md ~/.claude/skills/  # TypeScript 技术栈
cp skills/backend-springboot/SKILL.md ~/.claude/skills/  # Java 技术栈

# 2. 启动 Claude
claude

# 3. 在对话中说明
我使用后端工程师 Skill，请实现登录接口。

## API 契约
（粘贴 .collaboration/features/mobile-login/api.yaml 内容）
```

**注意**: 提供两个后端 Skill，根据技术栈选择使用：
- `backend-typescript` - TypeScript + Node.js + NestJS
- `backend-springboot` - Java 21 + Spring Boot + MyBatis-Plus

---

## 完整工作流

```bash
# 1. 产品经理
skill(name: product-manager)
# 创建 PRD

# 2. 技术负责人
skill(name: tech-lead)
# 设计技术方案

# 3. 后端开发（选择技术栈）
skill(name: backend-typescript)   # TypeScript + NestJS
skill(name: backend-springboot)   # Java + Spring Boot
# 实现 API

# 4. 前端设计（新增）
skill(name: frontend-design)
# UI/UX 设计、组件设计

# 5. 前端开发
skill(name: frontend)
# 基于设计开发组件

# 6. 测试
skill(name: qa-engineer)
# 编写测试

# 7. 代码审查
skill(name: code-reviewer)
# 审查代码

# 8. 提交代码（可选）
skill(name: git-commit)
# 生成规范的提交信息
```

**工作流变更**: 前端开发前增加了设计阶段（frontend-design），确保设计与开发分离。

---

## Master Coordinator 工作流

### 完整流程（推荐）

```bash
# 1. 启动 Master Coordinator
skill(name: master-coordinator)

请组织手机号登录功能的并行设计和技术方案。

## PRD
@.collaboration/features/mobile-login/prd.md
```

**执行流程**:
1. 从用户引用的 PRD 路径提取 `feature-name`（如 `mobile-login`）
2. 启动 Frontend-Design → `design.md` + `design-components.md`
3. 启动 Tech Lead → `tech.md` + `api.yaml`
4. 等待两者完成
5. 自动检测 4 个维度冲突
6. 等待用户"开始评审"
7. 组织联合评审（最多 5 轮）
8. 评审通过后进入开发阶段

**注意**：`feature-name` 由 Product Manager 在创建 PRD 时确定，Master Coordinator 仅验证一致性。

### 联合评审

评审开始后输出：

```
## 联合评审会议

**功能**: mobile-login
**日期**: {timestamp}

### 冲突检测结果

| 维度 | 状态 | 问题描述 |
|------|------|---------|
| 技术可行性 | ⚠️ | {问题} |
| API 匹配度 | ✅ | 无问题 |
| 性能目标 | ⚠️ | {问题} |
| 时间线 | ✅ | 无问题 |

### 操作选项

**通过** → 进入开发阶段
**修改设计** → 提出具体修改意见
**修改技术** → 提出具体修改意见
**两者都改** → 分别提出修改意见

---

## 第 1/5 轮评审
```

---

## 示例文件

每个 Skill 配有示例：

| Skill | 使用示例 | 输出示例 |
|-------|----------|----------|
| Product Manager | [examples/product-manager/opencode.md](../examples/product-manager/opencode.md), [examples/product-manager/claude.md](../examples/product-manager/claude.md) | [examples/product-manager/prd-example.md](../examples/product-manager/prd-example.md), [examples/product-manager/prd-output-example.md](../examples/product-manager/prd-output-example.md) |
| Project Manager | [examples/project-manager/opencode.md](../examples/project-manager/opencode.md), [examples/project-manager/claude.md](../examples/project-manager/claude.md) | [examples/project-manager/project-plan-example.md](../examples/project-manager/project-plan-example.md) |
| Tech Lead | [examples/tech-lead/opencode.md](../examples/tech-lead/opencode.md), [examples/tech-lead/claude.md](../examples/tech-lead/claude.md) | [examples/tech-lead/tech-example.md](../examples/tech-lead/tech-example.md), [examples/tech-lead/tech-design-example.md](../examples/tech-lead/tech-design-example.md) |
| Frontend Design | [examples/frontend-design/opencode.md](../examples/frontend-design/opencode.md), [examples/frontend-design/claude.md](../examples/frontend-design/claude.md) | - |
| Backend TypeScript | [examples/backend-typescript/opencode.md](../examples/backend-typescript/opencode.md), [examples/backend-typescript/claude.md](../examples/backend-typescript/claude.md) | [examples/backend-typescript/code-example.md](../examples/backend-typescript/code-example.md) |
| Backend SpringBoot | [examples/backend-springboot/opencode.md](../examples/backend-springboot/opencode.md), [examples/backend-springboot/claude.md](../examples/backend-springboot/claude.md) | - |
| Frontend Engineer | [examples/frontend/opencode.md](../examples/frontend/opencode.md), [examples/frontend/claude.md](../examples/frontend/claude.md) | [examples/frontend/component-example.md](../examples/frontend/component-example.md) |
| QA Engineer | [examples/qa-engineer/opencode.md](../examples/qa-engineer/opencode.md), [examples/qa-engineer/claude.md](../examples/qa-engineer/claude.md) | [examples/qa-engineer/test-cases-example.md](../examples/qa-engineer/test-cases-example.md) |
| Code Reviewer | [examples/code-reviewer/opencode.md](../examples/code-reviewer/opencode.md), [examples/code-reviewer/claude.md](../examples/code-reviewer/claude.md) | [examples/code-reviewer/code-review-example.md](../examples/code-reviewer/code-review-example.md) |
| Master Coordinator | [examples/master-coordinator/opencode.md](../examples/master-coordinator/opencode.md) | - |
| Git Commit | [examples/git-commit/opencode.md](../examples/git-commit/opencode.md), [examples/git-commit/claude.md](../examples/git-commit/claude.md) | - |

---

## 最佳实践

### ✅ 应该做的

1. 直接用 `skill(name: xxx)` 调用
2. 用 `@` 引用文件（OpenCode）
3. 明确角色
4. 检查质量

### ❌ 不应该做的

1. 跳过 Skill 加载
2. 不提供上下文
3. 角色混乱

---
