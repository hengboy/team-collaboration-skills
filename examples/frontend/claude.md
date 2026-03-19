# frontend - Claude 使用示例

## 配置

```bash
mkdir -p ~/.claude/skills
cp skills/frontend/SKILL.md ~/.claude/skills/
```

## 使用方式

```bash
claude
```

在对话中：

```
我使用 frontend Skill。

请完成具体任务。
先识别前端源码路径与测试路径，并只写入具体路径，例如：
- apps/web/src/routes/
- apps/web/src/components/
- packages/ui/src/components/
禁止把实现代码写到 .collaboration/features/{feature-name}/

## 相关文档
{粘贴 .collaboration/features/{feature-name}/prd.md 内容}
{粘贴 .collaboration/features/{feature-name}/api.yaml 内容}
```

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
