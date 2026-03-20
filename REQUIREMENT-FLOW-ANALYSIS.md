# 协作链路深度分析

**更新日期**: 2026-03-20
**分析对象**: 当前仓库实际生效的 Feature / Bug 双主链路
**版本基线**: v8.0.0

## 一、结论速览

当前仓库已经不是早期那种“单条需求流转线”，而是两条并行存在、边界明确的主链路：

- Feature 链路：`product-manager` -> `feature-coordinator` -> `project-manager` / `tech-lead` / `frontend-design` -> 实现 -> QA -> Review -> Commit
- Bug 链路：`bug-coordinator` -> `tech-lead`（默认）-> `frontend-design` / `project-manager`（按需）-> handoff -> 业务仓实现 -> QA -> Review -> Commit

与旧版本相比，当前实现有 5 个关键变化：

1. `bug-coordinator` 已经成为独立主入口，不再依附 Feature 链路。
2. `project-manager`、`tech-lead`、`frontend-design` 在协同链路中优先作为 subagent，但也允许直接以 skill 单独调用。
3. Skill 与 Agent 的同步不再依赖额外“核心契约”摘要块，而是直接对齐主章节与强制约束。
4. 协作文档路径统一为完整模板，避免只写文件名而不写 `.collaboration/...` 完整路径造成歧义。
5. 平台运行时由脚本统一生成，默认只同步 agents；skills 只在显式指定时同步到 Claude / Gemini runtime。

## 二、事实源与派生层

当前仓库的三层结构如下：

```text
skills/                  # Skill 事实源
agents/                  # Subagent 逻辑源
.claude/.gemini/.opencode/.codex/   # 各平台 runtime 生成物
```

对应关系：

- `skills/{name}/SKILL.md` 是角色事实源
- `agents/{name}/AGENT.md` 是同名 subagent 的精简逻辑源
- `.claude/.gemini/.opencode/.codex` 中的内容都属于生成物，不直接手写维护

当前脚本实际校验的是：

- `### 必须输入`
- `### 可选输入`
- `### 输出文件`
- `## 执行规则`
- `## 质量检查`
- `## 下一步流程`
- `## 强制约束` 以及 skill 中声明的其他强制约束段落

这意味着“真正约束运行行为的内容”已经集中到了主章节，而不是额外的摘要块。

## 三、Feature 主链路

### 实际流程

```text
原始需求
  -> product-manager
  -> feature-coordinator
    -> project-manager subagent
    -> tech-lead subagent
    -> frontend-design subagent
  -> 联合评审
  -> frontend / backend-*
  -> qa-engineer
  -> code-reviewer
  -> git-commit
```

### 关键机制

- `product-manager` 先产出 `.collaboration/features/{feature-name}/prd.md`
- `feature-coordinator` 保留在主会话，不把主链路切走
- `project-manager`、`tech-lead`、`frontend-design` 首轮并行
- `tech-lead` 可以直接基于 `.collaboration/features/{feature-name}/prd.md` 开始，不等待 `.collaboration/features/{feature-name}/plan.md`
- `frontend-design` 可以直接基于 `.collaboration/features/{feature-name}/prd.md` 开始，不等待 `.collaboration/features/{feature-name}/tech.md` 或 `.collaboration/features/{feature-name}/api.yaml` 作为启动前置
- 但在用户可见的首轮正式评审前，必须已经回收：
  - `.collaboration/features/{feature-name}/plan.md`
  - `.collaboration/features/{feature-name}/tech.md`
  - `.collaboration/features/{feature-name}/api.yaml`
  - `.collaboration/features/{feature-name}/design.md`
  - `.collaboration/features/{feature-name}/design-components.md`

### Feature 产物矩阵

| 角色 | 主要输出 |
|------|----------|
| `product-manager` | `.collaboration/features/{feature-name}/prd.md` |
| `project-manager` | `.collaboration/features/{feature-name}/plan.md` |
| `tech-lead` | `.collaboration/features/{feature-name}/tech.md`、`.collaboration/features/{feature-name}/api.yaml` |
| `frontend-design` | `.collaboration/features/{feature-name}/design.md`、`.collaboration/features/{feature-name}/design-components.md` |
| `feature-coordinator` | `.collaboration/features/{feature-name}/review.md` |
| `qa-engineer` | `.collaboration/features/{feature-name}/test-cases.md`、`.collaboration/features/{feature-name}/qa-report.md`（可选） |
| `code-reviewer` | `.collaboration/features/{feature-name}/code-review.md`、`.collaboration/features/{feature-name}/security-review.md`（可选） |

### 当前边界判断

- 协作仓只负责文档、评审、收口，不直接承担业务实现
- `frontend`、`backend-typescript`、`backend-springboot` 在业务仓消费协作文档并实现
- Feature 实现阶段使用的是完整文档路径，不应再回退成裸文件名口径

## 四、Bug 主链路

### 实际流程

```text
报警 / issue / 用户反馈 / 日志
  -> bug-coordinator
    -> tech-lead subagent
    -> frontend-design subagent (optional)
    -> project-manager subagent (optional)
  -> frontend-handoff / backend-handoff
  -> 业务仓实现
  -> qa-engineer
  -> code-reviewer
  -> git-commit
```

### 关键机制

- `bug-coordinator` 先补齐 `.collaboration/bugs/{bug-name}/bug.md`
- `tech-lead` 默认参与，并输出 `.collaboration/bugs/{bug-name}/fix-plan.md`
- `frontend-design` 只在 UI / 交互 / 组件边界 / 文案变化时参与，输出 `.collaboration/bugs/{bug-name}/design-change.md`
- `project-manager` 只在跨团队、分阶段发布、资源冲突或需要节奏规划时参与，输出 `.collaboration/bugs/{bug-name}/execution-plan.md`
- `bug-coordinator` 负责判定：
  - 前端缺陷：只生成 `.collaboration/bugs/{bug-name}/frontend-handoff.md`
  - 后端缺陷：只生成 `.collaboration/bugs/{bug-name}/backend-handoff.md`
  - 联调 / 接口边界缺陷：两份 handoff 都生成

