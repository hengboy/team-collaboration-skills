# frontend-design - OpenCode 使用示例

## 使用方式（无需脚本）

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: frontend-design)

# 3. 描述任务（用@引用文件）
请设计登录页面。

## PRD
@docs/collaboration/prd/mobile-login.md

## API 契约
@docs/collaboration/api/auth.yaml

## 设计要求
- 移动端优先
- 支持深色模式
- 无障碍访问 WCAG 2.1 AA
- 配色方案：品牌蓝色 (#1890ff)
- 性能要求：Lighthouse > 90
```

**无需脚本** - OpenCode 会自动读取 `@` 引用的文件。

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
