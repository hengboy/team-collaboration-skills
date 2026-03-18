# 5 分钟快速上手

## 第一步：了解 Skills

本方案包含 **7 个 AI Skills**，覆盖产品开发全流程：

| Skill | 用途 |
|-------|------|
| Product | 需求分析、PRD |
| Project Manager | 项目排期、风险评估 |
| Tech Lead | 技术方案、API 设计 |
| Backend | 后端代码实现 |
| Frontend | 前端组件开发 |
| QA | 测试用例、自动化 |
| Code Review | 代码审查 |

## 第二步：选择你的角色

### 产品经理

```bash
# 1. 创建 PRD 框架
./tools/new-prd.sh "功能名称" -p P0

# 2. 使用 Product Skill
cat skills/product/skill.md

# 3. 复制内容到 AI 工具，输入原始需求
```

### 技术负责人

```bash
# 1. 打包上下文（包含 PRD）
./tools/context-pack.sh tech 功能名称

# 2. 使用 Tech Lead Skill
cat skills/tech-lead/skill.md

# 3. 复制 context + skill 到 AI 工具
```

### 开发工程师

```bash
# 1. 打包上下文（包含 API 契约）
./tools/context-pack.sh backend 功能名称

# 2. 使用 Backend Skill
cat skills/backend/skill.md

# 3. 复制 context + skill 到 AI 工具
```

### 测试工程师

```bash
# 1. 打包上下文
./tools/context-pack.sh qa 功能名称

# 2. 使用 QA Skill
cat skills/qa/skill.md

# 3. 复制 context + skill 到 AI 工具
```

## 第三步：配置到 AI 工具（可选）

### Cursor

```bash
cat skills/backend/skill.md >> .cursorrules
```

### GitHub Copilot

```bash
cat skills/backend/skill.md >> .github/copilot-instructions.md
```

### OpenCode

```bash
cp skills/backend/skill.md ~/.config/opencode/skills/backend.md
```

## 完整流程示例

以"手机号登录"功能为例：

```
1. 产品经理创建 PRD
   → ./tools/new-prd.sh "手机号登录" -p P0
   → 使用 Product Skill 完善

2. 技术负责人设计方案
   → ./tools/context-pack.sh tech 手机号登录
   → 使用 Tech Lead Skill

3. 后端开发
   → ./tools/context-pack.sh backend 手机号登录
   → 使用 Backend Skill

4. 前端开发
   → ./tools/context-pack.sh frontend 手机号登录
   → 使用 Frontend Skill

5. 测试编写用例
   → ./tools/context-pack.sh qa 手机号登录
   → 使用 QA Skill

6. 代码审查
   → 使用 Code Review Skill
```

## 下一步

- 查看 [README.md](README.md) 了解完整方案
- 查看 [skills/README.md](skills/README.md) 了解 Skills 详情
- 开始你的第一个 AI 协作任务！
