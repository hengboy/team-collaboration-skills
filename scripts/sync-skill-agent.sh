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
HAS_RG=0

if command -v rg >/dev/null 2>&1; then
  HAS_RG=1
fi

REQUIRED_FILE_HEADINGS=(
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

REQUIRED_CONTRACT_HEADINGS=(
  "角色定位"
  "必须输入"
  "可选输入"
  "输出文件"
  "执行规则"
  "质量检查"
  "下一步流程"
)

STRONG_SECTION_HEADINGS=(
  "技术栈"
  "需求澄清机制"
  "设计确认机制"
  "设计原则"
  "计划输出重点"
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

extract_subsection() {
  local file=$1
  local section=$2
  awk -v section="$section" '
    $0 == section { in_section=1 }
    in_section {
      if ($0 ~ /^### / && $0 != section && NR > start_nr) {
        exit
      }
      print
    }
    $0 == section { start_nr=NR }
  ' "$file"
}

strip_heading_and_blank_lines() {
  local file=$1
  sed '/^##\{2,3\}[[:space:]]/d;/^[[:space:]]*$/d' "$file"
}

matches_pattern() {
  local pattern=$1
  local file=$2

  if [ "$HAS_RG" -eq 1 ]; then
    rg -q -- "$pattern" "$file"
  else
    grep -Eq -- "$pattern" "$file"
  fi
}

check_required_headings() {
  local file=$1
  local label=$2
  shift 2
  local missing=0
  local headings=("$@")

  for heading in "${headings[@]}"; do
    if ! matches_pattern "^#{2,3}[[:space:]]+${heading//\//\\/}$" "$file"; then
      echo "    - ${label} 缺少章节: $heading"
      missing=1
    fi
  done
  return $missing
}

compare_subset_lines() {
  local skill_lines_file=$1
  local agent_lines_file=$2
  local label=$3
  local missing=0

  while IFS= read -r line || [ -n "$line" ]; do
    if [ -z "$line" ]; then
      continue
    fi

    if ! grep -Fqx -- "$line" "$skill_lines_file"; then
      if [ $missing -eq 0 ]; then
        echo -e "  ${YELLOW}⚠ ${label} 中存在 Skill 未覆盖的内容${NC}"
      fi
      echo "    - $line"
      missing=1
    fi
  done < "$agent_lines_file"

  return $missing
}

compare_exact_lines() {
  local expected_lines_file=$1
  local actual_lines_file=$2
  local label=$3

  if diff -u "$expected_lines_file" "$actual_lines_file" >/tmp/skill-agent-sync.diff 2>/dev/null; then
    return 0
  fi

  echo -e "  ${YELLOW}⚠ ${label} 与 Skill 不一致${NC}"
  sed 's/^/    /' /tmp/skill-agent-sync.diff
  return 1
}

compare_contract_subsections() {
  local skill_contract=$1
  local agent_contract=$2
  local status=0

  if ! check_required_headings "$skill_contract" "Skill 核心契约" "${REQUIRED_CONTRACT_HEADINGS[@]}"; then
    status=2
  fi
  if ! check_required_headings "$agent_contract" "Agent 核心契约" "${REQUIRED_CONTRACT_HEADINGS[@]}"; then
    status=2
  fi

  local heading
  for heading in "${REQUIRED_CONTRACT_HEADINGS[@]}"; do
    local skill_sub agent_sub skill_lines agent_lines
    skill_sub=$(mktemp)
    agent_sub=$(mktemp)
    skill_lines=$(mktemp)
    agent_lines=$(mktemp)

    extract_subsection "$skill_contract" "### $heading" > "$skill_sub"
    extract_subsection "$agent_contract" "### $heading" > "$agent_sub"
    strip_heading_and_blank_lines "$skill_sub" > "$skill_lines"
    strip_heading_and_blank_lines "$agent_sub" > "$agent_lines"

    if [ ! -s "$skill_sub" ] || [ ! -s "$agent_sub" ]; then
      echo -e "  ${YELLOW}⚠ 核心契约/$heading 缺失，无法对比${NC}"
      status=2
    elif ! compare_subset_lines "$skill_lines" "$agent_lines" "核心契约/$heading"; then
      status=2
    fi

    rm -f "$skill_sub" "$agent_sub" "$skill_lines" "$agent_lines"
  done

  if [ $status -eq 0 ]; then
    echo -e "  ${GREEN}✓ 核心契约受 Skill 覆盖${NC}"
  fi

  return $status
}

compare_strong_sections() {
  local skill_file=$1
  local agent_file=$2
  local status=0
  local heading

  for heading in "${STRONG_SECTION_HEADINGS[@]}"; do
    local skill_has_section=0
    local agent_has_section=0

    if matches_pattern "^##[[:space:]]+${heading//\//\\/}$" "$skill_file"; then
      skill_has_section=1
    fi
    if matches_pattern "^##[[:space:]]+${heading//\//\\/}$" "$agent_file"; then
      agent_has_section=1
    fi

    if [ "$skill_has_section" -eq 0 ] && [ "$agent_has_section" -eq 0 ]; then
      continue
    fi

    if [ "$skill_has_section" -eq 1 ] && [ "$agent_has_section" -eq 0 ]; then
      echo -e "  ${YELLOW}⚠ Skill 定义了强制约束段落但 Agent 缺失：$heading${NC}"
      status=2
      continue
    fi

    if [ "$skill_has_section" -eq 0 ] && [ "$agent_has_section" -eq 1 ]; then
      echo -e "  ${YELLOW}⚠ Agent 包含 Skill 未定义的强制约束段落：$heading${NC}"
      status=2
      continue
    fi

    local skill_section agent_section skill_lines agent_lines
    skill_section=$(mktemp)
    agent_section=$(mktemp)
    skill_lines=$(mktemp)
    agent_lines=$(mktemp)

    extract_section "$skill_file" "## $heading" > "$skill_section"
    extract_section "$agent_file" "## $heading" > "$agent_section"
    strip_heading_and_blank_lines "$skill_section" > "$skill_lines"
    strip_heading_and_blank_lines "$agent_section" > "$agent_lines"

    if [ ! -s "$skill_section" ] || [ ! -s "$agent_section" ]; then
      echo -e "  ${YELLOW}⚠ 强制约束段落缺失，无法对比：$heading${NC}"
      status=2
    elif ! compare_exact_lines "$skill_lines" "$agent_lines" "强制约束段落/$heading"; then
      status=2
    fi

    rm -f "$skill_section" "$agent_section" "$skill_lines" "$agent_lines"
  done

  if [ $status -eq 0 ]; then
    echo -e "  ${GREEN}✓ 强制约束段落与 Skill 对齐${NC}"
  fi

  return $status
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
  if ! check_required_headings "$skill_tmp" "Skill" "${REQUIRED_FILE_HEADINGS[@]}"; then
    status=2
  fi
  if ! check_required_headings "$agent_tmp" "Agent" "${REQUIRED_FILE_HEADINGS[@]}"; then
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
  elif ! compare_contract_subsections "$skill_contract" "$agent_contract"; then
    status=2
  fi

  if ! compare_strong_sections "$skill_tmp" "$agent_tmp"; then
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
    echo -e "${GREEN}所有 agent 均受对应 skill 约束覆盖${NC}"
  else
    echo -e "${YELLOW}发现同步差异，请先修复后再继续${NC}"
  fi

  exit $overall
}

main "$@"
