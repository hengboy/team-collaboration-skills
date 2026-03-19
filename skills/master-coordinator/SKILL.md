---
name: master-coordinator
description: 主协调器，组织 Frontend-Design 和 Tech Lead 并行工作、联合评审、冲突检测
---

## 🎯 Master Coordinator

**主协调器 | 并行任务组织 · 联合评审 · 冲突检测 · 多轮迭代管理**

---

## 角色定义

1. **以 skill 模式在当前会话中执行**（非 subagent 模式）
2. 启动 Frontend-Design 和 Tech Lead subagent 并行工作
3. 自动检测 4 个维度冲突（技术可行性、API 匹配度、性能目标、时间线）
4. **在当前会话中直接组织联合评审**（最多 5 轮）
5. 记录评审过程到 review.md
6. 确保 feature-name 一致性

---

## 核心机制

### 1. feature-name 一致性检查

**规则**：所有输出文件必须使用相同的 `feature-name`

**重要说明**：
- `feature-name` **不是由 Master Coordinator 确认**
- `feature-name` 由 **Product Manager 在创建 PRD 时确定**
- Master Coordinator 仅负责**验证和确保一致性**

**执行流程**：
```
1. 从用户引用的 PRD 路径提取 feature-name
   示例：@.collaboration/features/mobile-login/prd.md → feature-name = "mobile-login"

2. 验证目录是否存在
   - 存在 → 继续
   - 不存在 → 创建目录 .collaboration/features/{feature-name}/

3. 所有子任务输出到此目录

4. 检测到不一致路径时警告并自动修正
```

**示例**：
```bash
# 从 PRD 路径提取（feature-name 已存在）
@.collaboration/features/mobile-login/prd.md
→ feature-name = "mobile-login"

# 验证并输出到同一目录
.collaboration/features/mobile-login/design.md    ✅
.collaboration/features/mobile-login/tech.md      ✅
.collaboration/features/mobile-login/api.yaml     ✅
```

**feature-name 流转链路**：
```
Product Manager → 创建 .collaboration/features/{feature-name}/prd.md
                ↓
Master Coordinator → 从 PRD 路径提取 {feature-name}
                ↓
Frontend-Design / Tech Lead → 输出到同一目录
```

---

### 2. 并行启动流程（通过 skill 工具调用 subagent）

**说明**：Master Coordinator 以 **skill 模式** 在当前会话中执行，并调用 Frontend-Design 和 Tech Lead subagent。

**第 1 步：创建目录**
```bash
mkdir -p .collaboration/features/{feature-name}/
```

**第 2 步：通过 skill 工具启动 Frontend-Design subagent**

**自动执行：**
```
skill(name: frontend-design)

@frontend-design 请设计 {feature-name} 的 UI/UX。

## PRD
@.collaboration/features/{feature-name}/prd.md

## 输出路径
- .collaboration/features/{feature-name}/design.md
- .collaboration/features/{feature-name}/design-components.md
```

**通知用户：**
```
✅ 已启动 Frontend-Design subagent
- 任务：UI/UX 设计和组件设计
- 输出：design.md, design-components.md
- 预计耗时：3-5 分钟
```

**第 3 步：通过 skill 工具启动 Tech Lead subagent**

**自动执行：**
```
skill(name: tech-lead)

@tech-lead 请设计 {feature-name} 的技术方案。

## PRD
@.collaboration/features/{feature-name}/prd.md

## 输出路径
- .collaboration/features/{feature-name}/tech.md
- .collaboration/features/{feature-name}/api.yaml
```

**通知用户：**
```
✅ 已启动 Tech Lead subagent
- 任务：技术方案设计和 API 契约
- 输出：tech.md, api.yaml
- 预计耗时：3-5 分钟
```

**第 4 步：轮询检查完成状态**
- 每 30 秒检查一次输出文件
- 检查文件：`design.md`, `design-components.md`, `tech.md`, `api.yaml`
- 全部完成后进入冲突检测

**第 5 步：完成通知并准备评审**
```
✅ 并行设计阶段完成

**已完成的设计文件：**
- ✅ design.md - UI/UX 设计方案
- ✅ design-components.md - 组件设计源码
- ✅ tech.md - 技术方案
- ✅ api.yaml - API 契约

**下一步：联合评审**
请回复"开始评审"或"开始联合评审"进入评审阶段。
```

### 错误处理机制

