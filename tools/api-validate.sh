#!/bin/bash

# api-validate.sh - API 契约验证工具
# 用途：验证 OpenAPI 文档的规范性和完整性

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
    cat << EOF
API 契约验证工具

用法：$0 <API 文件> [选项]

选项:
  -s, --strict   严格模式（警告也视为错误）
  -r, --report   输出详细报告
  -h, --help     显示帮助

示例:
  $0 docs/api/auth.yaml
  $0 docs/api/auth.yaml -s -r

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

STRICT_MODE=false
REPORT=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--strict)
            STRICT_MODE=true
            shift
            ;;
        -r|--report)
            REPORT=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            if [[ -z "$API_FILE" ]]; then
                API_FILE="$1"
            else
                log_error "未知参数：$1"
                usage
            fi
            shift
            ;;
    esac
done

if [[ -z "$API_FILE" ]]; then
    log_error "缺少必要参数：API 文件"
    usage
fi

if [[ ! -f "$API_FILE" ]]; then
    log_error "文件不存在：$API_FILE"
    exit 1
fi

log_info "验证 API 契约：$API_FILE"
echo ""

ERRORS=0
WARNINGS=0

# 检查 OpenAPI 版本
check_openapi_version() {
    if grep -q "^openapi:" "$API_FILE"; then
        VERSION=$(grep "^openapi:" "$API_FILE" | cut -d'"' -f2)
        if [[ "$VERSION" =~ ^3\.[0-9]+\.[0-9]+$ ]]; then
            log_info "✓ OpenAPI 版本：$VERSION"
        else
            log_error "✗ OpenAPI 版本格式错误：$VERSION"
            ((ERRORS++))
        fi
    else
        log_error "✗ 缺少 openapi 字段"
        ((ERRORS++))
    fi
}

# 检查 info 字段
check_info() {
    if grep -q "^info:" "$API_FILE"; then
        log_info "✓ info 字段存在"
        
        if grep -q "title:" "$API_FILE"; then
            log_info "  ✓ title 存在"
        else
            log_error "  ✗ 缺少 title"
            ((ERRORS++))
        fi
        
        if grep -q "version:" "$API_FILE"; then
            log_info "  ✓ version 存在"
        else
            log_error "  ✗ 缺少 version"
            ((ERRORS++))
        fi
        
        if grep -q "description:" "$API_FILE"; then
            log_info "  ✓ description 存在"
        else
            log_warn "  ! 缺少 description"
            ((WARNINGS++))
        fi
    else
        log_error "✗ 缺少 info 字段"
        ((ERRORS++))
    fi
}

# 检查 paths
check_paths() {
    if grep -q "^paths:" "$API_FILE"; then
        PATH_COUNT=$(grep -c "^  /" "$API_FILE" || echo "0")
        log_info "✓ paths 存在，共 $PATH_COUNT 个端点"
        
        if [[ "$PATH_COUNT" -eq 0 ]]; then
            log_warn "  ! 没有定义任何端点"
            ((WARNINGS++))
        fi
    else
        log_error "✗ 缺少 paths 字段"
        ((ERRORS++))
    fi
}

# 检查 components/schemas
check_schemas() {
    if grep -q "^components:" "$API_FILE" && grep -q "schemas:" "$API_FILE"; then
        SCHEMA_COUNT=$(grep -c "^    [a-zA-Z].*:$" "$API_FILE" 2>/dev/null || echo "0")
        log_info "✓ components/schemas 存在，共 $SCHEMA_COUNT 个模型"
    else
        log_warn "! 缺少 components/schemas"
        ((WARNINGS++))
    fi
}

# 检查请求/响应定义
check_request_response() {
    log_info "检查请求/响应定义..."
    
    # 检查每个端点的 requestBody
    ENDPOINTS_WITHOUT_REQUEST=$(grep -B5 "get:" "$API_FILE" | grep -c "^  /" || echo "0")
    ENDPOINTS_WITH_REQUEST=$(grep -c "requestBody:" "$API_FILE" || echo "0")
    
    log_info "  ✓ 有 $ENDPOINTS_WITH_REQUEST 个端点定义了 requestBody"
    
    # 检查 responses
    RESPONSE_COUNT=$(grep -c "responses:" "$API_FILE" || echo "0")
    log_info "  ✓ 有 $RESPONSE_COUNT 个端点定义了 responses"
}

# 检查错误响应
check_error_responses() {
    log_info "检查错误响应定义..."
    
    ERROR_400=$(grep -c "'400':" "$API_FILE" || echo "0")
    ERROR_401=$(grep -c "'401':" "$API_FILE" || echo "0")
    ERROR_404=$(grep -c "'404':" "$API_FILE" || echo "0")
    ERROR_500=$(grep -c "'500':" "$API_FILE" || echo "0")
    
    log_info "  - 400 响应：$ERROR_400 个"
    log_info "  - 401 响应：$ERROR_401 个"
    log_info "  - 404 响应：$ERROR_404 个"
    log_info "  - 500 响应：$ERROR_500 个"
    
    if [[ "$ERROR_400" -eq 0 ]]; then
        log_warn "  ! 没有定义 400 响应"
        ((WARNINGS++))
    fi
}

# 检查安全定义
check_security() {
    if grep -q "securitySchemes:" "$API_FILE"; then
        log_info "✓ securitySchemes 存在"
        
        if grep -q "bearerAuth:" "$API_FILE" || grep -q "apiKey:" "$API_FILE"; then
            log_info "  ✓ 定义了认证方案"
        else
            log_warn "  ! 未定义常见的认证方案"
            ((WARNINGS++))
        fi
    else
        if grep -q "security:" "$API_FILE"; then
            log_warn "  ! 使用了 security 但未定义 securitySchemes"
            ((WARNINGS++))
        fi
    fi
}

# 运行所有检查
echo "=================================="
echo "API 契约验证报告"
echo "=================================="
echo ""

check_openapi_version
check_info
check_paths
check_schemas
check_request_response
check_error_responses
check_security

echo ""
echo "=================================="
echo "验证结果"
echo "=================================="
echo ""
echo "错误数：$ERRORS"
echo "警告数：$WARNINGS"
echo ""

if [[ "$REPORT" == true ]]; then
    echo "详细报告：$API_FILE.report.md"
    
    cat > "${API_FILE}.report.md" << EOF
# API 契约验证报告

**文件**: $API_FILE
**时间**: $(date '+%Y-%m-%d %H:%M:%S')

## 结果

- 错误：$ERRORS
- 警告：$WARNINGS

## 详情

$(cat "$API_FILE")

EOF
fi

if [[ "$ERRORS" -gt 0 ]]; then
    log_error "验证失败"
    exit 1
elif [[ "$STRICT_MODE" == true ]] && [[ "$WARNINGS" -gt 0 ]]; then
    log_error "严格模式下验证失败（有警告）"
    exit 1
else
    log_info "验证通过"
    exit 0
fi
