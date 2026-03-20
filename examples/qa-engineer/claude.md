# qa-engineer - Claude 使用示例

## 配置

```bash
mkdir -p ~/.claude/skills
cp -R skills/qa-engineer ~/.claude/skills/
```

## Feature 模式

```text
我使用 qa-engineer Skill。

请基于以下输入整理当前 Feature 的测试用例与测试结论。

## PRD
{粘贴 .collaboration/features/{feature-name}/prd.md 内容}

## API 契约
{粘贴 .collaboration/features/{feature-name}/api.yaml 内容}
```

## Bug 模式

```text
我使用 qa-engineer Skill。

请基于以下输入整理当前 Bug 的测试用例与测试结论。
必须覆盖原始复现路径、修复后正常路径、边界条件和相邻回归风险。
如果缺少 PR、diff、测试结果或构建结果等实现证据，请先停在输入校验，不要继续输出。

## Bug
{粘贴 .collaboration/bugs/{bug-name}/bug.md 内容}

## Fix Plan
{粘贴 .collaboration/bugs/{bug-name}/fix-plan.md 内容}

## 实现证据
{粘贴 PR 链接、diff 摘要、测试结果或构建结果}
```
