#!/bin/bash

set -u

SKILLS_DIR="./skills"
AGENTS_DIR="./agents"
TARGET_SECTION="## 核心契约（供 AGENT 派生）"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REQUIRED_HEADINGS=(
  "角色定位"
  "适用场景"
  "必须输入"
  "可选输入"
  "输出文件"
  "执行规则"
  "质量检查"
  "下一步流程"
  "核心契约（供 AGENT 派生）"
)

print_header() {
  echo -e "${GREEN}=== Skill to Agent Sync Tool ===${NC}"
  echo ""
}

normalize_file() {
  local file=$1
  sed 's/[[:space:]]*$//' "$file"
}

extract_section() {
  local file=$1
  local section=$2
  awk -v section="$section" '
    $0 == section { in_section=1 }
    in_section {
      if ($0 ~ /^## / && $0 != section && NR > start_nr) {
        exit
      }
      print
    }
    $0 == section { start_nr=NR }
  ' "$file"
}

check_required_headings() {
  local file=$1
  local label=$2
  local missing=0
  for heading in "${REQUIRED_HEADINGS[@]}"; do
    if ! rg -q "^#{2,3}[[:space:]]+${heading//\//\\/}$" "$file"; then
      echo "    - ${label} 缺少章节: $heading"
      missing=1
    fi
  done
  return $missing
}

compare_one() {
  local name=$1
  local skill_file="${SKILLS_DIR}/${name}/SKILL.md"
  local agent_file="${AGENTS_DIR}/${name}/AGENT.md"
  local status=0

  echo -e "${BLUE}检查：${name}${NC}"
  echo "  Skill file:   $skill_file"
  echo "  Agent file:   $agent_file"

  if [ ! -f "$skill_file" ]; then
    echo -e "  ${RED}✗ 缺少 Skill 文件${NC}"
    return 1
  fi

  if [ ! -f "$agent_file" ]; then
    echo -e "  ${RED}✗ 缺少 Agent 文件${NC}"
    return 1
  fi

  local skill_tmp agent_tmp
  skill_tmp=$(mktemp)
  agent_tmp=$(mktemp)
  normalize_file "$skill_file" > "$skill_tmp"
  normalize_file "$agent_file" > "$agent_tmp"

  echo "  结构检查:"
  if ! check_required_headings "$skill_tmp" "Skill"; then
    status=2
  fi
  if ! check_required_headings "$agent_tmp" "Agent"; then
    status=2
  fi

  local skill_contract agent_contract
  skill_contract=$(mktemp)
  agent_contract=$(mktemp)
  extract_section "$skill_tmp" "$TARGET_SECTION" > "$skill_contract"
  extract_section "$agent_tmp" "$TARGET_SECTION" > "$agent_contract"

  if [ ! -s "$skill_contract" ] || [ ! -s "$agent_contract" ]; then
    echo -e "  ${YELLOW}⚠ 核心契约缺失，无法对比${NC}"
    status=2
  elif diff -u "$skill_contract" "$agent_contract" >/tmp/skill-agent-sync.diff 2>/dev/null; then
    echo -e "  ${GREEN}✓ 核心契约一致${NC}"
  else
    echo -e "  ${YELLOW}⚠ 核心契约存在差异${NC}"
    sed 's/^/    /' /tmp/skill-agent-sync.diff
    status=2
  fi

  rm -f "$skill_tmp" "$agent_tmp" "$skill_contract" "$agent_contract" /tmp/skill-agent-sync.diff

  if [ $status -eq 0 ]; then
    echo -e "  ${GREEN}✓ 同步检查通过${NC}"
  fi
  echo ""
  return $status
}

collect_names() {
  find "$AGENTS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
}

main() {
  print_header

  local names=()
  if [ $# -eq 1 ]; then
    names=("$1")
  else
    while IFS= read -r name; do
      names+=("$name")
    done < <(collect_names)
  fi

  if [ ${#names[@]} -eq 0 ]; then
    echo -e "${YELLOW}未发现可检查的 agent 目录${NC}"
    exit 0
  fi

  local overall=0
  for name in "${names[@]}"; do
    compare_one "$name"
    result=$?
    if [ $result -ne 0 ]; then
      overall=$result
    fi
  done

  if [ $overall -eq 0 ]; then
    echo -e "${GREEN}所有 agent 与 skill 的核心契约一致${NC}"
  else
    echo -e "${YELLOW}发现同步差异，请先修复后再继续${NC}"
  fi

  exit $overall
}

main "$@"
