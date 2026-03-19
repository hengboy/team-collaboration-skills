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
先识别 TypeScript 后端源码路径与测试路径，并只写入具体路径，例如：
- apps/api/src/modules/
- src/modules/
- test/
禁止把实现代码写到 .collaboration/features/{feature-name}/

## API 契约
{粘贴 .collaboration/features/{feature-name}/api.yaml 内容}

## 技术方案
{粘贴 .collaboration/features/{feature-name}/tech.md 内容}
```
