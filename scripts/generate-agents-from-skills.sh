#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="${ROOT_DIR}/skills"
AGENTS_DIR="${ROOT_DIR}/agents"

ALLOWED_ROLES=(
  "project-manager"
  "tech-lead"
  "frontend-design"
)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
  cat <<'EOF'
Usage:
  ./scripts/generate-agents-from-skills.sh
  ./scripts/generate-agents-from-skills.sh <role> [role...]
  ./scripts/generate-agents-from-skills.sh --help

Default behavior:
  Generate AGENT.md files for the whitelist subagent roles:
  - project-manager
  - tech-lead
  - frontend-design
EOF
}

extract_frontmatter_value() {
  local file=$1
  local key=$2

  awk -v key="$key" '
    BEGIN { in_frontmatter = 0 }
    /^---$/ {
      if (in_frontmatter == 0) {
        in_frontmatter = 1
        next
      }
      exit
    }
    in_frontmatter == 1 && $0 ~ ("^" key ":") {
      sub("^" key ":[[:space:]]*", "", $0)
      print
      exit
    }
  ' "$file"
}

extract_markdown_body() {
  local file=$1

  awk '
    BEGIN { frontmatter_delimiters = 0 }
    /^---$/ && frontmatter_delimiters < 2 {
      frontmatter_delimiters++
      next
    }
    frontmatter_delimiters >= 2 {
      print
    }
  ' "$file"
}

is_allowed_role() {
  local role=$1
  local allowed

  for allowed in "${ALLOWED_ROLES[@]}"; do
    if [ "$allowed" = "$role" ]; then
      return 0
    fi
  done

  return 1
}

to_title_case() {
  local name=$1
  local word
  local output=""
  local first_char
  local rest

  IFS='-' read -r -a words <<< "$name"
  for word in "${words[@]}"; do
    first_char="$(printf '%s' "$word" | cut -c1 | tr '[:lower:]' '[:upper:]')"
    rest="$(printf '%s' "$word" | cut -c2-)"
    output="${output}${output:+ }${first_char}${rest}"
  done

  printf '%s\n' "$output"
}

transform_skill_body() {
  local file=$1

  extract_markdown_body "$file" | awk '
    BEGIN {
      started = 0
    }
    {
      sub(/[[:space:]]+$/, "", $0)
    }
    !started {
      if ($0 ~ /^##[[:space:]]+(角色定义|角色定位|计划输出重点|技术栈|需求澄清机制|设计确认机制|设计原则|适用场景|工作项模式|输入要求|输出规范|执行规则|强制约束|质量检查|下一步流程)$/) {
        started = 1
      } else {
        next
      }
    }
    {
      if ($0 ~ /^##[[:space:]]+.*下一步流程$/) {
        print "## 下一步流程"
        next
      }

      print
    }
  '
}

write_agent_file() {
  local role=$1
  local skill_file="${SKILLS_DIR}/${role}/SKILL.md"
  local agent_dir="${AGENTS_DIR}/${role}"
  local agent_file="${agent_dir}/AGENT.md"
  local name description title body_tmp output_tmp

  if [ ! -f "$skill_file" ]; then
    echo -e "${RED}Missing skill file: ${skill_file}${NC}" >&2
    return 1
  fi

  name="$(extract_frontmatter_value "$skill_file" "name")"
  description="$(extract_frontmatter_value "$skill_file" "description")"

  if [ -z "$name" ] || [ -z "$description" ]; then
    echo -e "${RED}Missing required frontmatter in ${skill_file}${NC}" >&2
    return 1
  fi

  body_tmp="$(mktemp)"
  output_tmp="$(mktemp)"
  title="$(to_title_case "$role")"

  transform_skill_body "$skill_file" > "$body_tmp"

  if [ ! -s "$body_tmp" ]; then
    rm -f "$body_tmp" "$output_tmp"
    echo -e "${RED}Failed to derive agent body from ${skill_file}${NC}" >&2
    return 1
  fi

  mkdir -p "$agent_dir"

  {
    printf '%s\n' '---'
    printf 'name: %s\n' "$name"
    printf 'description: %s\n' "$description"
    printf '%s\n\n' '---'
    printf '<!-- Generated from skills/%s/SKILL.md by scripts/generate-agents-from-skills.sh. Do not edit directly. -->\n\n' "$role"
    printf '# %s Agent\n\n' "$title"
    cat "$body_tmp"
  } > "$output_tmp"

  mv "$output_tmp" "$agent_file"
  rm -f "$body_tmp"

  echo -e "${GREEN}Generated${NC} ${agent_file}"
}

main() {
  local roles=()
  local arg

  cd "$ROOT_DIR"

  if [ $# -eq 0 ]; then
    roles=("${ALLOWED_ROLES[@]}")
  else
    for arg in "$@"; do
      case "$arg" in
        --help|-h)
          usage
          exit 0
          ;;
        -*)
          echo -e "${YELLOW}Unknown option: ${arg}${NC}" >&2
          usage >&2
          exit 1
          ;;
        *)
          if ! is_allowed_role "$arg"; then
            echo -e "${RED}Unsupported role: ${arg}${NC}" >&2
            echo "Allowed roles: ${ALLOWED_ROLES[*]}" >&2
            exit 1
          fi
          roles+=("$arg")
          ;;
      esac
    done
  fi

  for arg in "${roles[@]}"; do
    write_agent_file "$arg"
  done
}

main "$@"
