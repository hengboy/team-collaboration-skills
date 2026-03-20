# frontend - Claude 使用示例

## 配置

```bash
mkdir -p ~/.claude/skills
cp -R skills/frontend ~/.claude/skills/
```

## Feature 模式

```text
我使用 frontend Skill。

请完成当前 Feature 的前端实现。
先根据输入路径或 frontmatter 确认唯一 feature-name，并识别真实源码路径与测试路径。
禁止把实现代码写到任何 .collaboration/ 工作项目录。
实现完成后，必须执行仓库现有的代码质量、语法/类型或构建、测试与缺陷检查，并汇总实际执行命令、结果与剩余阻塞。

## 设计方案
{粘贴 .collaboration/features/{feature-name}/design.md 内容}

## 组件契约
{粘贴 .collaboration/features/{feature-name}/design-components.md 内容}

## API 契约
{粘贴 .collaboration/features/{feature-name}/api.yaml 内容}
```

## Bug 模式

```text
我使用 frontend Skill。

请基于 handoff 文档完成当前 Bug 的前端修复。
先根据输入路径或 frontmatter 确认唯一 bug-name，并识别真实源码路径与测试路径。
只在 `.collaboration/bugs/{bug-name}/frontend-handoff.md` 指定的边界内修复；如果发现修复超出边界，请停止并回到 bug-coordinator。
禁止把实现代码写到任何 .collaboration/ 工作项目录。
实现完成后，必须执行仓库现有的代码质量、语法/类型或构建、测试与缺陷检查，并汇总实际执行命令、结果与剩余阻塞。

## Handoff
{粘贴 .collaboration/bugs/{bug-name}/frontend-handoff.md 内容}

## Bug
{粘贴 .collaboration/bugs/{bug-name}/bug.md 内容}

## Fix Plan
{粘贴 .collaboration/bugs/{bug-name}/fix-plan.md 内容}
```
