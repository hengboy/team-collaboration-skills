# frontend - OpenCode 使用示例

## 使用方式

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: frontend)

# 3. 描述任务（用@引用文件）
请完成具体任务。
先识别前端源码路径与测试路径，并只写入具体路径，例如：
- apps/web/src/routes/
- apps/web/src/components/
- packages/ui/src/components/
禁止把实现代码写到 .collaboration/features/{feature-name}/

## 相关文档
@.collaboration/features/{feature-name}/prd.md
@.collaboration/features/{feature-name}/api.yaml
```

**无需脚本** - OpenCode 会自动读取 `@` 引用的文件。

## 完整示例

详见 QUICKSTART.md 中的完整工作流示例。
