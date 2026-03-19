# frontend-design - OpenCode 使用示例

## 推荐方式：由 master-coordinator 调用 subagent

```bash
opencode

skill(name: master-coordinator)

请继续协调 mobile-login。
并行调用 @project-manager 和 @tech-lead，其中 @tech-lead 不需要等待 plan.md。
每轮结果先由你汇总，再问我是“通过”还是“继续澄清/修订”。
需要前端设计时再调用 @frontend-design，后续评审修订继续回派给 @frontend-design。

## PRD
@.collaboration/features/mobile-login/prd.md

## API 契约
@.collaboration/features/mobile-login/api.yaml

## 设计要求
- 移动端优先
- 支持深色模式
- 无障碍访问 WCAG 2.1 AA
- 配色方案：品牌蓝色 (#1890ff)
- 性能要求：Lighthouse > 90
```

说明：

- `frontend-design` 在联合评审链路中应作为 subagent 运行
- 每轮设计结果先回到 `master-coordinator`，由协调器向用户询问“通过”还是“继续澄清/修订”
- 不建议在协调链路里直接切成 `skill(name: frontend-design)`

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