### Bug 产物矩阵

| 角色 | 主要输出 |
|------|----------|
| `bug-coordinator` | `.collaboration/bugs/{bug-name}/bug.md`、handoff 文档 |
| `tech-lead` | `.collaboration/bugs/{bug-name}/fix-plan.md` |
| `frontend-design` | `.collaboration/bugs/{bug-name}/design-change.md` |
| `project-manager` | `.collaboration/bugs/{bug-name}/execution-plan.md` |
| `qa-engineer` | `.collaboration/bugs/{bug-name}/test-cases.md`、`.collaboration/bugs/{bug-name}/qa-report.md` |
| `code-reviewer` | `.collaboration/bugs/{bug-name}/code-review.md`、`.collaboration/bugs/{bug-name}/security-review.md`（可选） |

### 当前边界判断

- Bug 链路的“实现输入”是 handoff，而不是直接把协作仓当业务仓改代码
- `frontend` 只消费 `.collaboration/bugs/{bug-name}/frontend-handoff.md`
- `backend-*` 只消费 `.collaboration/bugs/{bug-name}/backend-handoff.md`
- 如果修复已经演变成接口重设或新增能力，当前缺陷链路应停止，并回退到 Feature 链路

## 五、Skill 与 Subagent 的真实关系

当前设计不是“skill 和 subagent 二选一”，而是双模式共存：

- 主链路角色优先保留为 skill：`product-manager`、`feature-coordinator`、`bug-coordinator`
- 并行分析角色优先作为 subagent：`project-manager`、`tech-lead`、`frontend-design`
- 实现与收口角色继续作为 skill：`frontend`、`backend-*`、`qa-engineer`、`code-reviewer`、`git-commit`

同时，`project-manager`、`tech-lead`、`frontend-design` 现在允许直接调用 skill：

- 协同链路里，优先由协调器调度
- 非协同链路里，可以直接独立运行
- 只有在协调器发起调用时，结果才需要先回传协调器

这比“必须始终作为 subagent”更贴近真实使用场景。

## 六、工作项识别规则

当前仓库已经统一采用“路径优先、frontmatter 兜底”的识别策略：

1. 优先从输入路径提取 `.collaboration/features/{feature-name}/...` 或 `.collaboration/bugs/{bug-name}/...`
2. 路径缺失时，再读取 frontmatter 的 `feature:` 或 `bug:`
3. 两者同时存在时必须一致
4. 同一次调用里混入 Feature 与 Bug 两套工作目录时，相关角色必须停止并要求上游统一上下文

这条规则直接影响所有实现类 skill 和双模式角色，是当前流程稳定性的核心之一。

## 七、多仓职责边界

当前仓库采用的是“协作仓 + 业务仓”分工，而不是把全部工作都塞进一个仓库：

- 协作仓：文档、判责、评审、收口
- 业务仓：真实代码、真实测试、构建、发布

因此有两个硬边界：

1. `.collaboration/` 里只放协作文档，不放实现代码和测试代码
2. Bug 修复在业务仓执行，协作仓只输出 handoff、测试资产和评审结论

这也是为什么多个实现类 skill 都明确写了“禁止把代码和测试写入 `.collaboration/`”。

## 八、脚本与运行时适配

当前实际存在、并且应该写进维护流程的脚本只有 3 个：

```bash
./scripts/sync-skill-agent.sh
./scripts/sync-platform-adapters.sh --with-skills
./scripts/verify-platform-adapters.sh
```

它们分别负责：

- `sync-skill-agent.sh`：检查 skill / agent 的主章节和强制约束是否一致
- `sync-platform-adapters.sh`：从 `skills/`、`agents/` 生成平台 runtime
- `verify-platform-adapters.sh`：串联校验、重生成、diff hygiene 和 runtime clean-tree gate

当前没有额外的 `sync-collab.sh`、版本冻结流程或 Gitea 发布链路。

## 九、容易混淆但已经明确的问题

### 1. “核心契约（供 AGENT 派生）”还存在吗？

不存在了。当前同步脚本直接对齐主章节和强制约束，不再维护重复摘要块。

### 2. `project-manager`、`tech-lead`、`frontend-design` 只能作为 subagent 吗？

不是。它们在协同链路里优先作为 subagent，但也允许直接调用对应 skill。

### 3. 裸文件名还可以继续写吗？

不推荐。当前文档体系已经统一改成完整路径模板，例如：

- `.collaboration/features/{feature-name}/plan.md`
- `.collaboration/features/{feature-name}/design.md`
- `.collaboration/bugs/{bug-name}/fix-plan.md`

### 4. 为什么 README 里要列出 `.collaboration/features/{feature-name}/qa-report.md`、`.collaboration/features/{feature-name}/security-review.md` 这类可选产物？

因为它们属于真实存在的约定路径。即便不是每个工作项都生成，文档体系也需要统一它们的落点。

## 十、总体判断

当前仓库的流程已经从“概念验证”走到了“可维护的事实源体系”：

- 角色边界更清晰
- 平台适配有统一脚本
- Skill / Agent 有明确同步规则
- Feature / Bug 双链路不再互相挤压
- 多仓协作边界也已经明确下来

接下来最重要的不是再加新流程，而是继续保持三件事：

1. 文档始终与事实源同步
2. 示例始终使用完整路径模板
3. 生成物始终通过脚本刷新并一并提交
