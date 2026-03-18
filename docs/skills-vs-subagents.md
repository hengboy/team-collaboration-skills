# Skills vs Subagents 决策文档

## 结论

**推荐：Skills（技能）** 作为主要实现方式

---

## 核心分析

### 为什么选择 Skills

1. **上下文共享是关键**
   - OpenCode 的 skill 工具自动读取项目文件
   - 用 `@` 引用即可，无需手动打包
   - Subagents 的上下文隔离反而是劣势

2. **符合实际工作流**
   ```bash
   # 开发者工作流
   opencode
   skill(name: backend-typescript)
   
   请实现登录接口。
   
   ## API 契约
   @.collaboration/features/mobile-login/api.yaml
   
   # 直接生成到当前文件
   ```

3. **使用频率分析**
   - 90% 是单次任务（写个函数、生成测试）
   - 10% 是多步骤任务
   - Skills 覆盖大部分场景

---

## 使用方式

### OpenCode（推荐）

```bash
opencode
skill(name: backend-typescript)

请实现登录接口。

## API 契约
@.collaboration/features/mobile-login/api.yaml

## 技术方案
@.collaboration/features/mobile-login/tech.md
```

**无需脚本** - OpenCode 自动读取 `@` 引用的文件。

### Claude

```bash
claude
```

在对话中：

```
我使用 backend-typescript Skill。

请实现登录接口。

## API 契约
{粘贴 .collaboration/features/mobile-login/api.yaml 内容}
```

---

## 何时使用 Subagents

Subagents 在以下场景有价值：

### 场景 1：自动化测试生成

```
skill(name: qa-engineer)

请为整个模块生成完整测试套件。

## 源代码目录
@src/auth/

## 测试框架
- Jest
- 覆盖率要求：> 80%
```

### 场景 2：完整功能模块开发

```
skill(name: tech-lead)

请从 PRD 到代码完整实现。

## PRD
@.collaboration/features/mobile-login/prd.md

## 输出
1. 技术方案
2. API 契约
3. 后端代码
4. 前端代码
5. 测试用例
```

---

## 实施建议

### Skills 架构

```
用户会话
├── skill(name: product-manager)
├── skill(name: tech-lead)
├── skill(name: backend-typescript)
└── ...
```

### 使用原则

| 条件 | 选择 |
|------|------|
| 单次任务 | Skills |
| 需要共享上下文 | Skills |
| 用户明确知道角色 | Skills |
| 多步骤 autonomous 任务 | Subagents |
| 需要并行执行 | Subagents |

---

## 总结

**推荐 Skills 的核心理由**：

1. ✅ **上下文共享** - OpenCode 自动读取 @引用的文件
2. ✅ **轻量快速** - 直接用 skill(name: xxx) 调用
3. ✅ **易实现推广** - 无需脚本，纯 AI 调用
4. ✅ **覆盖 90% 场景** - 满足日常开发需求

**下一步行动**：
1. 使用 Skills
2. 直接调用：`skill(name: xxx)`
3. 用 `@` 引用文件

