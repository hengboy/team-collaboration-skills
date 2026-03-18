# AI 协作团队方案

> 基于 Skills 的 AI 协作编程流程 - 无需脚本，直接调用

## 概述

当研发团队全面使用 AI 编程时，如何通过 **Skills（技能）** 实现标准化的需求流转。**无需任何脚本**，直接在 AI 中调用 skill 即可。

## 核心理念

1. **中间产物驱动** - 所有协作通过结构化文档传递
2. **Skills 标准化** - 每个角色一个 Skill 定义
3. **无需脚本** - 直接用 `skill(name: xxx)` 调用
4. **@引用文件** - 用 `@` 引用项目文档作为上下文

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
- 提供两个后端 Skill，根据技术栈选择
- 前端开发前需要先进行设计（frontend-design → frontend-engineer）

## 需求流转流程

```
需求 → PRD → 技术方案 → API → 设计 → 评审 → 开发 → 测试 → Review → 上线
  ↓       ↓          ↓       ↓      ↓      ↓      ↓      ↓      ↓      ↓
Product TechLead  TechLead Design Review Backend Frontend QA   Review
                    ↑        ↑               ↑
             frontend-design              前端工程师 (基于设计开发)
```

**流程说明**:
1. **设计阶段**（新增）：frontend-design 输出设计文档和可复用组件代码
2. **设计评审**（新增）：确保设计可访问性、性能、开发可行性
3. **前端开发**：基于设计组件代码进行业务逻辑开发

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
ai-team-cooperation/
├── README.md                 # 本文档
├── QUICKSTART.md             # 5 分钟快速上手
├── .opencode/skills/         # OpenCode Skills（9 个）
│   ├── product-manager/SKILL.md
│   ├── frontend-design/SKILL.md
│   ├── backend-typescript/SKILL.md
│   ├── backend-springboot/SKILL.md
│   ├── frontend-engineer/SKILL.md
│   └── ...
├── skills/                   # Skills 备份
├── examples/                 # 示例文档
└── docs/                     # 补充文档
```

---

## 完整工作流

详见 [QUICKSTART.md](QUICKSTART.md)

---

## 配置到 AI 工具

### OpenCode

Skills 已在 `.opencode/skills/` 目录：

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
| [skills/README.md](skills/README.md) | Skills 使用指南 |
| [docs/ai-tool-configs.md](docs/ai-tool-configs.md) | AI 工具配置 |

---

## 版本

- **当前版本**: v5.0.0
- **特点**: 前端设计→开发分离，支持两种后端技术栈

---

**开始使用**: `opencode` → `skill(name: product-manager)`
