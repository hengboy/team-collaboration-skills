# bug-coordinator - OpenCode 使用示例

## 推荐方式：在协作仓中作为独立 Bug 主链路入口

```bash
opencode

skill(name: bug-coordinator)

请继续协调支付确认页点击“立即支付”后返回 500 的缺陷修复。

## 原始问题
- 环境：生产环境
- 首次发现：2026-03-20 09:45 CST
- 影响版本：web 2.8.4 / api 3.1.7
- 用户影响：支付确认页无法完成下单，影响核心转化
- 证据：Sentry issue、Nginx 错误日志、客服反馈截图

## 要求
- 先补齐 `.collaboration/bugs/payment-submit-500/bug.md`
- 默认调用 @tech-lead 的 Bug 模式产出 `.collaboration/bugs/payment-submit-500/fix-plan.md`
- 如果修复涉及 UI / 交互调整，可按需调用 @frontend-design 的 Bug 模式产出 `.collaboration/bugs/payment-submit-500/design-change.md`
- 如果修复涉及分阶段发布或跨团队协调，可按需调用 @project-manager 的 Bug 模式产出 `.collaboration/bugs/payment-submit-500/execution-plan.md`
- 如果判定为联调 / 接口边界问题，分别生成 `.collaboration/bugs/payment-submit-500/frontend-handoff.md` 和 `.collaboration/bugs/payment-submit-500/backend-handoff.md`
- 业务仓回传 PR、测试结果和变更摘要后，再统一进入 `qa-engineer` 和 `code-reviewer`
- 如果识别到这不是缺陷而是新增需求，请提示我回到 `product-manager`
```

说明：

- `bug-coordinator` 保持在当前主会话，不切走到实现角色
- 交接文档产出在 `.collaboration/bugs/{bug-name}/`
- 前后端业务仓各自拉取 handoff 文档并实现修复

## 完整示例

详见 README.md 与 QUICKSTART.md 中的 Bug 协同链路说明。
