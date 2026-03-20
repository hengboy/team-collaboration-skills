# qa-engineer - OpenCode 使用示例

## Feature 模式

```bash
opencode

skill(name: qa-engineer)

请基于以下输入整理当前 Feature 的测试用例与测试结论。

## PRD
@.collaboration/features/{feature-name}/prd.md

## API 契约
@.collaboration/features/{feature-name}/api.yaml

## 技术方案
@.collaboration/features/{feature-name}/tech.md
```

## Bug 模式

```bash
opencode

skill(name: qa-engineer)

请基于以下输入整理当前 Bug 的测试用例与测试结论。
必须覆盖原始复现路径、修复后正常路径、边界条件和相邻回归风险。
如果缺少 PR、diff、测试结果或构建结果等实现证据，请先停在输入校验，不要继续输出。

## Bug
@.collaboration/bugs/{bug-name}/bug.md

## Fix Plan
@.collaboration/bugs/{bug-name}/fix-plan.md

## 实现证据
{粘贴 PR 链接、diff 摘要、测试结果或构建结果}
```
