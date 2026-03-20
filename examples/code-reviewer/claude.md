# code-reviewer - Claude 使用示例

## 配置

```bash
mkdir -p ~/.claude/skills
cp -R skills/code-reviewer ~/.claude/skills/
```

## Feature 模式

```text
我使用 code-reviewer Skill。

请以 findings-first 方式审查当前 Feature 的代码变更。

## Review Context
{粘贴 .collaboration/features/{feature-name}/qa-report.md 内容}
{粘贴 .collaboration/features/{feature-name}/test-cases.md 内容}
{粘贴 diff 或 PR 描述}
```

## Bug 模式

```text
我使用 code-reviewer Skill。

请以 findings-first 方式审查当前 Bug 的修复变更。
重点关注：
- 根因是否被覆盖
- 回归保护是否充分
- handoff 边界是否被突破

## Review Context
{粘贴 .collaboration/bugs/{bug-name}/bug.md 内容}
{粘贴 .collaboration/bugs/{bug-name}/qa-report.md 内容}
{粘贴 diff 或 PR 描述}
```
