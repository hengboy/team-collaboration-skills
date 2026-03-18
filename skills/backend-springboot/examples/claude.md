# backend-springboot - Claude 使用示例

## 配置（首次使用）

```bash
mkdir -p ~/.claude/skills
cp skills/backend-springboot/SKILL.md ~/.claude/skills/
```

## 使用方式（无需脚本）

```bash
claude
```

在对话中：

```
我使用 backend-springboot Skill。

请实现登录接口。

## API 契约
{粘贴 .collaboration/features/mobile-login/api.yaml 内容}

## 技术方案
{粘贴 .collaboration/features/mobile-login/tech.md 内容}
```

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
