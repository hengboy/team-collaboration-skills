# frontend - OpenCode 使用示例

## Feature 模式

```bash
opencode

skill(name: frontend)

请完成当前 Feature 的前端实现。
先读取 `.collaboration/shared/workspace.md`，缺失时默认按 `single-repo` 处理。
如果 `workspace_mode` 是 `split-repo`，确认当前仓是目标业务仓，而不是协作仓。
先根据输入路径确认唯一 feature-name，并识别真实源码路径与测试路径。
禁止把实现代码写到任何 .collaboration/ 工作项目录。
实现完成后，必须执行仓库现有的代码质量、语法/类型或构建、测试与缺陷检查，并汇总实际执行命令、结果与剩余阻塞。

## 设计方案
@.collaboration/features/{feature-name}/design.md

## 组件契约
@.collaboration/features/{feature-name}/design-components.md

## API 契约
@.collaboration/features/{feature-name}/api.yaml
```

## Bug 模式

```bash
opencode

skill(name: frontend)

请基于 handoff 文档完成当前 Bug 的前端修复。
先读取 `.collaboration/shared/workspace.md`，缺失时默认按 `single-repo` 处理。
如果 `workspace_mode` 是 `split-repo`，确认当前仓是目标业务仓，而不是协作仓。
先根据输入路径确认唯一 bug-name，并识别真实源码路径与测试路径。
只在 `.collaboration/bugs/{bug-name}/frontend-handoff.md` 指定的边界内修复；如果发现修复超出边界，请停止并回到 bug-coordinator。
禁止把实现代码写到任何 .collaboration/ 工作项目录。
实现完成后，必须执行仓库现有的代码质量、语法/类型或构建、测试与缺陷检查，并汇总实际执行命令、结果与剩余阻塞。

## Handoff
@.collaboration/bugs/{bug-name}/frontend-handoff.md

## Bug
@.collaboration/bugs/{bug-name}/bug.md

## Fix Plan
@.collaboration/bugs/{bug-name}/fix-plan.md
```
