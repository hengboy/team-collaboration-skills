# 5 分钟快速上手

## 你只需要记住 3 件事

1. 默认模式是 `single-repo`，在业务仓直接配置 `skills` / `subagents` 就能上手
2. Feature 入口走 `product-manager` → `feature-coordinator`，Bug 入口直接走 `bug-coordinator`
3. 需要跨仓时，在 `.collaboration/shared/workspace.md` 显式声明 `split-repo`；此时 Feature 联合评审通过后只提示提交并推送协作文档，不提示进入 `frontend` / `backend-*`

## 先放一个仓库级配置

把下面的内容保存到 `.collaboration/shared/workspace.md`：

```markdown
---
workspace_mode: single-repo
---
```

如需启用分仓协作，把值改成 `split-repo` 即可。

## 最短路径

### Feature

```text
skill(name: product-manager)

请帮我创建手机号登录功能的 PRD。
```

接着：

```text
skill(name: feature-coordinator)

请继续负责手机号登录功能的协调工作。

## PRD
@.collaboration/features/mobile-login/prd.md

## 协同要求
- 读取 `.collaboration/shared/workspace.md`，缺失时默认按 `single-repo` 处理
- 首轮并行调用 @project-manager、@tech-lead 和 @frontend-design
- @tech-lead 不需要等待 `.collaboration/features/mobile-login/plan.md`
- @frontend-design 直接基于 `.collaboration/features/mobile-login/prd.md` 开始
- 首轮需先补齐 `.collaboration/features/mobile-login/plan.md`、`.collaboration/features/mobile-login/tech.md`、`.collaboration/features/mobile-login/api.yaml`、`.collaboration/features/mobile-login/design.md`、`.collaboration/features/mobile-login/design-components.md`
- 每轮先汇总结果，再问我是“通过”还是“继续澄清/修订”
- 如果 `workspace_mode` 是 `split-repo`，联合评审通过后只提示我是否提交并推送当前协作文档，不进入 `frontend` / `backend-*`
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
- handoff 必须保留；`single-repo` 下由当前仓实现角色消费，`split-repo` 下交给外部业务仓消费
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
4. Bug 场景始终先产出 handoff；`single-repo` 由当前仓实现，`split-repo` 由外部业务仓实现
5. `split-repo` 的 Feature 联合评审通过后，先决定是否提交并推送协作文档，再结束当前协作会话

### 不应该做的

1. 跳过 skill，直接让模型凭空生成完整流程
2. 混用 Feature 与 Bug 两套工作项目录
3. 在 `split-repo` 的协作仓里直接写 Feature 或 Bug 业务代码
4. 在需要跨仓时省略 `.collaboration/shared/workspace.md` 的 `split-repo` 声明
5. 手动编辑 `.claude/.gemini/.opencode/.codex` 生成物

## 下一步

- [README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/README.md)
- [skills/README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/skills/README.md)
- [docs/workspace-modes.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/workspace-modes.md)
- [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)
- [docs/ai-tool-configs.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/ai-tool-configs.md)
