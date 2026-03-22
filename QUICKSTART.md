# 5 分钟快速上手

## 你只需要记住 3 件事

1. 推荐先用 `single-repo`，首次调用 `product-manager` 时会先用结构化选项确认 `workspace_mode`；支持选择框的平台可直接勾选，Codex CLI 等不支持的平台直接回复关键词
2. Feature 入口走 `product-manager` → `feature-coordinator`，Bug 入口直接走 `bug-coordinator`
3. 需要跨仓时把 `workspace_mode` 设为 `split-repo`；可以预先写入 `.collaboration/shared/workspace.md`，也可以让 `product-manager` 首次运行时确认后创建

## 可选：先放一个仓库级配置

如果你想省掉首轮询问，可以先把下面的内容保存到 `.collaboration/shared/workspace.md`：

```markdown
---
workspace_mode: {workspace_mode}
---

# Workspace Mode

本仓库当前以 `{workspace_mode}` 方式运行。

- `single-repo`：当前仓同时承载 `.collaboration/` 协作文档和真实业务代码。Feature 联合评审通过后，可直接在当前仓进入 `frontend` / `backend-*`；Bug 仍先产出 handoff，但由当前仓实现角色消费。
- `split-repo`：当前仓是协作仓，真实业务代码位于外部业务仓。Feature 联合评审通过后，由 `feature-coordinator` 用结构化选项提示是否提交并推送当前协作文档，并允许填写补充意见；支持选择框的平台可直接勾选，Codex CLI 等不支持的平台直接回复关键词，不在协作仓直接进入实现类 skill；Bug handoff 交给外部业务仓消费。

工作项模式解析顺序：

1. 当前工作项文档 frontmatter 中的 `workspace_mode`
2. 本文件 `.collaboration/shared/workspace.md`
3. 默认值 `single-repo`

如需切换工作空间模式，请将本文件中的 `workspace_mode` 更新为 `single-repo` 或 `split-repo`，并提交到仓库。
```

如果你想预先创建这个文件，请把 `{workspace_mode}` 替换为 `single-repo` 或 `split-repo` 后再保存；如果先不创建，首次调用 `product-manager` 时会先用结构化选项询问 `workspace_mode`（仅允许 `single-repo` / `split-repo`，并允许填写补充意见）；支持选择框的平台可直接勾选，Codex CLI 等不支持的平台直接回复关键词，确认后自动创建该文件。

## 最短路径

### Feature

```text
skill(name: product-manager)

请帮我创建手机号登录功能的 PRD。
```

`product-manager` 首轮会先检查 `.collaboration/shared/workspace.md`：若文件存在，会先用下面的结构化选项确认是否沿用当前值：

```text
- [ ] 继续沿用当前 workspace_mode: {value}
- [ ] 改为 single-repo
- [ ] 改为 split-repo
Codex CLI 可直接回复：继续沿用当前 workspace_mode / single-repo / split-repo
补充意见：____
```

若文件不存在，则会先用下面的结构化选项确认 `workspace_mode`，确认后创建该文件，再进入需求澄清：

```text
- [ ] single-repo
- [ ] split-repo
Codex CLI 可直接回复：single-repo / split-repo
补充意见：____
```

接着：

```text
skill(name: feature-coordinator)

请继续负责手机号登录功能的协调工作。

## PRD
@.collaboration/features/mobile-login/prd.md

## 协同要求
- 读取 `.collaboration/shared/workspace.md`，并与 `.collaboration/features/mobile-login/prd.md` frontmatter 中的 `workspace_mode` 保持一致
- 首轮并行调用 @project-manager、@tech-lead 和 @frontend-design；若 `workspace_mode` 为 `single-repo`，启动后立即检查三者状态，任一未成功启动则立刻重启，直到三者并行运行
- @tech-lead 不需要等待 `.collaboration/features/mobile-login/plan.md`
- @frontend-design 直接基于 `.collaboration/features/mobile-login/prd.md` 开始
- 首轮需先补齐 `.collaboration/features/mobile-login/plan.md`、`.collaboration/features/mobile-login/tech.md`、`.collaboration/features/mobile-login/api.yaml`、`.collaboration/features/mobile-login/design.md`、`.collaboration/features/mobile-login/design-components.md`
- 每轮先汇总结果，再用结构化选项问我是“通过”还是“继续澄清/修订”，并允许填写补充意见；支持选择框的平台可直接勾选，Codex CLI 等不支持的平台直接回复关键词
- 如果 `workspace_mode` 是 `single-repo` 且联合评审通过，由你并行调用 @frontend 和对应 @backend-*，实现证据齐备后再串行调用 @qa-engineer、@code-reviewer
- 如果 `workspace_mode` 是 `split-repo`，联合评审通过后只用结构化选项提示我是否提交并推送当前协作文档，并允许填写补充意见；支持选择框的平台可直接勾选，Codex CLI 等不支持的平台直接回复关键词，不进入 `frontend` / `backend-*`
```

