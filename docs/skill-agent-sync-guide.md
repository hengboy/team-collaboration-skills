# Skill 与 Agent 同步指南

## 单一事实源

- `skills/{name}/SKILL.md` 是事实源
- `agents/{name}/AGENT.md` 是派生物
- 当前默认只为 `project-manager`、`tech-lead`、`frontend-design` 生成派生 agent

派生规则：

- 采用最小变换模板：去掉开场展示块，保留主正文
- 不允许改写核心能力契约
- 当前以主章节中的 `### 必须输入`、`### 可选输入`、`### 输出文件`、`## 执行规则`、`## 质量检查`、`## 下一步流程` 为同步锚点
- 统一的 `## 强制约束` 段落，以及 skill 中声明的其他强制约束段落仍做精确对齐
- 平台运行时生成与提交前自检请配合 [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md) 中的脚本说明使用

## 必须保持一致的内容

- 角色定位
- 必须输入
- 可选输入
- 输出文件
- 执行规则
- 强制约束
- 质量检查
- 下一步流程
- skill 中声明的其他强制约束段落，例如：`技术栈`、`需求澄清机制`、`设计确认机制`、`设计原则`、`计划输出重点`

## 推荐结构

每个 `SKILL.md` 与 `AGENT.md` 都应包含：

- `## 角色定义` 或 `## 角色定位`
- `## 适用场景`
- `### 必须输入`
- `### 可选输入`
- `### 输出文件`
- `## 执行规则`
- `## 强制约束`
- `## 质量检查`
- `## 下一步流程`

## 同步流程

1. 先修改 `SKILL.md`
2. 运行 `./scripts/generate-agents-from-skills.sh`
3. 保证主章节中的输入、输出、执行规则、质量检查、下一步流程与 skill 精确一致，并保证 `强制约束` 及其他强制约束段落在 agent 中完整对齐
4. 运行 `./scripts/sync-skill-agent.sh`
5. 刷新平台生成物并再次验证

## 同步脚本

```bash
./scripts/generate-agents-from-skills.sh
./scripts/generate-agents-from-skills.sh tech-lead
./scripts/sync-skill-agent.sh
./scripts/sync-skill-agent.sh tech-lead
```

生成脚本会：

- 只处理当前白名单 subagent 角色
- 从 `skills/{name}/SKILL.md` 读取 `name` / `description`
- 生成带来源注释的 `agents/{name}/AGENT.md`
- 对正文执行最小变换并统一 `## 下一步流程` 标题

脚本会检查：

- 是否存在同名 skill/agent
- 是否具备统一章节
- 主章节中的输入、输出、执行规则、质量检查、下一步流程是否与对应 skill 精确一致
- `强制约束` 与 skill 中声明的其他强制约束段落是否在 agent 中完整对齐

进一步刷新平台生成物时，建议继续执行：

```bash
./scripts/sync-platform-adapters.sh --with-skills
./scripts/verify-platform-adapters.sh
```

## 维护建议

- 普通业务 skill 不负责编排下游角色
- 只有协调器类 skill 可以描述下游协同
- 若 skill 行为边界变化，必须重新生成派生 agent
