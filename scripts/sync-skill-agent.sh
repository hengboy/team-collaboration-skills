#!/bin/bash

# sync-skill-agent.sh
# 同步 SKILL.md 内容到 agents/{skill}/AGENT.md 配置文件的脚本
# 使用方法：./scripts/sync-skill-agent.sh [skill-name]

set -e

SKILLS_DIR="./skills"
AGENTS_DIR="./agents"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Skill to Agent Sync Tool ===${NC}\n"

    # 需要同步的 skill 列表
    SKILLS=("project-manager" "frontend-design" "tech-lead")

sync_skill() {
    local skill_name=$1
    local skill_file="${SKILLS_DIR}/${skill_name}/SKILL.md"
    local agent_file="${AGENTS_DIR}/${skill_name}/AGENT.md"
    
    # 检查文件是否存在
    if [ ! -f "$skill_file" ]; then
        echo -e "${RED}✗ 找不到 Skill 文件：$skill_file${NC}"
        return 1
    fi
    
    if [ ! -f "$agent_file" ]; then
        echo -e "${YELLOW}⚠ 警告：Agent 文件不存在：$agent_file${NC}"
        echo -e "${YELLOW}  需要先创建 agent 配置文件${NC}"
        return 1
    fi
    
    # 使用 hash 对比
    skill_hash=$(md5sum "$skill_file" 2>/dev/null | cut -d' ' -f1 || md5 -q "$skill_file")
    agent_hash=$(md5sum "$agent_file" 2>/dev/null | cut -d' ' -f1 || md5 -q "$agent_file")
    
    echo -e "${BLUE}检查：${skill_name}${NC}"
    echo "  Skill file:   $skill_file"
    echo "  Agent file:   $agent_file"
    echo "  Skill hash:   $skill_hash"
    echo "  Agent hash:   $agent_hash"
    
    if [ "$skill_hash" = "$agent_hash" ]; then
        echo -e "  状态：${GREEN}✓ 文件完全一致${NC}\n"
        return 0
    fi
    
    # 检查关键内容差异
    echo -e "  状态：${YELLOW}⚠ 内容可能存在差异${NC}"
    echo -e "  ${YELLOW}提示：请手动检查以下内容是否同步:${NC}"
    echo "    - 角色定义"
    echo "    - 输出规范"
    echo "    - 工作流程"
    echo "    - 质量检查清单"
    echo ""
    
    return 2
}

# 主逻辑
if [ $# -eq 1 ]; then
    # 同步指定的 skill
    sync_skill "$1"
    exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ 同步检查通过${NC}"
    elif [ $exit_code -eq 2 ]; then
        echo -e "${YELLOW}⚠ 发现差异，请检查并更新 AGENT.md${NC}"
    fi
    exit $exit_code
else
    # 同步所有 skill
    echo "将检查以下 Skills 的同步状态:\n"
    
    has_diff=0
    for skill in "${SKILLS[@]}"; do
        sync_skill "$skill"
        if [ $? -eq 2 ]; then
            has_diff=1
        fi
    done
    
    echo -e "${GREEN}=== 检查完成 ===${NC}"
    echo ""
    
    if [ $has_diff -eq 1 ]; then
        echo -e "${YELLOW}提示:${NC}"
        echo "  发现差异，请检查 SKILL.md 和 AGENT.md 内容"
        echo "  如需同步单个 skill: ./scripts/sync-skill-agent.sh <skill-name>"
        echo "  示例：./scripts/sync-skill-agent.sh project-manager"
    else
        echo -e "${GREEN}✓ 所有文件内容一致${NC}"
    fi
fi
