# backend-typescript - OpenCode 使用示例

## 使用方式

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: backend-typescript)

# 3. 描述任务（用@引用文件）
请实现具体后端功能。
先识别 TypeScript 后端源码路径与测试路径，并只写入具体路径，例如：
- apps/api/src/modules/
- src/modules/
- test/
禁止把实现代码写到 .collaboration/features/{feature-name}/

## API 契约
@.collaboration/features/{feature-name}/api.yaml

## 技术方案
@.collaboration/features/{feature-name}/tech.md
```
