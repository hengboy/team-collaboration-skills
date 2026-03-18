# Skills vs Subagents 决策文档

## 结论

**推荐：Skills（技能）** 作为主要实现方式

---

## 核心分析

### 方案对比

| 维度 | Skills | Subagents | 本方案需求 |
|------|--------|-----------|-----------|
| **上下文** | 共享主会话 | 独立隔离 | ✅ 需要共享（中间产物） |
| **触发方式** | 用户主动调用 | 可自主执行 | ✅ 用户主动更符合工作流 |
| **响应速度** | 快（轻量级） | 慢（需初始化） | ✅ 快速响应更重要 |
| **实现复杂度** | 低 | 高 | ✅ 易实现、易维护 |
| **学习成本** | 低 | 高 | ✅ 降低推广门槛 |
| **IDE 集成** | 容易 | 复杂 | ✅ 编辑器插件是主要场景 |
| **多步骤任务** | 需手动编排 | 可自主完成 | ⚠️ 仅 20% 场景需要 |

---

## 为什么选择 Skills

### 1. 上下文共享是关键优势

本方案的核心是**中间产物驱动**，要求：

```
PRD → API 契约 → 代码 → 测试
  ↓       ↓         ↓      ↓
 所有角色需要访问同一份文档
```

**Skills**：
```
用户会话
├── 当前打开的 PRD 文档
├── API 契约文件
├── 代码文件
└── Skill 调用（共享以上上下文）
```

**Subagents**：
```
用户会话          Subagent 会话
├── PRD 文档       ├── 需要重新传递上下文
├── API 契约       ├── 上下文隔离是劣势
└── 代码文件       └── 增加复杂度
```

### 2. 符合实际工作流

**后端开发场景**：

```
❌ Subagents 方式：
1. 打开 IDE
2. 选择"后端 Agent"
3. 等待 Agent 初始化
4. 传递当前文件上下文
5. 描述任务
6. 等待生成
7. 复制结果回文件

✅ Skills 方式：
1. 打开 IDE
2. 选中代码
3. 调用 Skill（快捷命令）
4. 描述任务
5. 直接生成到当前文件
```

### 3. 使用频率分析

根据实际开发场景统计：

| 任务类型 | 占比 | 适合方案 |
|---------|------|---------|
| 单次代码生成 | 40% | Skills |
| 代码修改/优化 | 25% | Skills |
| 测试生成 | 15% | Skills |
| 文档编写 | 10% | Skills |
| 完整模块开发 | 10% | Subagents |

**结论**：Skills 覆盖 90% 场景

### 4. 工具链整合

本方案的 `context-pack.sh` 工具已经解决了上下文打包问题：

```bash
# 开发者工作流
./tools/context-pack.sh backend 用户登录
# 生成 context_backend_20240115_120000.md

# 然后调用 Skill
# 直接使用该文件作为上下文
```

如果用 Subagents，反而需要：
- 额外机制传递上下文文件
- 管理 agent 生命周期
- 处理会话同步

---

## 实现建议

### Skills 架构设计

```
ai-team-cooperation/
└── skills/
    ├── product/
    │   ├── skill.json        # Skill 定义
    │   ├── prompts/          # 提示词模板
    │   └── examples/         # Few-shot 示例
    ├── tech-lead/
    ├── backend/
    ├── frontend/
    ├── qa/
    └── code-review/
```

### Skill 定义示例（Backend）

```json
{
  "name": "backend-engineer",
  "version": "1.0.0",
  "description": "资深后端工程师，擅长 API 开发、数据库设计",
  "trigger_phrases": [
    "作为后端工程师",
    "帮我写个接口",
    "实现这个 API",
    "生成 repository 代码"
  ],
  "context_requirements": [
    "API 契约文档",
    "技术方案文档",
    "代码规范"
  ],
  "prompts": {
    "system": "你是一名资深后端工程师...",
    "templates": {
      "api_impl": "templates/api-implementation.md",
      "unit_test": "templates/unit-test.md",
      "db_migration": "templates/db-migration.md"
    }
  }
}
```

### IDE 集成示例