### Bug

```text
skill(name: bug-coordinator)

请继续协调支付确认页点击“立即支付”后返回 500 的缺陷修复。

## 原始问题
- 环境：生产环境
- 首次发现：2026-03-20 09:45 CST
- 影响版本：web 2.8.4 / api 3.1.7
- 现象：支付确认页点击“立即支付”后返回 500
- 证据：Sentry issue、Nginx 错误日志、客服反馈截图

## 要求
- 读取 `.collaboration/shared/workspace.md`，缺失时默认按 `single-repo` 处理
- 先补齐 `.collaboration/bugs/payment-submit-500/bug.md`
- 默认调用 @tech-lead 的 Bug 模式产出 `.collaboration/bugs/payment-submit-500/fix-plan.md`
- 如需设计修订，可按需调用 @frontend-design 产出 `.collaboration/bugs/payment-submit-500/design-change.md`
- 如需节奏规划，可按需调用 @project-manager 产出 `.collaboration/bugs/payment-submit-500/execution-plan.md`
- 如判定为联调缺陷，分别生成 `.collaboration/bugs/payment-submit-500/frontend-handoff.md` 和 `.collaboration/bugs/payment-submit-500/backend-handoff.md`
- handoff 必须保留；`single-repo` 下由你并行调用命中的实现 subagent 消费，之后再串行调用 @qa-engineer、@code-reviewer；`split-repo` 下交给外部业务仓消费
```

## 产物速查

### 仓库级配置

- `.collaboration/shared/workspace.md`

### Feature 产物

- `.collaboration/features/{feature-name}/prd.md`
- `.collaboration/features/{feature-name}/plan.md`
- `.collaboration/features/{feature-name}/tech.md`
- `.collaboration/features/{feature-name}/api.yaml`
- `.collaboration/features/{feature-name}/design.md`
- `.collaboration/features/{feature-name}/design-components.md`
- `.collaboration/features/{feature-name}/review.md`
- `.collaboration/features/{feature-name}/test-cases.md`
- `.collaboration/features/{feature-name}/qa-report.md`（可选）
- `.collaboration/features/{feature-name}/code-review.md`
- `.collaboration/features/{feature-name}/security-review.md`（可选）

### Bug 产物

- `.collaboration/bugs/{bug-name}/bug.md`
- `.collaboration/bugs/{bug-name}/fix-plan.md`
- `.collaboration/bugs/{bug-name}/design-change.md`
- `.collaboration/bugs/{bug-name}/execution-plan.md`
- `.collaboration/bugs/{bug-name}/frontend-handoff.md`
- `.collaboration/bugs/{bug-name}/backend-handoff.md`
- `.collaboration/bugs/{bug-name}/test-cases.md`
- `.collaboration/bugs/{bug-name}/qa-report.md`
- `.collaboration/bugs/{bug-name}/code-review.md`
- `.collaboration/bugs/{bug-name}/security-review.md`（可选）

## 脚本速查

脚本详解见 [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)。

最常用的 4 条命令：

```bash
./scripts/generate-agents-from-skills.sh
./scripts/sync-skill-agent.sh
./scripts/sync-platform-adapters.sh --with-skills
./scripts/verify-platform-adapters.sh
```

## 最佳实践

### 应该做的

1. 直接用 `skill(name: xxx)` 调用主链路角色
2. 用 `@.collaboration/...` 引用上下文文档
3. 让 `feature-coordinator` / `bug-coordinator` 负责协同，不手搓文档流转
4. `single-repo` 正式链路里，让协调器负责调度实现、QA、Review subagents；`split-repo` 再按需直接调用目标业务仓 skill
5. Bug 场景始终先产出 handoff；`single-repo` 由当前仓实现 subagent 消费，`split-repo` 由外部业务仓实现
6. `split-repo` 的 Feature 联合评审通过后，先用结构化选项决定是否提交并推送协作文档；支持选择框的平台可直接勾选，Codex CLI 等不支持的平台直接回复关键词，再结束当前协作会话

### 不应该做的

1. 跳过 skill，直接让模型凭空生成完整流程
2. 混用 Feature 与 Bug 两套工作项目录
3. 在 `split-repo` 的协作仓里直接写 Feature 或 Bug 业务代码
4. 在需要跨仓时绕过 `product-manager` 的 `workspace_mode` 确认，或省略 `.collaboration/shared/workspace.md` 的 `split-repo` 声明
5. 手动编辑 `.claude/.gemini/.opencode/.codex` 生成物

## 下一步

- [README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/README.md)
- [skills/README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/skills/README.md)
- [docs/workspace-modes.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/workspace-modes.md)
- [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)
- [docs/ai-tool-configs.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/ai-tool-configs.md)
