# backend-springboot - OpenCode 使用示例

## 使用方式（无需脚本）

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: backend-springboot)

# 3. 描述任务（用@引用文件）
请实现登录接口。
先识别 Spring Boot 源码路径、资源路径与测试路径，并只写入具体路径，例如：
- src/main/java/
- src/main/resources/
- src/test/java/
禁止把实现代码写到 .collaboration/features/{feature-name}/

## API 契约
@.collaboration/features/mobile-login/api.yaml

## 技术方案
@.collaboration/features/mobile-login/tech.md
```

**无需脚本** - OpenCode 会自动读取 `@` 引用的文件。

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