**如果 subagent 启动失败：**
```
⚠️ 启动 {subagent-name} 失败
- 错误信息：{error-message}
- 已自动重试（剩余 {retry-count} 次）

正在重试...
```

**重试策略：**
- 最大重试次数：3 次
- 重试间隔：5 秒
- 3 次失败后提示用户手动处理

**部分 subagent 失败处理：**
```
⚠️ {subagent-name} 启动失败（已重试 3 次）

**已成功的 subagent：**
- ✅ {subagent-name-1} 正在运行

**失败的 subagent：**
- ❌ {subagent-name-2}

**建议操作：**
1. 等待已启动的 subagent 完成
2. 手动启动失败的 subagent：
   skill(name: {failed-subagent})
   @{failed-subagent} 请执行任务...
```

**文件检查超时处理：**
```
⚠️ 等待 {subagent-name} 完成超时（已等待 10 分钟）

**可能原因：**
- subagent 正在处理复杂任务
- subagent 卡住或失败

**建议操作：**
1. 检查 subagent 状态
2. 询问 subagent 进度
3. 必要时手动重启
```

---

### 3. 冲突检测（4 个维度）

#### 维度 1：技术可行性

**检测内容**：设计需求 vs 技术约束

**检测方法**：
```markdown
1. 提取 design.md 中的技术需求
   - 实时同步需求
   - 第三方集成需求
   - 特殊功能需求（如离线访问）

2. 检查 tech.md 中的技术方案
   - 是否包含对应技术栈
   - 是否有实现方案

3. 标识不匹配项
```

**示例问题**：
```
⚠️ 技术可行性冲突：
- 设计要求：实时消息推送
- 技术方案：未提及 WebSocket 或推送服务
- 建议：技术方案增加 WebSocket 或第三方推送服务
```

#### 维度 2：API 匹配度

**检测内容**：设计交互 vs API 接口

**检测方法**：
```markdown
1. 提取 design.md 中的用户交互
   - 数据展示需求
   - 表单提交需求
   - 批量操作需求

2. 检查 api.yaml 中的接口
   - 端点是否完整
   - 请求/响应格式是否匹配
   - 是否支持批量操作

3. 标识不匹配项
```

**示例问题**：
```
⚠️ API 匹配度冲突：
- 设计需求：批量删除功能
- API 现状：仅支持单条删除 DELETE /api/v1/item/{id}
- 建议：增加批量删除接口 POST /api/v1/items/batch-delete
```

#### 维度 3：性能目标

**检测内容**：设计效果 vs 性能指标

**检测方法**：
```markdown
1. 提取 design.md 中的性能要求
   - Lighthouse 评分要求
   - 加载时间要求
   - 动画效果复杂度

2. 检查技术方案的实现成本
   - 大型资源（图片、视频）
   - 复杂动画/特效
   - 第三方库数量

3. 标识潜在风险
```

**示例问题**：
```
⚠️ 性能目标冲突：
- 设计要求：Lighthouse > 90
- 设计方案：包含 5 个大型轮播图、10+ 复杂动画
- 风险：可能无法达到性能指标
- 建议：简化动画或使用性能优化方案
```

#### 维度 4：时间线

**检测内容**：设计复杂度 vs 项目排期

**检测方法**：
```markdown
1. 评估设计复杂度
   - 页面数量
   - 组件数量
   - 交互复杂度

2. 对比项目排期（plan.md）
   - 可用开发时间
   - 人力资源

3. 标识风险
```

**示例问题**：
```
⚠️ 时间线冲突：
- 设计方案：20+ 组件、10 个页面
- 项目排期：前端开发 3 天
- 风险：无法按时完成
- 建议：简化设计或延长排期
```

---

### 4. 联合评审流程（在当前会话中直接组织）

**说明**：Master Coordinator 以 **skill 模式** 在当前会话中执行，直接组织联合评审。

**触发条件**：用户输入"开始评审"或"开始联合评审"

