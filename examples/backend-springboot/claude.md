# backend-springboot - Claude 使用示例

## 配置（首次使用）

```bash
mkdir -p ~/.claude/skills
cp -R skills/backend-springboot ~/.claude/skills/
```

## Feature 模式

```text
我使用 backend-springboot Skill。

请实现当前 Feature 的 Spring Boot 功能。
先读取 `.collaboration/shared/workspace.md`，缺失时默认按 `single-repo` 处理。
如果 `workspace_mode` 是 `split-repo`，确认当前仓是目标业务仓，而不是协作仓。
先根据输入路径或 frontmatter 确认唯一 feature-name，并识别 Spring Boot 源码路径、资源路径与测试路径。
禁止把实现代码写到任何 .collaboration/ 工作项目录。
实现完成后，必须执行仓库现有的代码质量、编译/构建、测试与缺陷检查，并汇总实际执行命令、结果与剩余阻塞。

## API 契约
{粘贴 .collaboration/features/{feature-name}/api.yaml 内容}

## 技术方案
{粘贴 .collaboration/features/{feature-name}/tech.md 内容}
```

## Bug 模式

```text
我使用 backend-springboot Skill。

请基于 handoff 文档完成当前 Bug 的 Spring Boot 修复。
先读取 `.collaboration/shared/workspace.md`，缺失时默认按 `single-repo` 处理。
如果 `workspace_mode` 是 `split-repo`，确认当前仓是目标业务仓，而不是协作仓。
先根据输入路径或 frontmatter 确认唯一 bug-name，并识别 Spring Boot 源码路径、资源路径与测试路径。
只在 `.collaboration/bugs/{bug-name}/backend-handoff.md` 指定的边界内修复；如果发现修复超出边界，请停止并回到 bug-coordinator。
禁止把实现代码写到任何 .collaboration/ 工作项目录。
实现完成后，必须执行仓库现有的代码质量、编译/构建、测试与缺陷检查，并汇总实际执行命令、结果与剩余阻塞。

## Handoff
{粘贴 .collaboration/bugs/{bug-name}/backend-handoff.md 内容}

## Bug
{粘贴 .collaboration/bugs/{bug-name}/bug.md 内容}

## Fix Plan
{粘贴 .collaboration/bugs/{bug-name}/fix-plan.md 内容}
```
