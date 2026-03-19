# backend-typescript - Claude 使用示例

## 配置

```bash
mkdir -p ~/.claude/skills
cp skills/backend-typescript/SKILL.md ~/.claude/skills/
```

## 使用方式

```bash
claude
```

在对话中：

```text
我使用 backend-typescript Skill。

请实现具体后端功能。
先从输入路径 .collaboration/features/{feature-name}/... 提取 feature-name；如果这里只有粘贴的文档内容没有路径，就从 frontmatter 里的 feature: 提取；如果仍无法唯一确定，请先暂停并要求我补充。粘贴文档时请保留 frontmatter。
先识别 TypeScript 后端源码路径与测试路径，并只写入具体路径，例如：
- apps/api/src/modules/
- src/modules/
- test/
禁止把实现代码写到 .collaboration/features/{feature-name}/
实现完成后，必须执行仓库现有的代码质量、语法/类型/构建、测试与缺陷检查。
优先使用 package.json、turbo.json 或 nest-cli.json 中现有脚本，并汇总实际执行命令、结果与剩余阻塞。
未全部通过前，不要进入下一阶段。

## API 契约
{粘贴 .collaboration/features/{feature-name}/api.yaml 内容}

## 技术方案
{粘贴 .collaboration/features/{feature-name}/tech.md 内容}
```
