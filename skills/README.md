# Skills 使用指南

## 概述

本目录包含 **10 个 AI Skills**，用于 AI 协作团队的各个角色。

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
| **git-commit** | 帮我生成提交信息 | Git 提交规范（Gitmoji） |

**注意**: 
- 提供两个后端 Skill，根据技术栈选择
- 前端开发前需要先进行设计（frontend-design）

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
@docs/collaboration/api/auth.yaml

## 技术方案
@docs/collaboration/tech/mobile-login.md
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
（粘贴 docs/api/auth.yaml 内容）
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

## 示例文件

每个 Skill 配有示例：

| Skill | 示例 |
|-------|------|
| Product | examples/opencode.md, examples/claude.md |
| Backend TypeScript | examples/opencode.md, examples/claude.md |
| Backend SpringBoot | examples/opencode.md, examples/claude.md |
| Frontend Design | examples/opencode.md, examples/claude.md |
| Frontend Engineer | examples/opencode.md, examples/claude.md |
| ... | ... |

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