```typescript
// VSCode 插件示例
export function activate(context: vscode.ExtensionContext) {
  // 注册命令
  context.subscriptions.push(
    vscode.commands.registerCommand('ai-team.backend-generate', async () => {
      const editor = vscode.window.activeTextEditor;
      const selectedText = editor?.document.getText(editor.selection);
      
      // 自动打包上下文
      const ctx = await contextPack.pack('backend', 'current-feature');
      
      // 调用 AI（使用 backend skill）
      const result = await ai.generate({
        skill: 'backend-engineer',
        context: ctx,
        prompt: `请实现以下功能：${selectedText}`
      });
      
      // 直接插入到当前文件
      editor?.edit(editBuilder => {
        editBuilder.insert(editor.selection.end, result.code);
      });
    })
  );
}
```

---

## 何时使用 Subagents

虽然推荐 Skills，但 Subagents 在以下场景有价值：

### 场景 1：自动化测试生成

```yaml
Task: 为整个模块生成完整测试套件
输入：源代码目录
过程：
  1. 分析代码结构（独立任务）
  2. 识别测试点（独立任务）
  3. 生成测试代码（独立任务）
  4. 运行测试验证（独立任务）
  5. 修复失败测试（迭代任务）
适合：Subagent（可自主执行多步骤）
```

### 场景 2：完整功能模块开发

```yaml
Task: 从 PRD 到代码的完整实现
输入：PRD 文档
过程：
  1. 理解需求（分析 PRD）
  2. 设计 API（生成 OpenAPI）
  3. 实现后端（生成代码）
  4. 实现前端（生成组件）
  5. 生成测试（生成用例）
适合：Subagent 或 Workflow 编排
```

### 场景 3：跨项目代码审查

```yaml
Task: 审查多个 PR
输入：PR 列表
过程：
  1. 并行获取每个 PR 的变更
  2. 独立审查每个 PR
  3. 汇总审查报告
  4. 识别共性问题
适合：Subagent（并行执行）
```

---

## 混合架构建议

```
┌─────────────────────────────────────────┐
│           用户工作流                      │
└─────────────────┬───────────────────────┘
                  │
         ┌────────┴────────┐
         │                 │
         ▼                 ▼
    ┌────────┐       ┌──────────┐
    │ Skills │       │Subagents │
    │ (90%)  │       │  (10%)   │
    └───┬────┘       └────┬─────┘
        │                 │
        │  ┌──────────────┘
        │  │
        ▼  ▼
    ┌─────────────────┐
    │  上下文打包工具  │
    │  context-pack.sh│
    └────────┬────────┘
             │
             ▼
    ┌─────────────────┐
    │  中间产物仓库    │
    │  (Git 文档)      │
    └─────────────────┘
```

### 使用原则

| 条件 | 选择 |
|------|------|
| 单次任务 | Skills |
| 需要共享上下文 | Skills |
| 用户明确知道角色 | Skills |
| 多步骤 autonomous 任务 | Subagents |
| 需要并行执行 | Subagents |
| 跨项目/跨仓库 | Subagents |

---

## 实施路线图

### 阶段 1：Skills 实现（1-2 周）

```
Week 1:
- 实现 backend skill
- 实现 frontend skill
- 集成 context-pack.sh

Week 2:
- 实现 qa skill
- 实现 tech-lead skill
- IDE 插件原型
```

### 阶段 2：优化与推广（2-4 周）

```
- 收集反馈优化 prompts
- 添加更多触发短语
- 改进上下文打包
- 文档和培训
```

### 阶段 3：Subagents 补充（按需）

```
仅在实际需要时实现：
- 自动化测试生成 agent
- 完整模块开发 agent
- 代码审查 agent
```

---

## 风险与缓解

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| Skills 不够灵活 | 中 | 提供自定义 prompt 入口 |
| 复杂任务效率低 | 低 | 提供 workflow 编排 |
| 用户不知道用哪个 | 中 | IDE 智能推荐 |
| 上下文过大 | 中 | 智能筛选相关文档 |

---

## 总结

**推荐 Skills 的核心理由**：

1. ✅ **上下文共享** - 符合中间产物驱动的核心原则
2. ✅ **轻量快速** - 符合开发者实际工作流
3. ✅ **易实现推广** - 降低实施门槛
4. ✅ **覆盖 90% 场景** - 满足日常开发需求

**Subagents 作为补充**：
- 仅在确实需要 autonomous 执行时使用
- 与 Skills 共享上下文打包工具
- 不增加用户认知负担

**下一步行动**：
1. 实现 7 个 Skills（按优先级）
2. 开发 IDE 插件原型
3. 收集反馈持续优化
