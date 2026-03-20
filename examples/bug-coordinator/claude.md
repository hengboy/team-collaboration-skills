# bug-coordinator - Claude 使用示例

默认 `workspace_mode` 为 `single-repo`；如当前仓是协作仓，请先在 `.collaboration/shared/workspace.md` 中显式声明 `workspace_mode: split-repo`。

## 配置

```bash
mkdir -p ~/.claude/skills ~/.claude/agents
cp -R skills/bug-coordinator ~/.claude/skills/
cp .claude/agents/tech-lead.md ~/.claude/agents/
cp .claude/agents/frontend-design.md ~/.claude/agents/
cp .claude/agents/project-manager.md ~/.claude/agents/
```

## 使用方式

```bash
claude
```

在对话中：

```
请保持当前会话作为 bug-coordinator。
先读取 `.collaboration/shared/workspace.md`，缺失时默认按 `single-repo` 处理。
先补齐 `.collaboration/bugs/payment-submit-500/bug.md`，并默认使用 tech-lead subagent 的 Bug 模式产出 `.collaboration/bugs/payment-submit-500/fix-plan.md`。
如果修复涉及 UI / 交互调整，可按需使用 frontend-design subagent 的 Bug 模式产出 `.collaboration/bugs/payment-submit-500/design-change.md`。
如果修复涉及分阶段发布或跨团队协调，可按需使用 project-manager subagent 的 Bug 模式产出 `.collaboration/bugs/payment-submit-500/execution-plan.md`。
如果判断是联调 / 接口边界缺陷，请分别生成 `.collaboration/bugs/payment-submit-500/frontend-handoff.md` 和 `.collaboration/bugs/payment-submit-500/backend-handoff.md`。
handoff 必须保留；`single-repo` 下由当前仓实现角色消费，`split-repo` 下交给外部业务仓消费。
回收到当前仓或业务仓的实现证据后，再统一进入 qa-engineer 和 code-reviewer。
如果识别到这不是缺陷而是新增需求，请直接提示我回到 product-manager。

## 原始问题
- 环境：生产环境
- 首次发现：2026-03-20 09:45 CST
- 影响版本：web 2.8.4 / api 3.1.7
- 现象：支付确认页点击“立即支付”后返回 500
- 证据：Sentry issue、Nginx 错误日志、客服反馈截图
```

## 完整示例

详见 README.md 与 QUICKSTART.md 中的 Bug 协同链路说明。
