# Project Manager Skill - OpenCode 使用示例

## 场景：手机号登录功能项目排期

### 前置准备

```bash
./tools/context-pack.sh project-manager 手机号登录
opencode
```

### 步骤 1：加载 Skill

```
skill(name: project-manager)
```

### 步骤 2：制定项目计划

```
请制定手机号登录功能的项目计划。

## PRD

@docs/prd/mobile-login.md

## 技术方案

@docs/tech/mobile-login.md

## 团队资源

| 角色 | 人数 | 可用时间 |
|------|------|----------|
| 后端 | 2 | 100% |
| 前端 | 2 | 100% |
| 测试 | 1 | 100% |
| 设计 | 0.5 | 50% |

## 要求

1. 任务拆解（0.5-1 天粒度）
2. 甘特图（Mermaid）
3. 关键路径识别
4. 里程碑定义
5. 风险评估

请输出完整的项目计划。
```

### 步骤 3：AI 输出

AI 生成项目计划文档（含甘特图）。

### 步骤 4：保存

```bash
mkdir -p docs/project
# 保存文件

git add docs/project/
git commit -m "docs: 项目计划"
```
