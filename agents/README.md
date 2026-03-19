# Agents Directory

Subagent 配置文件目录，每个 subagent 有独立的子目录。

## 目录结构

```
agents/
├── project-manager/
│   └── AGENT.md          # 项目经理 subagent
├── frontend-design/
│   └── AGENT.md          # 前端设计师 subagent
└── tech-lead/
    └── AGENT.md          # 技术负责人 subagent
```

## 支持平台

- ✅ **Opencode AI** - 使用 `mode: subagent` 配置
- ✅ **Claude Code** - 使用 `name` 和 `kind` 配置
- ✅ **Google Gemini CLI** - 使用 `tools` 配置

## 使用方法

### Opencode AI

```bash
opencode
# 自动调用或 @mention
@project-manager 请制定项目排期
```

### Claude Code

```bash
claude
# 自动调用或 @mention
@project-manager 请制定项目排期
```

### Google Gemini CLI

```bash
gemini
# 需要启用 experimental.enableAgents
# 自动调用或 @mention
@project-manager 请制定项目排期
```

## 内容同步

Subagent 配置来源于 `skills/` 目录下的 Skill 定义。

**检查同步状态**：
```bash
./scripts/sync-skill-agent.sh
```

**检查单个 skill**：
```bash
./scripts/sync-skill-agent.sh project-manager
```

详见：[../docs/skill-agent-sync-guide.md](../docs/skill-agent-sync-guide.md)

## 目录约定

- **项目级配置**：`./agents/` - 可提交到版本控制，团队共享
- **用户级配置**：`~/.config/opencode/agents/` - 个人配置，所有项目共享

## 文件格式

每个 AGENT.md 文件包含：

1. **YAML Frontmatter** - 平台特定配置
   ```yaml
   ---
   description: 描述
   mode: subagent
   model: claude-sonnet-4-20250514
   tools: ["read", "write", "bash"]
   ---
   ```

2. **系统提示词** - 从 Skill 提取的核心指令
   - 角色定义
   - 工作流程
   - 输出规范
   - 质量检查清单

---

**维护说明**：修改 Skill 后请运行同步脚本检查内容一致性。
