#!/bin/bash

# context-pack.sh - 上下文打包工具
# 用途：收集与当前任务相关的所有文档，打包成 AI 可读的上下文

set -e

# 配置
DOCS_DIR="${DOCS_DIR:-docs}"
OUTPUT_DIR="${OUTPUT_DIR:-.context}"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    cat << EOF
上下文打包工具

用法：$0 <任务类型> <任务名称> [选项]

任务类型:
  prd       - 需求分析
  tech      - 技术方案
  backend   - 后端开发
  frontend  - 前端开发
  qa        - 测试用例

选项:
  -o, --output    输出目录 (默认：.context)
  -f, --format    输出格式 (markdown|json) (默认：markdown)
  -h, --help      显示帮助

示例:
  $0 prd 用户登录功能
  $0 backend 用户登录 -o ./context
  $0 qa 用户登录 -f json

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
TASK_TYPE=""
TASK_NAME=""
FORMAT="markdown"

while [[ $# -gt 0 ]]; do
    case $1 in
        prd|tech|backend|frontend|qa)
            TASK_TYPE="$1"
            shift
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -f|--format)
            FORMAT="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            if [[ -z "$TASK_NAME" ]]; then
                TASK_NAME="$1"
            else
                log_error "未知参数：$1"
                usage
            fi
            shift
            ;;
    esac
done

# 验证参数
if [[ -z "$TASK_TYPE" ]] || [[ -z "$TASK_NAME" ]]; then
    log_error "缺少必要参数"
    usage
fi

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 生成上下文文件名
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CONTEXT_FILE="${OUTPUT_DIR}/context_${TASK_TYPE}_${TIMESTAMP}.md"

log_info "开始打包上下文..."
log_info "任务类型：$TASK_TYPE"
log_info "任务名称：$TASK_NAME"
log_info "输出文件：$CONTEXT_FILE"

# 初始化上下文文件
cat > "$CONTEXT_FILE" << EOF
# AI 协作上下文

**任务类型**: $TASK_TYPE
**任务名称**: $TASK_NAME
**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')

---

EOF

# 根据任务类型收集文档
collect_docs() {
    case $TASK_TYPE in
        prd)
            # PRD 任务：收集原始需求、用户反馈
            log_info "收集需求相关文档..."
            
            if [[ -f "$DOCS_DIR/requirements/raw.md" ]]; then
                echo "## 原始需求" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$DOCS_DIR/requirements/raw.md" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ 原始需求"
            fi
            
            if [[ -f "$DOCS_DIR/feedback/user-feedback.md" ]]; then
                echo "## 用户反馈" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$DOCS_DIR/feedback/user-feedback.md" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ 用户反馈"
            fi
            
            if [[ -f "$DOCS_DIR/metrics/login-conversion.md" ]]; then
                echo "## 相关数据" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$DOCS_DIR/metrics/login-conversion.md" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ 相关数据"
            fi
            ;;
            
        tech)
            # 技术方案任务：收集 PRD、现有架构文档
            log_info "收集技术方案相关文档..."
            
            PRD_FILE=$(find "$DOCS_DIR/prd" -name "*${TASK_NAME}*" -type f | head -1)
            if [[ -n "$PRD_FILE" ]] && [[ -f "$PRD_FILE" ]]; then
                echo "## PRD 文档" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                echo "来源：$PRD_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$PRD_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ PRD 文档：$PRD_FILE"
            else
                log_warn "  ! 未找到 PRD 文档"
            fi
            
            if [[ -f "$DOCS_DIR/architecture/current.md" ]]; then
                echo "## 现有架构" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$DOCS_DIR/architecture/current.md" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ 现有架构"
            fi
            
            if [[ -f "$DOCS_DIR/tech-stack.md" ]]; then
                echo "## 技术栈" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$DOCS_DIR/tech-stack.md" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ 技术栈"
            fi
            ;;
            
        backend|frontend)
            # 开发任务：收集 API 契约、技术方案
            log_info "收集开发相关文档..."
            
            API_FILE=$(find "$DOCS_DIR/api" -name "*${TASK_NAME}*" -type f | head -1)
            if [[ -n "$API_FILE" ]] && [[ -f "$API_FILE" ]]; then
                echo "## API 契约" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                echo "来源：$API_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$API_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ API 契约：$API_FILE"
            else
                log_warn "  ! 未找到 API 契约"
            fi
            
            TECH_FILE=$(find "$DOCS_DIR/tech" -name "*${TASK_NAME}*" -type f | head -1)
            if [[ -n "$TECH_FILE" ]] && [[ -f "$TECH_FILE" ]]; then
                echo "## 技术方案" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                echo "来源：$TECH_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$TECH_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ 技术方案：$TECH_FILE"
            fi
            
            if [[ -f "$DOCS_DIR/coding-standards.md" ]]; then
                echo "## 代码规范" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$DOCS_DIR/coding-standards.md" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ 代码规范"
            fi
            ;;
            
        qa)
            # 测试任务：收集 PRD、API 契约、技术方案
            log_info "收集测试相关文档..."
            
            PRD_FILE=$(find "$DOCS_DIR/prd" -name "*${TASK_NAME}*" -type f | head -1)
            if [[ -n "$PRD_FILE" ]] && [[ -f "$PRD_FILE" ]]; then
                echo "## PRD 文档" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                echo "来源：$PRD_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$PRD_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ PRD 文档：$PRD_FILE"
            fi
            
            API_FILE=$(find "$DOCS_DIR/api" -name "*${TASK_NAME}*" -type f | head -1)
            if [[ -n "$API_FILE" ]] && [[ -f "$API_FILE" ]]; then
                echo "## API 契约" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                echo "来源：$API_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$API_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ API 契约：$API_FILE"
            fi
            
            TECH_FILE=$(find "$DOCS_DIR/tech" -name "*${TASK_NAME}*" -type f | head -1)
            if [[ -n "$TECH_FILE" ]] && [[ -f "$TECH_FILE" ]]; then
                echo "## 技术方案" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                echo "来源：$TECH_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                cat "$TECH_FILE" >> "$CONTEXT_FILE"
                echo "" >> "$CONTEXT_FILE"
                log_info "  ✓ 技术方案：$TECH_FILE"
            fi
            ;;
    esac
}