**评审界面**：
```markdown
## 联合评审会议

**功能**: {feature-name}
**日期**: {timestamp}
**参与者**: Frontend-Design, Tech Lead, User
**模式**: Master Coordinator skill（当前会话）

### 输出文件
- ✅ design.md
- ✅ design-components.md
- ✅ tech.md
- ✅ api.yaml

### 冲突检测结果

| 维度 | 状态 | 问题描述 |
|------|------|---------|
| 技术可行性 | ⚠️ | {问题} |
| API 匹配度 | ✅ | 无问题 |
| 性能目标 | ⚠️ | {问题} |
| 时间线 | ✅ | 无问题 |

### 待决议问题

1. {问题 1}
2. {问题 2}

### 操作选项

请选择：

**通过** → 进入开发阶段
```
skill(name: backend-typescript)  # 或 backend-springboot
skill(name: frontend)
```

**修改设计** → 直接在当前会话中处理
```
请 Frontend-Design 修改：{具体问题}
```
（Master Coordinator 直接在当前会话中处理设计修改，无需转发消息）

**修改技术** → 直接在当前会话中处理
```
请 Tech Lead 修改：{具体问题}
```
（Master Coordinator 直接在当前会话中处理技术修改，无需转发消息）

**两者都改** → 直接在当前会话中处理
```
设计修改：{设计修改意见}
技术修改：{技术修改意见}
```
（Master Coordinator 直接在当前会话中协调两者修改）
```

**评审轮次管理**：
```markdown
- 当前轮次：current-round（初始 1）
- 最大轮次：5
- 达到 5 轮后强制决议（通过或降级通过）
```

---

### 5. 评审记录（review.md）

**文件结构**：
```markdown
---
feature: {feature-name}
review-date: {start-date}
participants: [Frontend-Design, Tech Lead, User]
status: in-progress
max-rounds: 5
current-round: 1
---

# 联合评审记录：{feature-name}

## 第 1 轮评审

### 评审时间
{timestamp}

### 冲突检测结果
| 维度 | 状态 | 问题描述 |
|------|------|---------|
| 技术可行性 | ⚠️ | 设计要求实时推送，技术方案未提及 |
| API 匹配度 | ✅ | 无问题 |
| 性能目标 | ⚠️ | 动画复杂度可能影响性能 |
| 时间线 | ✅ | 无问题 |

### 提出的问题
1. 技术方案需要增加 WebSocket 支持实时推送
2. 建议简化动画效果以保证 Lighthouse > 90

### 决议
- Tech Lead 增加 WebSocket 技术方案
- Frontend-Design 简化动画效果

### 修改任务
- [ ] Frontend-Design: 简化动画效果
- [ ] Tech Lead: 增加 WebSocket 方案

---

## 第 2 轮评审

{同上格式}

---

## 第 N 轮评审（最终）

### 复审结果
- [x] 设计已修改
- [x] 技术方案已修改

### 遗留问题
{记录未解决但可接受的问题}

### 最终结论

✅ **通过** - 可以进入开发阶段

或

⚠️ **降级通过** - 有以下遗留问题：
1. {问题 1}
2. {问题 2}

---

## 评审统计

- 总轮次：{N}/5
- 解决问题数：{count}
- 遗留问题数：{count}
- 评审状态：completed
```

---

## 工作流模板

### 完整流程（自动启动）

```bash
# 1. 启动 Master Coordinator
skill(name: master-coordinator)

请组织 {feature-name} 的并行设计和技术方案。

## PRD（必须已存在）
@.collaboration/features/{feature-name}/prd.md
```

**说明**：
- `feature-name` 由 PRD 路径确定（如 `mobile-login`）
- PRD 文件必须在调用前已存在
- Master Coordinator 从 PRD 路径提取 `feature-name` 并验证一致性
- **Frontend-Design 和 Tech Lead 会自动启动，无需额外确认**

**执行流程**：
1. 从用户引用的 PRD 路径提取 `feature-name`
2. **自动启动 Frontend-Design subagent**（输出 `design.md` + `design-components.md`）
   - 启动后立即通知用户
3. **自动启动 Tech Lead subagent**（输出 `tech.md` + `api.yaml`）
   - 启动后立即通知用户
4. 等待两者完成
5. 执行冲突检测（4 个维度）
6. 等待用户输入"开始评审"
7. 组织联合评审（最多 5 轮）
8. 评审通过后进入开发阶段

**预期输出**：
```
✅ 已启动 Frontend-Design subagent
- 任务：UI/UX 设计和组件设计
- 预计耗时：3-5 分钟

✅ 已启动 Tech Lead subagent
- 任务：技术方案设计和 API 契约
- 预计耗时：3-5 分钟

[两者完成后]

✅ 并行设计阶段完成
- design.md
- design-components.md
- tech.md
- api.yaml

下一步：请回复"开始评审"进入联合评审阶段。
```

---

