# bug-coordinator - Claude 使用示例

## 配置

```bash
mkdir -p ~/.claude/skills ~/.claude/agents
cp skills/bug-coordinator/SKILL.md ~/.claude/skills/
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
先补齐 `.collaboration/bugs/payment-submit-500/bug.md`，并默认使用 tech-lead subagent 产出 `fix-plan.md`。
如果判断是联调 / 接口边界缺陷，请分别生成 `frontend-handoff.md` 和 `backend-handoff.md`，交给前后端业务仓消费。
业务仓回传 PR、测试结果和变更摘要后，再统一进入 qa-engineer 和 code-reviewer。
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
