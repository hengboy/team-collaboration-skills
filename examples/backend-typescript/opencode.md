# backend-typescript - OpenCode 使用示例

## 使用方式

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: backend-typescript)

# 3. 描述任务（用@引用文件）
请实现具体后端功能。
先从输入路径 .collaboration/features/{feature-name}/... 提取 feature-name；如果当前工具只有文档内容没有路径，就从 frontmatter 里的 feature: 提取；如果仍无法唯一确定，请先暂停并要求我补充。
先识别 TypeScript 后端源码路径与测试路径，并只写入具体路径，例如：
- apps/api/src/modules/
- src/modules/
- test/
禁止把实现代码写到 .collaboration/features/{feature-name}/
实现完成后，必须执行仓库现有的代码质量、语法/类型/构建、测试与缺陷检查。
优先使用 package.json、turbo.json 或 nest-cli.json 中现有脚本，并汇总实际执行命令、结果与剩余阻塞。
未全部通过前，不要进入下一阶段。

## API 契约
@.collaboration/features/{feature-name}/api.yaml

## 技术方案
@.collaboration/features/{feature-name}/tech.md
```
