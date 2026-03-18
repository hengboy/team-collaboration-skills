# AI 协作团队方案

> 基于 OpenCode Skills 的 AI 协作编程流程

## 概述

当研发团队全面使用 AI 编程时，如何通过 **OpenCode Skills** 实现标准化的需求流转。

## 核心理念

1. **中间产物驱动** - 所有协作通过结构化文档传递
2. **OpenCode Skills** - 使用标准 `SKILL.md` 格式
3. **开箱即用** - Skills 配置到 `.opencode/skills/` 即可使用
4. **上下文共享** - 通过工具打包相关文档作为 AI 上下文

## 7 个核心 Skills

所有 Skills 位于 `.opencode/skills/` 目录，符合 OpenCode 规范：

| Skill | 触发短语 | 用途 |
|-------|---------|------|
| **product-manager** | 作为产品经理、帮我写 PRD | 需求分析、PRD、用户故事 |
| **project-manager** | 作为项目经理、帮我排期 | 优先级、排期、风险评估 |
| **tech-lead** | 作为技术负责人、设计技术方案 | 架构设计、API 契约、技术选型 |
| **backend-engineer** | 作为后端工程师、帮我写接口 | API 实现、单元测试 |
| **frontend-engineer** | 作为前端工程师、帮我写组件 | React 组件、页面开发 |
| **qa-engineer** | 作为测试工程师、帮我写测试 | 测试用例、自动化测试 |
| **code-reviewer** | 帮我审查代码 | 代码质量、安全、性能审查 |

## Skill 格式规范

符合 OpenCode 官方规范：

```markdown
---
name: skill-name
description: 简短描述（1-1024 字符）
license: MIT
compatibility: opencode
metadata:
  role: engineering
  priority: P0
---

## 角色定义
...

## 核心能力
...

## 输出规范
...

## 常用场景
...

## 质量检查清单
...
```

### 命名规则

- 小写字母数字
- 单连字符分隔
- 1-64 字符
- 匹配目录名

示例：`backend-engineer`, `tech-lead`

---

## 需求流转流程

```
需求 → PRD → 技术方案 → API → 开发 → 测试 → Review → 上线
  ↓       ↓          ↓       ↓      ↓      ↓      ↓
Product TechLead  TechLead Backend Frontend QA   Review
```

### 阶段说明

| 阶段 | 负责角色 | 使用 Skill | 产出物 |
|------|---------|-----------|--------|
| 需求分析 | 产品经理 | product-manager | `docs/prd/*.md` |
| 技术设计 | 技术负责人 | tech-lead | `docs/tech/*.md`, `docs/api/*.yaml` |
| 后端开发 | 后端工程师 | backend-engineer | `src/**/*.ts` |
| 前端开发 | 前端工程师 | frontend-engineer | `src/**/*.tsx` |
| 测试验证 | 测试工程师 | qa-engineer | `tests/**/*.test.ts` |
| 代码审查 | Tech Lead | code-reviewer | Code Review 报告 |

---

## 快速开始

### 1. 使用 Skill（OpenCode）

```bash
# 进入项目
cd /path/to/project

# 启动 OpenCode
opencode

# 在对话中调用 Skill
skill(name: backend-engineer)

# 然后描述任务
请根据 API 契约实现登录接口
```

### 2. 全局安装 Skills

```bash
# 复制到全局 Skills 目录
cp -r .opencode/skills/* ~/.config/opencode/skills/

# 所有项目都可使用
```

### 3. 项目级安装

```bash
# Skills 已在 .opencode/skills/ 目录
# OpenCode 会自动发现
```

---

## 完整工作流示例

### 场景：实现手机号登录功能

#### 1️⃣ 产品经理 - 创建 PRD

```bash
./tools/new-prd.sh "手机号登录" -p P0
```

在 OpenCode 中：
```
skill(name: product-manager)
请根据以下原始需求完善 PRD 文档：
原始需求：用户反馈登录流程太复杂...
```

**产出**: `docs/prd/mobile-login.md`

#### 2️⃣ 技术负责人 - 设计技术方案

```bash
./tools/context-pack.sh tech 手机号登录
```

在 OpenCode 中：
```
skill(name: tech-lead)
请根据 PRD 设计技术方案
```

**产出**: `docs/tech/mobile-login.md`, `docs/api/auth.yaml`

#### 3️⃣ 后端工程师 - 实现 API

```bash
./tools/context-pack.sh backend 手机号登录
```

在 OpenCode 中：
```
skill(name: backend-engineer)
请根据 API 契约实现登录接口
```

**产出**: `src/auth/*.ts`

#### 4️⃣ 前端工程师 - 开发组件

```bash
./tools/context-pack.sh frontend 手机号登录
```

在 OpenCode 中：
```
skill(name: frontend-engineer)
请开发登录页面组件
```

**产出**: `src/pages/login/*.tsx`

#### 5️⃣ 测试工程师 - 编写测试

```bash
./tools/context-pack.sh qa 手机号登录
```

在 OpenCode 中：
```
skill(name: qa-engineer)
请编写测试用例
```

**产出**: `tests/auth.test.ts`

#### 6️⃣ 代码审查

在 OpenCode 中：
```
skill(name: code-reviewer)
请审查这个 PR
```

**产出**: Code Review 报告

---

## 目录结构

```
ai-team-cooperation/
├── README.md                     # 本文档
├── .opencode/skills/             # OpenCode Skills（7 个）
│   ├── product-manager/SKILL.md
│   ├── project-manager/SKILL.md
│   ├── tech-lead/SKILL.md
│   ├── backend-engineer/SKILL.md
│   ├── frontend-engineer/SKILL.md
│   ├── qa-engineer/SKILL.md
│   └── code-reviewer/SKILL.md
├── skills/                       # 旧版 Skills（参考）
│   └── ...
├── examples/                     # 示例文档
│   ├── prd-example.md
│   ├── tech-example.md
│   └── api-example.yaml
└── tools/                        # 工具脚本
    ├── context-pack.sh
    ├── new-prd.sh
    └── api-validate.sh
```

---

## 工具说明

### context-pack.sh - 上下文打包

```bash
./tools/context-pack.sh <任务类型> <功能名称>

# 示例
./tools/context-pack.sh backend 手机号登录
```

### new-prd.sh - 创建 PRD

```bash
./tools/new-prd.sh <需求名称> [-p P0|P1|P2] [-a @author]
```

### api-validate.sh - API 验证

```bash
./tools/api-validate.sh <API 文件> [-s] [-r]
```

---

## 配置权限

在 `opencode.json` 中配置：

```json
{
  "permission": {
    "skill": {
      "*": "allow",
      "code-reviewer": "allow",
      "internal-*": "deny"
    }
  }
}
```

---

## 最佳实践

### ✅ 应该做的

1. **使用 Skill 工具** - 先加载 Skill 再描述任务
2. **提供上下文** - 使用 context-pack.sh 打包文档
3. **明确角色** - 使用对应的 Skill
4. **检查质量** - 使用检查清单验证输出

### ❌ 不应该做的

1. **跳过 Skill** - 直接让 AI 生成
2. **角色混乱** - 混用多个 Skill
3. **缺少上下文** - 不提供背景信息

---

## 版本

- **当前版本**: v3.0.0
- **格式**: OpenCode SKILL.md
- **更新日期**: 2024-01-15

---

## 反馈

- GitHub Issues
- 团队周会

**位置**: `~/AiHistorys/ai-team-cooperation/`
