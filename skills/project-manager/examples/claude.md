# Project Manager Skill - Claude 使用示例

## 场景：手机号登录功能项目排期

### 前置准备

```bash
./tools/context-pack.sh project-manager 手机号登录
```

### 步骤 1：在 Claude 中说明

```
我是一名项目经理，需要制定登录功能的项目计划。

## 信息
- PRD 已批准
- 技术方案已完成
- 团队：后端 2 人，前端 2 人，测试 1 人
- 目标上线：2024-01-30
```

### 步骤 2：制定计划

```
请制定项目计划。

## 输出

1. 任务拆解表格
2. 甘特图（Mermaid）
3. 关键路径
4. 里程碑
5. 风险矩阵
```

### 步骤 3：保存

```bash
mkdir -p docs/project
git add docs/
git commit -m "docs: 项目计划"
```
