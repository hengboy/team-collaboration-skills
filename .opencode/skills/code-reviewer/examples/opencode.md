# Code Reviewer Skill - OpenCode 使用示例

## 场景：手机号登录代码审查

### 前置准备

```bash
opencode
```

### 步骤 1：加载 Skill

```
skill(name: code-reviewer)
```

### 步骤 2：审查代码

```
请审查以下代码。

## PR 链接

https://github.com/xxx/xxx/pull/123

## 代码变更

src/auth/auth.controller.ts (+80 行)
src/auth/auth.service.ts (+120 行)
src/auth/dto/login.dto.ts (+30 行)

## 审查维度

1. 代码质量（命名、注释、函数长度）
2. 架构设计（分层、职责）
3. 错误处理（try-catch、日志）
4. 安全性（注入、认证）
5. 性能（查询、缓存）
6. 测试覆盖

## 输出要求

- Must Fix（必须修复）
- Nice to Have（建议优化）
- 提供修改建议代码
```

### 步骤 3：AI 输出审查报告

```markdown
# 代码审查报告

## 概述

- 变更文件：3
- 代码行数：+230
- 整体评价：良好（4/5）

## Must Fix

| 文件 | 行号 | 问题 | 建议 |
|------|------|------|------|
| auth.service.ts | 45 | 缺少错误处理 | 添加 try-catch |

## Nice to Have

| 文件 | 行号 | 问题 | 建议 |
|------|------|------|------|
| auth.service.ts | 78 | 函数过长 | 拆分函数 |
```

### 步骤 4：提交审查意见

在 GitHub PR 中提交审查意见。
