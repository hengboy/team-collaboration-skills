#!/bin/bash

# new-prd.sh - 创建新 PRD 工具
# 用途：快速创建新的 PRD 文档框架

set -e

# 配置
DOCS_DIR="${DOCS_DIR:-docs}"
TEMPLATES_DIR="${TEMPLATES_DIR:-templates}"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
    cat << EOF
创建新 PRD 文档

用法：$0 <需求名称> [选项]

选项:
  -p, --priority   优先级 (P0|P1|P2) (默认：P1)
  -a, --author     作者 (@username) (默认：当前用户)
  -h, --help       显示帮助

示例:
  $0 用户登录功能优化
  $0 购物车功能 -p P0 -a @zhangsan

EOF
    exit 1
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 解析参数
PRIORITY="P1"
AUTHOR="@$(whoami)"

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--priority)
            PRIORITY="$2"
            shift 2
            ;;
        -a|--author)
            AUTHOR="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            if [[ -z "$FEATURE_NAME" ]]; then
                FEATURE_NAME="$1"
            else
                log_error "未知参数：$1"
                usage
            fi
            shift
            ;;
    esac
done

# 验证参数
if [[ -z "$FEATURE_NAME" ]]; then
    log_error "缺少必要参数：需求名称"
    usage
fi

# 验证优先级
if [[ ! "$PRIORITY" =~ ^P[0-2]$ ]]; then
    log_error "无效的优先级：$PRIORITY (应该是 P0, P1, 或 P2)"
    exit 1
fi

# 生成 PRD ID
YEAR=$(date +%Y)
PRD_COUNT=$(find "$DOCS_DIR/prd" -name "PRD-${YEAR}-*.md" 2>/dev/null | wc -l)
PRD_NUM=$(printf "%03d" $((PRD_COUNT + 1)))
PRD_ID="PRD-${YEAR}-${PRD_NUM}"

# 生成文件名
FILE_NAME=$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
OUTPUT_FILE="$DOCS_DIR/prd/${FILE_NAME}.md"

# 创建目录
mkdir -p "$DOCS_DIR/prd"

log_info "创建新 PRD 文档..."
log_info "PRD ID: $PRD_ID"
log_info "需求名称：$FEATURE_NAME"
log_info "优先级：$PRIORITY"
log_info "作者：$AUTHOR"
log_info "输出文件：$OUTPUT_FILE"

# 生成 PRD 内容
cat > "$OUTPUT_FILE" << EOF
---
id: ${PRD_ID}
title: ${FEATURE_NAME}
product-manager: ${AUTHOR}
create-date: $(date +%Y-%m-%d)
priority: ${PRIORITY}
status: draft
---

# 需求背景

## 问题描述

<!-- 描述当前存在的问题或机会 -->

## 目标用户

<!-- 描述目标用户群体 -->

## 业务目标

<!-- 描述业务目标和预期效果，尽量量化 -->

# 用户故事

| ID | 作为 | 我想要 | 以便于 | 优先级 |
|----|------|--------|--------|--------|
| US-001 | 用户 | ... | ... | P0 |

# 功能需求

## FR-001: 功能名称

### 描述

<!-- 详细描述功能 -->

### 验收条件

- [ ] 验收条件 1
- [ ] 验收条件 2
- [ ] 验收条件 3

# 非功能需求

## 性能要求

- 接口 P95 延迟：< 500ms
- 支持 QPS: > 100

## 安全要求

- 数据传输使用 HTTPS
- 敏感数据加密存储

## 监控要求

- 关键指标监控
- 异常告警

# 数据埋点

| 事件 | 触发时机 | 参数 |
|------|----------|------|
| event_name | 触发时机 | param1, param2 |

# 附录

## 竞品参考

- 竞品 A: ...
- 竞品 B: ...

## 相关文档

- 技术方案：docs/tech/${PRD_ID}.md
- API 文档：docs/api/${FILE_NAME}.yaml

EOF

log_info "PRD 文档创建完成!"
echo ""
echo "下一步:"
echo "1. 编辑 $OUTPUT_FILE 填写需求详情"
echo "2. 使用 AI 辅助完善用户故事和验收条件"
echo "3. 提交评审"
echo ""
echo "AI 提示词示例:"
echo ""
echo "  请根据以下原始需求，完善 PRD 文档："
echo "  {粘贴原始需求}"
echo ""
