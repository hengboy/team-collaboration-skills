# backend-typescript - OpenCode 使用示例

## Feature 模式

```bash
opencode

skill(name: backend-typescript)

请实现当前 Feature 的后端功能。
先根据输入路径确认唯一 feature-name，并识别 TypeScript 后端源码路径与测试路径。
禁止把实现代码写到任何 .collaboration/ 工作项目录。
实现完成后，必须执行仓库现有的代码质量、语法/类型或构建、测试与缺陷检查，并汇总实际执行命令、结果与剩余阻塞。

## API 契约
@.collaboration/features/{feature-name}/api.yaml

## 技术方案
@.collaboration/features/{feature-name}/tech.md
```

## Bug 模式

```bash
opencode

skill(name: backend-typescript)

请基于 handoff 文档完成当前 Bug 的后端修复。
先根据输入路径确认唯一 bug-name，并识别 TypeScript 后端源码路径与测试路径。
只在 `.collaboration/bugs/{bug-name}/backend-handoff.md` 指定的边界内修复；如果发现修复超出边界，请停止并回到 bug-coordinator。
禁止把实现代码写到任何 .collaboration/ 工作项目录。
实现完成后，必须执行仓库现有的代码质量、语法/类型或构建、测试与缺陷检查，并汇总实际执行命令、结果与剩余阻塞。

## Handoff
@.collaboration/bugs/{bug-name}/backend-handoff.md

## Bug
@.collaboration/bugs/{bug-name}/bug.md

## Fix Plan
@.collaboration/bugs/{bug-name}/fix-plan.md
```
