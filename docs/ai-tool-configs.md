# AI 工具配置指南

## 概述

所有 Skills 均使用 Markdown 格式，可配置到主流 AI 工具。

文档协同链路推荐混合模式：

- `product-manager`、`master-coordinator` 保持在当前会话
- `project-manager`、`frontend-design`、`tech-lead` 通过 subagent 调用
- 实现类角色继续直接用 `skill(name: xxx)` 调用，不要对 `frontend`、`backend-typescript`、`backend-springboot` 使用 subagent 或 `spawn_agent`

---

## OpenCode

如需使用 OpenCode subagent 运行时，先生成 agents 适配文件：

```bash
./scripts/sync-platform-adapters.sh
```

### 使用方式

```bash
# 启动 OpenCode
opencode

# 文档协同主链路使用 master-coordinator
skill(name: master-coordinator)

# 在当前会话中继续协调，并调用 subagent
请继续负责 mobile-login 的协调工作。
并行调用 @project-manager、@tech-lead 和 @frontend-design，其中 @tech-lead 不需要等待 plan.md，@frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再问我是“通过”还是“继续澄清/修订”。
如果你发现评审里已经变成新增功能，而不是当前 PRD 范围内修订，请直接提示我要回到 product-manager 重头开始。

## PRD
@.collaboration/features/mobile-login/prd.md
```

### 配置全局 Skills

```bash
cp -r skills/* ~/.config/opencode/skills/
```

---

## Claude Desktop

先运行一次运行时同步：

```bash
./scripts/sync-platform-adapters.sh --with-skills
```

### 配置 Skills / Agents

```bash
mkdir -p ~/.claude/skills ~/.claude/agents
cp skills/master-coordinator/SKILL.md ~/.claude/skills/
cp .claude/agents/project-manager.md ~/.claude/agents/
cp .claude/agents/frontend-design.md ~/.claude/agents/
cp .claude/agents/tech-lead.md ~/.claude/agents/
```

### 使用方式

```bash
claude
```

在对话中：

```
请保持当前会话作为 master-coordinator。
并行使用 project-manager、tech-lead 和 frontend-design subagents，其中 tech-lead 不需要等待 plan.md，frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再询问我是“通过”还是“继续澄清/修订”。
如果你发现评审里已经变成新增功能，而不是当前 PRD 范围内修订，请直接提示我要回到 product-manager 重头开始。
后续修订继续交给对应 subagents 处理，不要直接切换成对应 skill。

## PRD
{粘贴 .collaboration/features/mobile-login/prd.md 内容}
```

---

## GitHub Copilot

### 配置 Instructions

```bash
mkdir -p .github
cat skills/backend-typescript/SKILL.md >> .github/copilot-instructions.md
```

### 使用方式

在 VS Code Copilot Chat 中：

```
作为后端工程师，请实现登录接口。

## API 契约
@.collaboration/features/mobile-login/api.yaml
```

---

## Cursor

### 配置 Rules

```bash
cat skills/backend-typescript/SKILL.md >> .cursorrules
```

### 使用方式

在 Cursor Chat 中：

```
作为后端工程师，请实现登录接口。

## API 契约
@.collaboration/features/mobile-login/api.yaml
```

---

## 通用使用方法

### OpenCode 用户

协同链路：

```
skill(name: master-coordinator)

请继续协调当前 feature。
并行调用 @project-manager、@tech-lead 和 @frontend-design，且 @tech-lead 不等待 plan.md，@frontend-design 直接基于 PRD 开始。
首轮需先补齐 plan.md、tech.md、api.yaml、design.md、design-components.md，再问我是“通过”还是“继续澄清/修订”。
如果你发现评审里已经变成新增功能，而不是当前 PRD 范围内修订，请直接提示我要回到 product-manager 重头开始。
```

实现链路：

```
联合评审已通过。
当前主会话不要继续把 backend-typescript、backend-springboot 或 frontend 当成 subagent 调用。

skill(name: backend-typescript)
先从输入路径 .collaboration/features/{feature-name}/... 提取 feature-name；如果当前工具只有文档内容没有路径，就从 frontmatter 里的 feature: 提取；如果还不能唯一确定，就先暂停并要求我补充。
先识别当前 TypeScript 后端源码路径与测试路径，并使用具体路径，例如 apps/api/src/modules/ 或 src/modules/。
禁止把实现代码写到 .collaboration/features/mobile-login/
实现完成后，必须执行仓库现有的代码质量、语法/类型/构建、测试与缺陷检查。
请汇总实际执行的命令、通过结果和剩余阻塞；未全部通过前不要进入下一阶段。
请实现登录接口。
@.collaboration/features/mobile-login/api.yaml
```

实现阶段 handoff 模板：

```
联合评审已通过。
当前主会话不要继续使用 subagent 或 spawn_agent 调用 frontend、backend-typescript、backend-springboot。

请直接进入 `skill(name: frontend)` 或 `skill(name: backend-springboot)` / `skill(name: backend-typescript)`。
根据对应输入文档完成实现，并在结束前执行质量检查、测试与结果汇总。
```

### 其他工具用户

手动说明当前会话保持为 `master-coordinator`，并显式要求并行使用 `project-manager`、`tech-lead`、`frontend-design` subagent；同时要求首轮先补齐计划、技术、API 与设计产物，再询问用户“通过”还是“继续澄清/修订”。
如果评审中已经变成新增功能，而不是当前 PRD 范围内修订，则要求协调器直接提示回到 `product-manager` 重头开始。
进入实现阶段后，还应显式要求留在主会话中直接调用实现类 skill，不要把 `frontend`、`backend-typescript`、`backend-springboot` 当作 subagent；同时要求先识别技术栈对应的具体源码路径，再写代码；实现代码和测试禁止写到 `.collaboration/features/{feature-name}/`。
还要显式要求先确定唯一 `feature-name`：优先从 `.collaboration/features/{feature-name}/...` 输入路径提取，取不到再从文档 frontmatter 的 `feature:` 字段提取；若仍无法确定或两者不一致，则停止并提示用户补充。
同时要把实现后的强制质量门禁说清楚：必须执行代码质量检查、语法/类型或编译检查、测试与缺陷检查，并汇总实际执行命令、结果摘要和剩余阻塞；未全部通过前不能流转到下一阶段。
