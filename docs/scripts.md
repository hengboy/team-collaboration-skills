# 仓库脚本说明

本仓库当前维护 3 个一线脚本，分别负责 skill / agent 对齐、平台运行时生成，以及全量校验。

## 脚本总览

| 脚本 | 用途 | 常见场景 |
|------|------|----------|
| `./scripts/sync-skill-agent.sh` | 校验 skill 与 agent 的主章节、强制约束是否一致 | 改了 `skills/` 或 `agents/` 后先本地校验 |
| `./scripts/sync-platform-adapters.sh` | 从 `skills/` 与 `agents/` 生成各平台 runtime 文件 | 需要刷新 `.claude/.gemini/.opencode/.codex` 生成物 |
| `./scripts/verify-platform-adapters.sh` | 串联主校验、重生成、diff hygiene 与 runtime clean-tree 检查 | 提交前自检、CI 校验 |

## `sync-skill-agent.sh`

### 作用

- 校验存在同名 `skill` / `agent` 的角色是否仍保持一致。
- 直接比对主章节中的：
  - `### 必须输入`
  - `### 可选输入`
  - `### 输出文件`
  - `## 执行规则`
  - `## 质量检查`
  - `## 下一步流程`
- 精确比对 `## 强制约束` 和额外强制约束段落，例如：`技术栈`、`需求澄清机制`、`设计确认机制`、`设计原则`、`计划输出重点`。

### 何时使用

- 修改了 `skills/project-manager/SKILL.md`
- 修改了 `agents/tech-lead/AGENT.md`
- 调整了输入输出路径、强制约束或下一步流转

### 使用示例

检查全部 agent：

```bash
./scripts/sync-skill-agent.sh
```

只检查一个角色：

```bash
./scripts/sync-skill-agent.sh tech-lead
```

## `sync-platform-adapters.sh`

### 作用

- 从 `skills/` 复制生成 Claude / Gemini 的 skill runtime 副本。
- 从 `agents/` 生成 Claude / Gemini / OpenCode / Codex 的 agent runtime 文件。
- 所有生成物都带来源注释，且使用临时文件写入后再原子替换。

### 默认行为

- 默认只同步 agents。
- skills 只在显式指定时同步到 `.claude/skills/` 和 `.gemini/skills/`。

### 使用示例

只刷新 agent 生成物：

```bash
./scripts/sync-platform-adapters.sh --agents-only
```

同时刷新 skills 与 agents：

```bash
./scripts/sync-platform-adapters.sh --with-skills
```

只刷新 skills：

```bash
./scripts/sync-platform-adapters.sh --skills-only
```

查看帮助：

```bash
./scripts/sync-platform-adapters.sh --help
```

## `verify-platform-adapters.sh`

### 作用

按固定顺序执行完整校验：

1. 运行 `./scripts/sync-skill-agent.sh`
2. 运行 `./scripts/sync-platform-adapters.sh --with-skills`
3. 检查 `.claude/.gemini/.opencode/.codex` 中应存在的 runtime 文件
4. 运行 `git diff --check`
5. 检查 runtime 目录是否仍有未提交或未跟踪变更

### 何时使用

- 提交前最后自检
- 更新平台生成物后检查是否漏提交
- CI / PR 中做统一验证

### 使用示例

本地提交前跑一遍：

```bash
./scripts/verify-platform-adapters.sh
```

常见工作流：

```bash
./scripts/sync-skill-agent.sh
./scripts/sync-platform-adapters.sh --with-skills
git diff --check
./scripts/verify-platform-adapters.sh
```

### 注意事项

- 该脚本会主动刷新 runtime 生成物，因此在未提交前通常会把问题定位到 dirty-tree gate。
- 如果它最后提示 `.claude/.gemini/.opencode/.codex` 仍然有变更，含义通常不是“脚本失败”，而是“生成物需要一并提交”。

## 推荐顺序

日常修改建议按这个顺序执行：

```bash
./scripts/sync-skill-agent.sh
./scripts/sync-platform-adapters.sh --with-skills
git diff --check
./scripts/verify-platform-adapters.sh
```

## 相关文档

- [README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/README.md)
- [QUICKSTART.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/QUICKSTART.md)
- [docs/platform-runtime-adapters.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/platform-runtime-adapters.md)
- [docs/skill-agent-sync-guide.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/skill-agent-sync-guide.md)