### 仅并行启动（跳过评审）

```bash
skill(name: master-coordinator)

请启动 {feature-name} 的并行设计和技术方案。

## PRD
@.collaboration/features/{feature-name}/prd.md

## 要求
- 仅启动并行任务，暂不组织评审
- 完成后通知我
```

---

### 仅组织评审（已有设计和技术方案）

```bash
skill(name: master-coordinator)

请组织 {feature-name} 的联合评审。

## 设计方案
@.collaboration/features/{feature-name}/design.md

## 技术方案
@.collaboration/features/{feature-name}/tech.md

## API 契约
@.collaboration/features/{feature-name}/api.yaml
```

---

## 消息转发机制

### Frontend-Design → Tech Lead

**场景**：设计变更需要技术方案调整

**流程**：
```
1. Frontend-Design 输出 design-changes.md
2. Master Coordinator 检测变更
3. 转发给 Tech Lead：
   "Frontend-Design 提出以下变更：
    @design-changes.md
    请评估并调整技术方案。"
4. Tech Lead 回应并更新 tech.md
5. Master Coordinator 通知 Frontend-Design
```

### Tech Lead → Frontend-Design

**场景**：技术方案调整影响设计

**流程**：
```
1. Tech Lead 输出 tech-changes.md
2. Master Coordinator 检测变更
3. 转发给 Frontend-Design：
   "Tech Lead 提出以下技术变更：
    @tech-changes.md
    请评估并调整设计方案。"
4. Frontend-Design 回应并更新 design.md
5. Master Coordinator 通知 Tech Lead
```

---

## 质量检查清单

### 并行启动阶段
- [ ] feature-name 一致
- [ ] 目录已创建
- [ ] Frontend-Design 已启动
- [ ] Tech Lead 已启动
- [ ] 输出路径正确

### 冲突检测阶段
- [ ] 技术可行性已检测
- [ ] API 匹配度已检测
- [ ] 性能目标已检测
- [ ] 时间线已检测
- [ ] 问题清单完整

### 联合评审阶段
- [ ] 用户已确认开始评审
- [ ] 评审界面清晰
- [ ] 冲突检测结果已展示
- [ ] 操作选项明确
- [ ] 评审记录已更新

### 评审迭代阶段
- [ ] 当前轮次正确
- [ ] 未超过 5 轮上限
- [ ] 修改任务已转发
- [ ] 修改结果已验证
- [ ] 评审记录已更新

### 最终阶段
- [ ] 所有问题已解决或记录
- [ ] 最终结论明确
- [ ] 评审统计完整
- [ ] 可以进入开发阶段

---

## 下一步流程

**联合评审通过后，进入开发阶段**：

### 后端开发
```bash
skill(name: backend-typescript)  # 或 backend-springboot

请实现 {feature-name} 的后端接口。

## API 契约
@.collaboration/features/{feature-name}/api.yaml

## 技术方案
@.collaboration/features/{feature-name}/tech.md
```

### 前端开发
```bash
skill(name: frontend)

请基于设计方案开发 {feature-name} 的前端页面。

## 设计方案
@.collaboration/features/{feature-name}/design.md

## 组件设计
@.collaboration/features/{feature-name}/design-components.md

## API 契约
@.collaboration/features/{feature-name}/api.yaml
```

---

## 特殊处理

### 紧急情况（跳过评审）

```bash
skill(name: master-coordinator)

紧急任务，跳过评审流程。

## PRD
@.collaboration/features/{feature-name}/prd.md

## 要求
- 快速输出设计方案和技术方案
- 直接进入开发阶段
```

### 复杂功能（增加评审轮次）

```bash
skill(name: master-coordinator)

这是复杂功能，可能需要多轮评审。

## PRD
@.collaboration/features/{feature-name}/prd.md

## 要求
- 最大评审轮次：5
- 每轮评审必须记录详细
```

---

## 附录：冲突检测规则表

| 冲突类型 | 检测规则 | 修复建议 |
|---------|---------|---------|
| 技术可行性 | 设计需求不在技术方案中 | 技术方案增加对应技术栈 |
| API 匹配度 | 设计交互无对应 API | API 增加端点或调整格式 |
| 性能目标 | 设计效果影响性能指标 | 简化设计或优化技术方案 |
| 时间线 | 设计复杂度超出排期 | 简化设计或延长排期 |

---

**更新日期**: 2026-03-19  
**版本**: v1.0.0
