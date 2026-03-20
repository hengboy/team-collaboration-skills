#!/bin/bash

set -u

SKILLS_DIR="./skills"
AGENTS_DIR="./agents"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
HAS_RG=0

if command -v rg >/dev/null 2>&1; then
  HAS_RG=1
fi

SKILL_REQUIRED_RULES=(
  "角色定义/角色定位|^##[[:space:]]+(角色定义|角色定位)$"
  "适用场景|^##[[:space:]]+适用场景$"
  "输入要求|^##[[:space:]]+输入要求$"
  "必须输入|^###[[:space:]]+必须输入$"
  "可选输入|^###[[:space:]]+可选输入$"
  "输出规范|^##[[:space:]]+输出规范$"
  "输出文件|^###[[:space:]]+输出文件$"
  "执行规则|^##[[:space:]]+执行规则$"
  "质量检查|^##[[:space:]]+质量检查$"
  "下一步流程|^##[[:space:]]+(🔄[[:space:]]+)?下一步流程$"
)

AGENT_REQUIRED_RULES=(
  "角色定义/角色定位|^##[[:space:]]+(角色定义|角色定位)$"
  "适用场景|^##[[:space:]]+适用场景$"
  "必须输入|^###[[:space:]]+必须输入$"
  "可选输入|^###[[:space:]]+可选输入$"
  "输出文件|^###[[:space:]]+输出文件$"
  "执行规则|^##[[:space:]]+执行规则$"
  "质量检查|^##[[:space:]]+质量检查$"
  "下一步流程|^##[[:space:]]+(🔄[[:space:]]+)?下一步流程$"
)

STRONG_SECTION_HEADINGS=(
  "强制约束"
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

matches_pattern() {
  local pattern=$1
  local file=$2

  if [ "$HAS_RG" -eq 1 ]; then
    rg -q -- "$pattern" "$file"
  else
    grep -Eq -- "$pattern" "$file"
  fi
}

check_required_rules() {
  local file=$1
  local label=$2
  shift 2
  local missing=0
  local rules=("$@")
  local rule heading pattern

  for rule in "${rules[@]}"; do
    heading=${rule%%|*}
    pattern=${rule#*|}
    if ! matches_pattern "$pattern" "$file"; then
      echo "    - ${label} 缺少章节: $heading"
      missing=1
    fi
  done

  return $missing
}

extract_block_by_pattern() {
  local file=$1
  local start_pattern=$2
  local stop_pattern=$3

  awk -v start_pattern="$start_pattern" -v stop_pattern="$stop_pattern" '
    !in_block && $0 ~ start_pattern {
      in_block=1
      start_nr=NR
    }
    in_block {
      if ($0 ~ stop_pattern && NR > start_nr) {
        exit
      }
      print
    }
  ' "$file"
}

strip_heading_and_blank_lines() {
  local file=$1
  sed '/^###[[:space:]]/d;/^##[[:space:]]/d;/^[[:space:]]*$/d' "$file"
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

compare_mapped_block() {
  local skill_file=$1
  local agent_file=$2
  local skill_pattern=$3
  local skill_stop=$4
  local agent_pattern=$5
  local agent_stop=$6
  local label=$7

  local skill_block agent_block skill_lines agent_lines
  skill_block=$(mktemp)
  agent_block=$(mktemp)
  skill_lines=$(mktemp)
  agent_lines=$(mktemp)

  extract_block_by_pattern "$skill_file" "$skill_pattern" "$skill_stop" > "$skill_block"
  extract_block_by_pattern "$agent_file" "$agent_pattern" "$agent_stop" > "$agent_block"
  strip_heading_and_blank_lines "$skill_block" > "$skill_lines"
  strip_heading_and_blank_lines "$agent_block" > "$agent_lines"

  local result=0
  if [ ! -s "$skill_block" ] || [ ! -s "$agent_block" ]; then
    echo -e "  ${YELLOW}⚠ ${label} 缺失，无法对比${NC}"
    result=2
  elif ! compare_exact_lines "$skill_lines" "$agent_lines" "$label"; then
    result=2
  fi

  rm -f "$skill_block" "$agent_block" "$skill_lines" "$agent_lines"
  return $result
}

compare_main_sections() {
  local skill_file=$1
  local agent_file=$2
  local status=0

  if ! compare_mapped_block \
    "$skill_file" "$agent_file" \
    '^### 必须输入$' '^(##|###)[[:space:]]' \
    '^### 必须输入$' '^(##|###)[[:space:]]' \
    "主章节/必须输入"; then
    status=2
  fi

  if ! compare_mapped_block \
    "$skill_file" "$agent_file" \
    '^### 可选输入$' '^(##|###)[[:space:]]' \
    '^### 可选输入$' '^(##|###)[[:space:]]' \
    "主章节/可选输入"; then
    status=2
  fi

  if ! compare_mapped_block \
    "$skill_file" "$agent_file" \
    '^### 输出文件$' '^(##|###)[[:space:]]' \
    '^### 输出文件$' '^(##|###)[[:space:]]' \
    "主章节/输出文件"; then
    status=2
  fi

  if ! compare_mapped_block \
    "$skill_file" "$agent_file" \
    '^##[[:space:]]+执行规则$' '^##[[:space:]]' \
    '^##[[:space:]]+执行规则$' '^##[[:space:]]' \
    "主章节/执行规则"; then
    status=2
  fi

  if ! compare_mapped_block \
    "$skill_file" "$agent_file" \
    '^##[[:space:]]+质量检查$' '^##[[:space:]]' \
    '^##[[:space:]]+质量检查$' '^##[[:space:]]' \
    "主章节/质量检查"; then
    status=2
  fi

  if ! compare_mapped_block \
    "$skill_file" "$agent_file" \
    '^##[[:space:]]+(🔄[[:space:]]+)?下一步流程$' '^##[[:space:]]' \
    '^##[[:space:]]+(🔄[[:space:]]+)?下一步流程$' '^##[[:space:]]' \
    "主章节/下一步流程"; then
    status=2
  fi

  if [ $status -eq 0 ]; then
    echo -e "  ${GREEN}✓ 主章节与 Skill 精确对齐${NC}"
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

    extract_block_by_pattern "$skill_file" "^##[[:space:]]+${heading//\//\\/}$" '^##[[:space:]]' > "$skill_section"
    extract_block_by_pattern "$agent_file" "^##[[:space:]]+${heading//\//\\/}$" '^##[[:space:]]' > "$agent_section"
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
  if ! check_required_rules "$skill_tmp" "Skill" "${SKILL_REQUIRED_RULES[@]}"; then
    status=2
  fi
  if ! check_required_rules "$agent_tmp" "Agent" "${AGENT_REQUIRED_RULES[@]}"; then
    status=2
  fi

  if ! compare_main_sections "$skill_tmp" "$agent_tmp"; then
    status=2
  fi

  if ! compare_strong_sections "$skill_tmp" "$agent_tmp"; then
    status=2
  fi

  rm -f "$skill_tmp" "$agent_tmp" /tmp/skill-agent-sync.diff

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
  local result=0
  for name in "${names[@]}"; do
    compare_one "$name"
    result=$?
    if [ $result -ne 0 ]; then
      overall=$result
    fi
  done

  if [ $overall -eq 0 ]; then
    echo -e "${GREEN}所有 agent 均与对应 skill 主章节精确对齐${NC}"
  else
    echo -e "${YELLOW}发现同步差异，请先修复后再继续${NC}"
  fi

  exit $overall
}

main "$@"
