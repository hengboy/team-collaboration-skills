# git-commit - OpenCode 使用示例

## 使用方式

```bash
# 1. 启动 OpenCode
opencode

# 2. 加载 Skill
skill(name: git-commit)

# 3. 描述任务（用@引用文件）
请生成 Git 提交信息。

## 代码变更
@src/module/file.ts
```

**无需脚本** - OpenCode 会自动读取 `@` 引用的文件。

## 完整示例

### 常规提交

```bash
skill(name: git-commit)

请生成 Git 提交信息。

## 代码变更
@src/auth/login.ts
@src/auth/token.ts

## 提交要求
1. 以正确的 Emoji 代码开头
2. Subject 不超过 50 字符
3. 使用中文描述
```

### 批量提交拆分

```bash
skill(name: git-commit)

请帮我拆分提交。

## 变更文件
{粘贴 git status 输出}
```

详见 QUICKSTART.md 中的完整工作流示例。
