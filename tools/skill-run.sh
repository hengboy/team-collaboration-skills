#!/bin/bash

# skill-run.sh - Skill 运行工具
# 用途：加载 Skill 并打包上下文（用于 Claude 等不支持@引用的工具）

set -e

SKILLS_DIR="$HOME/AiHistorys/ai-team-cooperation/skills"
CONTEXT_DIR=".ai-context"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
    cat << USAGE
Skill 运行工具

用法：$0 <skill-name> [options]

Skill 名称:
  product-manager    产品经理
  project-manager    项目经理
  tech-lead          技术负责人
  backend-engineer   后端工程师
  frontend-engineer  前端工程师
  qa-engineer        测试工程师
  code-reviewer      代码审查

选项:
  -c, --context    打包上下文（用于 Claude）
  -h, --help       显示帮助

示例:
  # OpenCode 使用（直接用@引用文件）
  opencode
  skill(name: backend-engineer)

  # Claude 使用（打包上下文）
  $0 backend-engineer -c 手机号登录

USAGE
    exit 1
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

pack_context() {
    local skill_name="$1"
    local feature_name="$2"
    local output_file="${CONTEXT_DIR}/context_${skill_name}_$(date +%Y%m%d_%H%M%S).md"
    
    mkdir -p "$CONTEXT_DIR"
    
    cat > "$output_file" << HEADER
# AI 协作上下文

**Skill**: $skill_name
**功能**: $feature_name
**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')

---

HEADER

    # 根据 skill 类型收集文档
    case "$skill_name" in
        product-manager)
            log_info "收集需求相关文档..."
            find docs/prd -name "*${feature_name}*" -type f 2>/dev/null | head -1 | xargs -I {} sh -c 'echo "## PRD 文档\n"; cat {}' >> "$output_file" 2>/dev/null || true
            ;;
        tech-lead)
            log_info "收集技术方案相关文档..."
            find docs/prd -name "*${feature_name}*" -type f 2>/dev/null | head -1 | xargs -I {} sh -c 'echo "## PRD 文档\n"; cat {}' >> "$output_file" 2>/dev/null || true
            ;;
        backend-engineer|frontend-engineer)
            log_info "收集开发相关文档..."
            find docs/api -name "*${feature_name}*" -type f 2>/dev/null | head -1 | xargs -I {} sh -c 'echo "## API 契约\n"; cat {}' >> "$output_file" 2>/dev/null || true
            find docs/tech -name "*${feature_name}*" -type f 2>/dev/null | head -1 | xargs -I {} sh -c 'echo "\n## 技术方案\n"; cat {}' >> "$output_file" 2>/dev/null || true
            ;;
        qa-engineer)
            log_info "收集测试相关文档..."
            find docs/prd -name "*${feature_name}*" -type f 2>/dev/null | head -1 | xargs -I {} sh -c 'echo "## PRD 文档\n"; cat {}' >> "$output_file" 2>/dev/null || true
            find docs/api -name "*${feature_name}*" -type f 2>/dev/null | head -1 | xargs -I {} sh -c 'echo "\n## API 契约\n"; cat {}' >> "$output_file" 2>/dev/null || true
            ;;
    esac
    
    # 添加 Skill 定义
    skill_file="$SKILLS_DIR/$skill_name/SKILL.md"
    if [[ -f "$skill_file" ]]; then
        echo -e "\n---\n\n## Skill 定义\n" >> "$output_file"
        cat "$skill_file" >> "$output_file"
    fi
    
    log_info "上下文打包完成!"
    log_info "输出文件：$output_file"
    echo ""
    echo "=================================="
    echo "使用方式:"
    echo "=================================="
    echo ""
    echo "1. 复制以下内容到 Claude:"
    echo "   cat $output_file | pbcopy"
    echo ""
    echo "2. 在 Claude 中粘贴并描述任务"
    echo ""
}

# 解析参数
SKILL_NAME=""
PACK_CONTEXT=false
FEATURE_NAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        product-manager|project-manager|tech-lead|backend-engineer|frontend-engineer|qa-engineer|code-reviewer)
            SKILL_NAME="$1"
            shift
            ;;
        -c|--context)
            PACK_CONTEXT=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            FEATURE_NAME="$1"
            shift
            ;;
    esac
done

# 验证参数
if [[ -z "$SKILL_NAME" ]]; then
    usage
fi

if [[ "$PACK_CONTEXT" == true ]] && [[ -z "$FEATURE_NAME" ]]; then
    log_warn "打包上下文需要指定功能名称"
    usage
fi

# 执行
if [[ "$PACK_CONTEXT" == true ]]; then
    pack_context "$SKILL_NAME" "$FEATURE_NAME"
else
    # 显示使用说明
    cat << USAGE
使用 Skill: $SKILL_NAME

## OpenCode（推荐）

\`\`\`bash
opencode
skill(name: $SKILL_NAME)
\`\`\`

然后在对话中用 @ 引用文件：

\`\`\`
请实现登录接口。

## API 契约
@docs/api/auth.yaml

## 技术方案
@docs/tech/mobile-login.md
\`\`\`

## Claude

\`\`\`bash
$0 $SKILL_NAME -c <功能名称>
\`\`\`

USAGE
fi
