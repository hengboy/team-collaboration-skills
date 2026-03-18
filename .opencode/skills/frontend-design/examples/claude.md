# frontend-design - Claude 使用示例

## 配置（首次使用）

```bash
mkdir -p ~/.claude/skills
cp skills/frontend-design/SKILL.md ~/.claude/skills/
```

## 使用方式（无需脚本）

```bash
claude
```

在对话中：

```
我使用 frontend-design Skill。

请设计登录页面。

## PRD
{粘贴 docs/prd/mobile-login.md 内容}

## API 契约
{粘贴 docs/api/auth.yaml 内容}

## 设计要求
- 移动端优先
- 支持深色模式
- 无障碍访问 WCAG 2.1 AA
- 配色方案：品牌蓝色 (#1890ff)
```

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
