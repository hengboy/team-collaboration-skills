# git-commit - Claude 使用示例

## 配置

```bash
mkdir -p ~/.claude/skills
cp -R skills/git-commit ~/.claude/skills/
```

## 使用方式

```bash
claude
```

在对话中：

```
我使用 git-commit Skill。

请生成 Git 提交信息。

## 代码变更
{粘贴 git diff 或相关文件内容}
```

## 完整示例

### 常规提交

```
我使用 git-commit Skill。

请生成 Git 提交信息。

## 代码变更
{粘贴 git diff 输出或文件内容}

## 提交要求
1. 以正确的 Emoji 代码开头
2. Subject 不超过 50 字符
3. 使用中文描述
```

### 批量提交拆分

```
我使用 git-commit Skill。

请帮我拆分提交。

## 变更文件
{粘贴 git status 输出}
```

详见 QUICKSTART.md 中的完整工作流示例。
