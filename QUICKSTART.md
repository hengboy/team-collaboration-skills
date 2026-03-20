# 5 分钟快速上手

## 你只需要记住 3 件事

1. Feature 入口走 `product-manager` → `feature-coordinator`
2. Bug 入口直接走 `bug-coordinator`
3. 需要平台 runtime 时再跑脚本，不要先手改 `.claude/.gemini/.opencode/.codex`

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
- 首轮并行调用 @project-manager、@tech-lead 和 @frontend-design
- @tech-lead 不需要等待 `.collaboration/features/mobile-login/plan.md`
- @frontend-design 直接基于 `.collaboration/features/mobile-login/prd.md` 开始
- 首轮需先补齐 `.collaboration/features/mobile-login/plan.md`、`.collaboration/features/mobile-login/tech.md`、`.collaboration/features/mobile-login/api.yaml`、`.collaboration/features/mobile-login/design.md`、`.collaboration/features/mobile-login/design-components.md`
- 每轮先汇总结果，再问我是“通过”还是“继续澄清/修订”
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
- 先补齐 `.collaboration/bugs/payment-submit-500/bug.md`
- 默认调用 @tech-lead 的 Bug 模式产出 `.collaboration/bugs/payment-submit-500/fix-plan.md`
- 如需设计修订，可按需调用 @frontend-design 产出 `.collaboration/bugs/payment-submit-500/design-change.md`
- 如需节奏规划，可按需调用 @project-manager 产出 `.collaboration/bugs/payment-submit-500/execution-plan.md`
- 如判定为联调缺陷，分别生成 `.collaboration/bugs/payment-submit-500/frontend-handoff.md` 和 `.collaboration/bugs/payment-submit-500/backend-handoff.md`
```

## 产物速查

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

最常用的 3 条命令：

```bash
./scripts/sync-skill-agent.sh
./scripts/sync-platform-adapters.sh --with-skills
./scripts/verify-platform-adapters.sh
```

## 最佳实践

### 应该做的

1. 直接用 `skill(name: xxx)` 调用主链路角色
2. 用 `@.collaboration/...` 引用上下文文档
3. 让 `feature-coordinator` / `bug-coordinator` 负责协同，不手搓文档流转
4. Bug 场景先产出 handoff，再由业务仓各自编码
5. 业务仓回传结果后，再回协作仓做 QA / Review / Commit

### 不应该做的

1. 跳过 skill，直接让模型凭空生成完整流程
2. 混用 Feature 与 Bug 两套工作项目录
3. 在协作仓直接写 Bug 业务代码
4. 手动编辑 `.claude/.gemini/.opencode/.codex` 生成物

## 下一步

- [README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/README.md)
- [skills/README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/skills/README.md)
- [docs/scripts.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/scripts.md)
- [docs/ai-tool-configs.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/ai-tool-configs.md)
