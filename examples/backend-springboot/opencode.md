# backend-springboot - OpenCode 使用示例

## Feature 模式

```bash
opencode

skill(name: backend-springboot)

请实现当前 Feature 的 Spring Boot 功能。
先读取 `.collaboration/shared/workspace.md`，缺失时默认按 `single-repo` 处理。
如果 `workspace_mode` 是 `single-repo`，先确保 `./backend/` 存在；若不存在就创建，并且后续只允许在该目录内识别 Spring Boot 源码路径、资源路径与测试路径。
如果 `workspace_mode` 是 `split-repo`，确认当前仓是目标业务仓，而不是协作仓。
先根据输入路径确认唯一 feature-name。
禁止把实现代码写到任何 .collaboration/ 工作项目录。
实现完成后，必须执行仓库现有的代码质量、编译/构建、测试与缺陷检查，并汇总实际执行命令、结果与剩余阻塞。

## API 契约
@.collaboration/features/{feature-name}/api.yaml

## 技术方案
@.collaboration/features/{feature-name}/tech.md
```

## Bug 模式

```bash
opencode

skill(name: backend-springboot)

请基于 handoff 文档完成当前 Bug 的 Spring Boot 修复。
先读取 `.collaboration/shared/workspace.md`，缺失时默认按 `single-repo` 处理。
如果 `workspace_mode` 是 `single-repo`，先确保 `./backend/` 存在；若不存在就创建，并且后续只允许在该目录内识别 Spring Boot 源码路径、资源路径与测试路径。
如果 `workspace_mode` 是 `split-repo`，确认当前仓是目标业务仓，而不是协作仓。
先根据输入路径确认唯一 bug-name。
只在 `.collaboration/bugs/{bug-name}/backend-handoff.md` 指定的边界内修复；如果发现修复超出边界，请停止并回到 bug-coordinator。
禁止把实现代码写到任何 .collaboration/ 工作项目录。
实现完成后，必须执行仓库现有的代码质量、编译/构建、测试与缺陷检查，并汇总实际执行命令、结果与剩余阻塞。

## Handoff
@.collaboration/bugs/{bug-name}/backend-handoff.md

## Bug
@.collaboration/bugs/{bug-name}/bug.md

## Fix Plan
@.collaboration/bugs/{bug-name}/fix-plan.md
```
