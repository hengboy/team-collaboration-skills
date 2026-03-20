# code-reviewer - OpenCode 使用示例

## Feature 模式

```bash
opencode

skill(name: code-reviewer)

请以 findings-first 方式审查当前 Feature 的代码变更。

## Review Context
@.collaboration/features/{feature-name}/qa-report.md
@.collaboration/features/{feature-name}/test-cases.md

## Diff / PR
{粘贴 diff、PR 描述或明确的待审查文件路径}
```

## Bug 模式

```bash
opencode

skill(name: code-reviewer)

请以 findings-first 方式审查当前 Bug 的修复变更。
重点关注：
- 根因是否被覆盖
- 回归保护是否充分
- handoff 边界是否被突破

## Review Context
@.collaboration/bugs/{bug-name}/bug.md
@.collaboration/bugs/{bug-name}/qa-report.md

## Diff / PR
{粘贴 diff、PR 描述或明确的待审查文件路径}
```
