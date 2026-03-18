# backend-springboot - OpenCode 使用示例

## 使用方式（无需脚本）

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: backend-springboot)

# 3. 描述任务（用@引用文件）
请实现登录接口。

## API 契约
@docs/collaboration/api/auth.yaml

## 技术方案
@docs/collaboration/tech/mobile-login.md
```

**无需脚本** - OpenCode 会自动读取 `@` 引用的文件。

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
