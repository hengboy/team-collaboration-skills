# 多端仓库协作最佳实践

**版本**: v1.0.0  
**更新日期**: 2026-03-19  
**适用场景**: 前端、后端、小程序端 Git 仓库分离的多端协作项目

---

## 📋 目录

1. [架构概述](#1-架构概述)
2. [仓库结构](#2-仓库结构)
3. [版本管理机制](#3-版本管理机制)
4. [同步策略](#4-同步策略)
5. [设计冻结流程](#5-设计冻结流程)
6. [变更请求流程](#6-变更请求流程)
7. [Gitea 配置](#7-gitea-配置)
8. [工作流示例](#8-工作流示例)
9. [质量检查清单](#9-质量检查清单)

---

## 1. 架构概述

### 1.1 问题背景

当团队使用分离的 Git 仓库管理不同端代码时：

- **前端仓库**: `github.com/your-org/frontend`
- **后端仓库**: `github.com/your-org/backend`
- **小程序仓库**: `github.com/your-org/miniprogram`

**核心问题**: 产品设计、界面设计、技术设计文档应该保存在哪里？如何在各端之间流转？

### 1.2 推荐方案

```
┌─────────────────────────────────────────────┐
│   公共协作仓库 (team-collaboration)         │
│   ├── .collaboration/features/              │
│   │   └── mobile-login/                     │
│   │       ├── prd.md (v1.0.0-FROZEN)        │
│   │       ├── design.md (v1.0.0-FROZEN)     │
│   │       ├── api.yaml (v1.0.0-FROZEN)      │
│   │       └── tech.md (v1.0.0-FROZEN)       │
│   └── releases/                             │
│       └── mobile-login/manifest.json        │
└─────────────────────────────────────────────┘
              ↓ 版本化同步
┌─────────────┼─────────────┬─────────────┐
↓             ↓             ↓             ↓
frontend     backend      miniprogram   QA
仓库          仓库          仓库          仓库
```

### 1.3 核心优势

| 优势 | 说明 |
|------|------|
| ✅ **单一事实来源** | 所有设计产物在一个仓库，版本清晰 |
| ✅ **版本可追溯** | Git 历史清晰记录设计演进过程 |
| ✅ **权限清晰** | 设计仓库可单独管理访问权限 |
| ✅ **解耦开发** | 各端仓库保持独立，不被设计文档污染 |
| ✅ **变更可控** | 变更请求流程确保所有团队同步更新 |

---

## 2. 仓库结构

### 2.1 公共协作仓库

```
team-collaboration/
├── .collaboration/
│   ├── features/                       # 功能设计目录
│   │   └── {feature-name}/
│   │       ├── prd.md                  # 产品需求文档
│   │       ├── design.md               # UI/UX 设计方案
│   │       ├── design-components.md    # 组件设计源码
│   │       ├── tech.md                 # 技术架构方案
│   │       ├── api.yaml                # API 契约 (OpenAPI 3.0)
│   │       ├── review.md               # 联合评审记录
│   │       └── changes/                # 变更请求目录
│   │           └── CR-{sequence}.md
│   ├── releases/                       # 版本发布目录
│   │   └── {feature-name}/
│   │       ├── manifest.json           # 版本清单
│   │       └── v{version}.json         # 版本快照
│   └── shared/                         # 共享资源
│       ├── coding-standards.md
│       └── db/
│           └── schema.sql
├── scripts/
│   ├── sync-collab.sh                  # 同步脚本
│   └── verify-versions.sh              # 版本验证脚本
├── .gitea/
│   └── workflows/
│       ├── notify-changes.yml          # 变更通知工作流
│       ├── create-release.yml          # 版本快照工作流
│       └── sync-features.yml           # 自动同步工作流
└── README.md
```

### 2.2 各端代码仓库

```
frontend/
├── .collaboration/                     # 同步的设计文档（只读）
│   └── features/
│       └── mobile-login/
│           ├── design.md
│           └── api.yaml
├── src/
│   ├── pages/                          # 前端页面代码
│   └── api/                            # API 客户端代码
├── sync-collab.sh                      # 同步脚本
└── package.json

backend/
├── .collaboration/                     # 同步的设计文档（只读）
│   └── features/
│       └── mobile-login/
│           ├── api.yaml
│           └── tech.md
├── src/
│   ├── modules/                        # 后端模块代码
│   └── controllers/                    # API 控制器
├── sync-collab.sh                      # 同步脚本
└── package.json

miniprogram/
├── .collaboration/                     # 同步的设计文档（只读）
│   └── features/
│       └── mobile-login/
│           ├── design.md
│           └── api.yaml
├── src/
│   └── pages/                          # 小程序页面
└── sync-collab.sh                      # 同步脚本
```

---

## 3. 版本管理机制

### 3.1 版本号规范

采用**语义化版本 + 状态后缀**:

```
{major}.{minor}.{patch}-{status}

示例:
0.1.0-draft      # 初稿
0.2.0-draft      # 修改稿
1.0.0-in-review  # 评审中
1.0.0-FROZEN     # 已冻结 (生产版本)
1.1.0-draft      # 变更后的新版本
```

### 3.2 YAML Frontmatter 规范

所有设计文档必须包含版本信息:

```yaml
# prd.md / design.md / tech.md
---
feature: mobile-login
type: prd  # prd | design | tech | api
version: 1.0.0
status: frozen  # draft | in-review | frozen | deprecated | superseded
frozen-at: 2026-03-19T10:00:00Z
frozen-by: review-001
successor: null
dependencies:
  - design.md@1.0.0
  - api.yaml@1.0.0
change-requests: []
---

# api.yaml
---
feature: mobile-login
type: api
version: 1.0.0
status: frozen
frozen-at: 2026-03-19T10:00:00Z
openapi: "3.0.0"
---
```

### 3.3 版本清单 (manifest.json)

```json
{
  "feature": "mobile-login",
  "current_version": "1.0.0",
  "status": "frozen",
  "frozen_at": "2026-03-19T10:00:00Z",
  "artifacts": {
    "prd.md": {
      "version": "1.0.0",
      "sha256": "abc123def456...",
      "status": "frozen"
    },
    "api.yaml": {
      "version": "1.0.0",
      "sha256": "def456ghi789...",
      "status": "frozen"
    },
    "design.md": {
      "version": "1.0.0",
      "sha256": "ghi789jkl012...",
      "status": "frozen"
    },
    "tech.md": {
      "version": "1.0.0",
      "sha256": "jkl012mno345...",
      "status": "frozen"
    }
  },
  "synced_to": {
    "frontend": "main@abc123",
    "backend": "main@def456",
    "miniprogram": "main@ghi789"
  },
  "history": [
    {
      "version": "1.0.0",
      "frozen_at": "2026-03-19T10:00:00Z",
      "review_id": "review-001"
    }
  ]
}
```

---

## 4. 同步策略

### 4.1 同步脚本

```bash
#!/bin/bash
# sync-collab.sh - 全量同步 .collaboration 目录

set -e

# 配置
GITEA_BASE="${GITEA_BASE:-https://gitea.your-domain.com}"
REPO_PATH="${GITEA_REPO:-your-org/team-collaboration}"
BRANCH="${GITEA_BRANCH:-main}"
FEATURE="${1:-}"

GITEA_REPO="${GITEA_BASE}/${REPO_PATH}.git"
TEMP_DIR="/tmp/collab-repo-$$"

echo "🔄 开始同步 .collaboration 目录..."
echo "   仓库：${GITEA_REPO}"
echo "   分支：${BRANCH}"

# 清理旧临时目录
rm -rf "$TEMP_DIR"

# 浅克隆 (只下载最新提交)
git clone --depth 1 --branch "$BRANCH" "$GITEA_REPO" "$TEMP_DIR" 2>/dev/null

# 检查 .collaboration 目录
if [ ! -d "$TEMP_DIR/.collaboration" ]; then
    echo "❌ 错误：目标仓库中不存在 .collaboration 目录"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# 同步到当前仓库 (覆盖模式)
rsync -av --delete "$TEMP_DIR/.collaboration/" ./.collaboration/

# 版本验证
if [ -n "$FEATURE" ]; then
    echo "🔍 验证 $FEATURE 版本一致性..."
    
    MANIFEST=".collaboration/releases/$FEATURE/manifest.json"
    if [ -f "$MANIFEST" ]; then
        CURRENT_VERSION=$(cat "$MANIFEST" | jq -r '.current_version')
        echo "✅ 当前版本：$CURRENT_VERSION"
        
        # 验证所有文件哈希
        for file in prd.md api.yaml design.md tech.md; do
            FILE_PATH=".collaboration/features/$FEATURE/$file"
            if [ -f "$FILE_PATH" ]; then
                EXPECTED_HASH=$(cat "$MANIFEST" | jq -r ".artifacts[\"$file\"].sha256")
                ACTUAL_HASH=$(sha256sum "$FILE_PATH" | cut -d' ' -f1)
                
                if [ "$EXPECTED_HASH" != "$ACTUAL_HASH" ]; then
                    echo "❌ 哈希不匹配：$file"
                    echo "   期望：$EXPECTED_HASH"
                    echo "   实际：$ACTUAL_HASH"
                    exit 1
                fi
            fi
        done
        echo "✅ 版本一致性验证通过"
    else
        echo "⚠️ 未找到版本清单，跳过验证"
    fi
fi

# 清理临时目录
rm -rf "$TEMP_DIR"

echo "✅ 同步完成"
echo ""
echo "📁 同步内容:"
find .collaboration -type f | head -20
FILE_COUNT=$(find .collaboration -type f | wc -l)
if [ $FILE_COUNT -gt 20 ]; then
    echo "   ... 共 $FILE_COUNT 个文件"
fi
```

### 4.2 使用方法

```bash
# 同步整个 .collaboration 目录
./sync-collab.sh

# 同步并验证特定功能的版本
./sync-collab.sh mobile-login

# 指定 Gitea 配置
GITEA_BASE=https://gitea.example.com \
GITEA_REPO=your-org/team-collaboration \
./sync-collab.sh
```

### 4.3 Gitea Actions 自动同步

```yaml
# .gitea/workflows/sync-collab.yml
name: '🔄 同步协作文件'

on:
  schedule:
    - cron: '0 * * * *'  # 每小时整点
  workflow_dispatch:      # 手动触发

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: 检出代码
        uses: actions/checkout@v4

      - name: 同步 .collaboration 目录
        run: |
          GITEA_BASE="${{ vars.GITEA_BASE }}"
          REPO_PATH="${{ vars.COLLAB_REPO_PATH }}"
          BRANCH="${{ vars.COLLAB_BRANCH }}"
          GITEA_REPO="${GITEA_BASE}/${REPO_PATH}.git"
          TEMP_DIR="/tmp/collab-repo"
          
          git clone --depth 1 --branch "$BRANCH" "$GITEA_REPO" "$TEMP_DIR"
          rsync -av --delete "$TEMP_DIR/.collaboration/" ./.collaboration/
          rm -rf "$TEMP_DIR"
          
      - name: 提交变更
        run: |
          git config user.name "Gitea Actions"
          git config user.email "actions@gitea.local"
          if ! git diff --quiet; then
            git add .collaboration
            git commit -m "chore: 自动同步 .collaboration 目录 [skip ci]"
            git push
            echo "✅ 已提交同步的变更"
          else
            echo "ℹ️ 无变更，跳过提交"
          fi
```

---

## 5. 设计冻结流程

### 5.1 冻结触发条件

当联合评审通过后，自动触发设计冻结：

```markdown
## 联合评审结论

✅ **通过** - 可以进入开发阶段

### 冻结信息
- **冻结版本**: 1.0.0
- **冻结时间**: 2026-03-19T10:00:00Z
- **评审记录**: review-001
```

### 5.2 Gitea Actions 自动冻结

```yaml
# .gitea/workflows/create-release.yml
name: '🔒 创建设计快照'

on:
  push:
    paths: ['.collaboration/features/**/review.md']

jobs:
  snapshot:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: 检测评审通过
        id: check
        run: |
          if grep -q "✅ 评审通过" .collaboration/features/*/review.md; then
            FEATURE=$(grep -l "✅ 评审通过" .collaboration/features/*/review.md | head -1 | cut -d'/' -f4)
            echo "::set-output name=feature::$FEATURE"
            echo "::set-output name=passed::true"
          fi
          
      - name: 创建版本快照
        if: steps.check.outputs.passed == 'true'
        run: |
          FEATURE="${{ steps.check.outputs.feature }}"
          VERSION=$(date +%Y%m%d-%H%M)
          
          mkdir -p .collaboration/releases/$FEATURE
          
          # 创建 manifest
          cat > .collaboration/releases/$FEATURE/manifest.json <<EOF
          {
            "feature": "$FEATURE",
            "current_version": "$VERSION",
            "status": "frozen",
            "frozen_at": "$(date -Iseconds)",
            "artifacts": {
              "prd.md": {
                "version": "$VERSION",
                "sha256": "$(sha256sum .collaboration/features/$FEATURE/prd.md | cut -d' ' -f1)",
                "status": "frozen"
              },
              "api.yaml": {
                "version": "$VERSION",
                "sha256": "$(sha256sum .collaboration/features/$FEATURE/api.yaml | cut -d' ' -f1)",
                "status": "frozen"
              },
              "design.md": {
                "version": "$VERSION",
                "sha256": "$(sha256sum .collaboration/features/$FEATURE/design.md | cut -d' ' -f1)",
                "status": "frozen"
              },
              "tech.md": {
                "version": "$VERSION",
                "sha256": "$(sha256sum .collaboration/features/$FEATURE/tech.md | cut -d' ' -f1)",
                "status": "frozen"
              }
            }
          }
          EOF
          
          # 更新所有文件的 frontmatter
          for file in prd.md design.md tech.md; do
            if [ -f ".collaboration/features/$FEATURE/$file" ]; then
              sed -i "s/^version: .*/version: $VERSION/" ".collaboration/features/$FEATURE/$file"
              sed -i "s/^status: .*/status: frozen/" ".collaboration/features/$FEATURE/$file"
              sed -i "/^frozen-at:/d" ".collaboration/features/$FEATURE/$file"
              sed -i "/^frozen-by:/d" ".collaboration/features/$FEATURE/$file"
              sed -i "/^---/a frozen-at: $(date -Iseconds)\nfrozen-by: review-001" ".collaboration/features/$FEATURE/$file"
            fi
          done
          
          git add .collaboration
          git commit -m "release: $FEATURE@$VERSION [skip ci]"
          git push
          
          echo "✅ 已创建版本快照：$FEATURE@$VERSION"
```

### 5.3 冻结后的变更限制

设计冻结后，任何修改必须走**变更请求流程**:

```bash
# 冻结状态下直接修改会触发警告
if grep -q "status: frozen" .collaboration/features/mobile-login/prd.md; then
    echo "⚠️ 警告：文档已冻结，请创建变更请求 (CR)"
    echo "   路径：.collaboration/features/mobile-login/changes/CR-{sequence}.md"
    exit 1
fi
```

---

## 6. 变更请求流程

### 6.1 变更请求模板

```markdown
# Change Request: CR-001

**功能**: mobile-login  
**申请人**: @zhangsan  
**申请日期**: 2026-03-25  
**状态**: pending | approved | rejected

## 变更原因
用户反馈需要支持国际区号选择器。

## 影响范围
- [x] PRD 需要更新（增加区号选择需求）
- [ ] API 需要更新（无需改动）
- [x] 设计需要更新（登录页增加区号选择器）
- [ ] 技术方案需要更新（无需改动）

## 变更详情

### PRD 变更
增加用户故事：
- 作为国际用户，我希望选择国家区号，以便正确输入手机号

### 设计变更
登录页面增加国家区号选择器组件

## 审批记录
| 角色 | 审批人 | 意见 | 日期 |
|------|--------|------|------|
| PM | @lisi | ✅ 同意 | 2026-03-25 |
| Tech Lead | @wangwu | ✅ 同意 | 2026-03-25 |
| 设计负责人 | @zhaoliu | ✅ 同意 | 2026-03-25 |

## 执行记录
- [x] 创建变更请求
- [x] 审批通过
- [x] PRD 更新为 v1.1.0-draft
- [x] 设计更新为 v1.1.0-draft
- [x] 重新评审
- [x] 评审通过
- [x] 冻结为 v1.1.0-FROZEN
- [x] 通知各端团队同步
```

### 6.2 变更审批工作流

```yaml
# .gitea/workflows/approve-cr.yml
name: '📝 审批变更请求'

on:
  pull_request:
    paths: ['.collaboration/features/**/changes/CR-*.md']

jobs:
  approve:
    runs-on: ubuntu-latest
    steps:
      - name: 检查审批人
        run: |
          if [[ ! "${{ github.event.pull_request.user.login }}" =~ ^(pm-lead|tech-lead|design-lead)$ ]]; then
            echo "❌ 只有 PM、Tech Lead、设计负责人可以提交变更请求"
            exit 1
          fi
          
      - name: 验证变更影响范围
        run: |
          CR_FILE="${{ github.event.pull_request.base.ref }}"
          if ! grep -q "影响范围" "$CR_FILE"; then
            echo "❌ 变更请求必须包含影响范围"
            exit 1
          fi
          
      - name: 自动通知相关团队
        run: |
          curl -X POST "${{ secrets.WEBHOOK_URL }}" \
            -d '{"event": "cr_submitted", "cr": "${{ github.event.pull_request.number }}"}'
```

---

## 7. Gitea 配置

### 7.1 仓库变量配置

在 Gitea 仓库设置中配置以下变量：

| 变量名 | 说明 | 示例值 |
|--------|------|--------|
| `GITEA_BASE` | Gitea 地址 | `https://gitea.your-domain.com` |
| `COLLAB_REPO_PATH` | 协作仓库路径 | `your-org/team-collaboration` |
| `COLLAB_BRANCH` | 协作仓库分支 | `main` |
| `WEBHOOK_URL` | 变更通知 Webhook | `https://hooks.example.com/design` |

### 7.2 Webhook 配置

```yaml
# Gitea 仓库 → Webhook
URL: https://your-webhook.com/design-changed
触发事件:
  - Push events (paths: .collaboration/features/**)
  - Pull request events
内容类型: application/json
```

### 7.3 权限配置

| 角色 | 权限 |
|------|------|
| Product Manager | 创建/修改 PRD、提交 CR |
| Tech Lead | 创建/修改技术方案、审批 CR |
| Design Lead | 创建/修改设计方案、审批 CR |
| Developer | 读取设计文档、评论 CR |
| QA | 读取设计文档、创建 Bug 报告 |

---

## 8. 工作流示例

### 8.1 完整工作流

```bash
# ========== 阶段 1: 设计阶段 ==========
cd team-collaboration

# 1. 产品经理创建 PRD (draft 状态)
skill(name: product-manager)
请创建手机号登录功能的 PRD。

# 输出：.collaboration/features/mobile-login/prd.md
# version: 0.1.0-draft, status: draft

# 2. Master Coordinator 组织并行设计
skill(name: master-coordinator)
请组织 mobile-login 的并行设计和技术方案。
@.collaboration/features/mobile-login/prd.md

# 输出：
# - design.md (v0.1.0-draft)
# - tech.md (v0.1.0-draft)
# - api.yaml (v0.1.0-draft)

# 3. 联合评审（最多 5 轮）
# 评审过程中可能修改设计和技术方案

# ========== 阶段 2: 评审通过，自动冻结 ==========
# Gitea Actions 检测 review.md 中的"✅ 评审通过"
# 自动执行：
# 1. 更新所有文件为 v1.0.0-FROZEN
# 2. 创建 manifest.json
# 3. 计算所有文件 SHA256 哈希
# 4. 发送 Webhook 通知各端团队

# ========== 阶段 3: 各端同步 ==========
# 前端仓库
cd frontend
./sync-collab.sh mobile-login
# 输出：
# 🔄 开始同步 .collaboration 目录...
# 🔍 验证 mobile-login 版本一致性...
# ✅ 当前版本：1.0.0
# ✅ 版本一致性验证通过

skill(name: frontend)
请实现登录页面。
@.collaboration/features/mobile-login/design.md
@.collaboration/features/mobile-login/api.yaml

# 后端仓库
cd backend
./sync-collab.sh mobile-login

skill(name: backend-typescript)
请实现登录接口。
@.collaboration/features/mobile-login/api.yaml
@.collaboration/features/mobile-login/tech.md

# 小程序仓库
cd miniprogram
./sync-collab.sh mobile-login

skill(name: frontend)
请实现小程序登录页面。
@.collaboration/features/mobile-login/design.md

# ========== 阶段 4: 变更请求 ==========
# 需求变更时（如增加国际区号支持）
cd team-collaboration

# 创建变更请求
cat > .collaboration/features/mobile-login/changes/CR-001.md <<EOF
# Change Request: CR-001
...
EOF

# 提交 CR 并等待审批
git add .
git commit -m "cr: CR-001 增加国际区号支持"
git push

# 审批通过后，更新设计为 v1.1.0-draft，重新评审
# 评审通过后冻结为 v1.1.0-FROZEN，通知各端同步
```

### 8.2 日常开发流程

```bash
# 前端开发者小王的一天

# 1. 早上开始工作
cd frontend
git pull
./sync-collab.sh mobile-login  # 同步最新设计

# 2. 查看设计文档
cat .collaboration/features/mobile-login/design.md

# 3. 开始开发
skill(name: frontend)
请基于设计方案开发登录页面。
@.collaboration/features/mobile-login/design.md
@.collaboration/features/mobile-login/design-components.md
@.collaboration/features/mobile-login/api.yaml

# 4. 收到设计变更通知（Webhook → Slack）
# "mobile-login 设计已更新为 v1.1.0-FROZEN"

# 5. 同步新版本
./sync-collab.sh mobile-login

# 6. 根据新设计调整代码
skill(name: frontend)
设计已更新为 v1.1.0，请调整登录页面增加区号选择器。
@.collaboration/features/mobile-login/design.md
```

---

## 9. 质量检查清单

### 9.1 设计阶段检查

- [ ] PRD 文档包含 YAML frontmatter
- [ ] 版本号符合语义化规范
- [ ] 用户故事完整（至少 5 个）
- [ ] 验收条件可量化、可测试
- [ ] 优先级明确（P0/P1/P2）
- [ ] 数据埋点完整

### 9.2 评审阶段检查

- [ ] Frontend-Design 输出 design.md + design-components.md
- [ ] Tech Lead 输出 tech.md + api.yaml
- [ ] 冲突检测完成（4 个维度）
- [ ] 联合评审通过（最多 5 轮）
- [ ] review.md 记录完整

### 9.3 冻结阶段检查

- [ ] 所有文件版本一致
- [ ] manifest.json 已创建
- [ ] SHA256 哈希已计算
- [ ] status 更新为 frozen
- [ ] frozen-at 时间戳已设置
- [ ] Webhook 通知已发送

### 9.4 同步阶段检查

- [ ] 各端仓库执行同步脚本
- [ ] 版本一致性验证通过
- [ ] 哈希匹配验证通过
- [ ] 各端团队确认收到通知

### 9.5 变更阶段检查

- [ ] 变更请求 CR 已创建
- [ ] 影响范围分析完整
- [ ] 所有相关角色审批通过
- [ ] 变更执行记录完整
- [ ] 新版本已冻结
- [ ] 各端团队已同步

---

## 附录 A：常见问题

### Q1: 同步失败怎么办？

```bash
# 检查网络
curl -I https://gitea.your-domain.com/your-org/team-collaboration

# 手动重试
./sync-collab.sh mobile-login

# 查看详细日志
bash -x ./sync-collab.sh mobile-login
```

### Q2: 版本不一致如何处理？

```bash
# 检查 manifest.json
cat .collaboration/releases/mobile-login/manifest.json

# 检查文件哈希
sha256sum .collaboration/features/mobile-login/prd.md

# 如果不匹配，重新同步
rm -rf .collaboration
./sync-collab.sh mobile-login
```

### Q3: 紧急变更如何快速处理？

```bash
# 1. 创建紧急 CR
cat > .collaboration/features/mobile-login/changes/CR-URGENT-001.md

# 2. 快速审批（可跳过部分流程）
# 3. 更新设计为 vX.Y.Z-draft
# 4. 开发完成后补评审
# 5. 冻结为新版本
```

---

## 附录 B：工具推荐

| 工具 | 用途 | 配置 |
|------|------|------|
| **jq** | JSON 处理 | `brew install jq` |
| **rsync** | 文件同步 | macOS 自带 |
| **Gitea Actions** | CI/CD | Gitea 1.19+ |
| **OpenCode** | AI 编程 | `npm install -g opencode` |

---

## 附录 C：相关文件

- [QUICKSTART.md](../QUICKSTART.md) - 5 分钟快速上手
- [skills/README.md](../skills/README.md) - Skills 使用指南
- [REQUIREMENT-FLOW-ANALYSIS.md](../REQUIREMENT-FLOW-ANALYSIS.md) - 需求流转深度分析

---

**文档维护**: team-collaboration 维护团队  
**最后更新**: 2026-03-19