# 添加提示词模板
add_prompt_template() {
    log_info "添加提示词模板..."
    
    TEMPLATE_FILE="templates/prompts/${TASK_TYPE}.md"
    
    if [[ -f "$TEMPLATE_FILE" ]]; then
        echo "---" >> "$CONTEXT_FILE"
        echo "" >> "$CONTEXT_FILE"
        echo "## 提示词模板" >> "$CONTEXT_FILE"
        echo "" >> "$CONTEXT_FILE"
        echo "来源：$TEMPLATE_FILE" >> "$CONTEXT_FILE"
        echo "" >> "$CONTEXT_FILE"
        
        # 提取与当前任务相关的模板部分
        # 这里简化处理，直接包含整个模板
        cat "$TEMPLATE_FILE" >> "$CONTEXT_FILE"
        
        log_info "  ✓ 提示词模板：$TEMPLATE_FILE"
    else
        log_warn "  ! 未找到提示词模板：$TEMPLATE_FILE"
    fi
}

# 添加代码示例
add_code_examples() {
    log_info "添加代码示例..."
    
    EXAMPLE_DIR="examples"
    
    if [[ -d "$EXAMPLE_DIR" ]]; then
        echo "---" >> "$CONTEXT_FILE"
        echo "" >> "$CONTEXT_FILE"
        echo "## 代码示例" >> "$CONTEXT_FILE"
        echo "" >> "$CONTEXT_FILE"
        
        case $TASK_TYPE in
            prd)
                if [[ -f "$EXAMPLE_DIR/prd-example.md" ]]; then
                    cat "$EXAMPLE_DIR/prd-example.md" >> "$CONTEXT_FILE"
                    log_info "  ✓ PRD 示例"
                fi
                ;;
            tech)
                if [[ -f "$EXAMPLE_DIR/tech-example.md" ]]; then
                    cat "$EXAMPLE_DIR/tech-example.md" >> "$CONTEXT_FILE"
                    log_info "  ✓ 技术方案示例"
                fi
                if [[ -f "$EXAMPLE_DIR/api-example.yaml" ]]; then
                    echo "" >> "$CONTEXT_FILE"
                    echo "## API 示例" >> "$CONTEXT_FILE"
                    echo "" >> "$CONTEXT_FILE"
                    cat "$EXAMPLE_DIR/api-example.yaml" >> "$CONTEXT_FILE"
                    log_info "  ✓ API 示例"
                fi
                ;;
            backend)
                if [[ -f "$EXAMPLE_DIR/backend-example.ts" ]]; then
                    cat "$EXAMPLE_DIR/backend-example.ts" >> "$CONTEXT_FILE"
                    log_info "  ✓ 后端代码示例"
                fi
                ;;
            frontend)
                if [[ -f "$EXAMPLE_DIR/frontend-example.tsx" ]]; then
                    cat "$EXAMPLE_DIR/frontend-example.tsx" >> "$CONTEXT_FILE"
                    log_info "  ✓ 前端代码示例"
                fi
                ;;
            qa)
                if [[ -f "$EXAMPLE_DIR/test-cases-example.md" ]]; then
                    cat "$EXAMPLE_DIR/test-cases-example.md" >> "$CONTEXT_FILE"
                    log_info "  ✓ 测试用例示例"
                fi
                ;;
        esac
    fi
}

# 执行收集
collect_docs
add_prompt_template
add_code_examples

# 输出统计
WORD_COUNT=$(wc -l < "$CONTEXT_FILE")
log_info "上下文打包完成!"
log_info "总行数：$WORD_COUNT"
log_info "输出文件：$CONTEXT_FILE"

# 显示使用建议
echo ""
echo "=================================="
echo "使用建议:"
echo "=================================="
echo ""
echo "1. 将 $CONTEXT_FILE 的内容复制到 AI 对话框"
echo "2. 在末尾添加你的具体任务描述"
echo "3. 运行 AI 生成结果"
echo ""
echo "示例提示词:"
echo ""
echo "  请根据上述上下文，完成以下任务："
echo "  1. {任务描述}"
echo "  2. {输出要求}"
echo "  3. {格式要求}"
echo ""
