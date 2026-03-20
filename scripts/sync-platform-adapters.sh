#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_SRC_DIR="${ROOT_DIR}/skills"
AGENTS_SRC_DIR="${ROOT_DIR}/agents"

SKILL_TARGET_DIRS=(
  "${ROOT_DIR}/.claude/skills"
  "${ROOT_DIR}/.gemini/skills"
)

CLAUDE_AGENTS_DIR="${ROOT_DIR}/.claude/agents"
GEMINI_AGENTS_DIR="${ROOT_DIR}/.gemini/agents"
OPENCODE_AGENTS_DIR="${ROOT_DIR}/.opencode/agents"
CODEX_AGENTS_DIR="${ROOT_DIR}/.codex/agents"

SYNC_SKILLS=0
SYNC_AGENTS=1

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

escape_toml_basic_string() {
  sed 's/\\/\\\\/g; s/"/\\"/g'
}

get_claude_model() {
  local agent_name=$1

  case "$agent_name" in
    project-manager|frontend-design|tech-lead|frontend|backend-typescript|backend-springboot|qa-engineer|code-reviewer)
      printf 'sonnet\n'
      ;;
    *)
      printf 'inherit\n'
      ;;
  esac
}

get_claude_color() {
  local agent_name=$1

  case "$agent_name" in
    project-manager)
      printf 'orange\n'
      ;;
    frontend-design)
      printf 'pink\n'
      ;;
    tech-lead)
      printf 'blue\n'
      ;;
    frontend)
      printf 'green\n'
      ;;
    backend-typescript)
      printf 'teal\n'
      ;;
    backend-springboot)
      printf 'red\n'
      ;;
    qa-engineer)
      printf 'yellow\n'
      ;;
    code-reviewer)
      printf 'purple\n'
      ;;
    *)
      printf 'default\n'
      ;;
  esac
}

get_claude_tools() {
  local agent_name=$1

  case "$agent_name" in
    project-manager)
      printf 'Read, Write, Edit, Glob, Grep\n'
      ;;
    frontend-design)
      printf 'Read, Write, Edit, Glob, Grep\n'
      ;;
    tech-lead)
      printf 'Read, Write, Edit, Bash, Glob, Grep\n'
      ;;
    frontend|backend-typescript|backend-springboot|qa-engineer|code-reviewer)
      printf 'Read, Write, Edit, Bash, Glob, Grep\n'
      ;;
    *)
      printf 'Read, Glob, Grep\n'
      ;;
  esac
}

sync_skills() {
  local target_dir skill_dir skill_name skill_dest src_path rel_path dest_path

  for target_dir in "${SKILL_TARGET_DIRS[@]}"; do
    mkdir -p "$target_dir"
  done

  for skill_dir in "${SKILLS_SRC_DIR}"/*; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"

    for target_dir in "${SKILL_TARGET_DIRS[@]}"; do
      skill_dest="${target_dir}/${skill_name}"
      mkdir -p "$skill_dest"

      while IFS= read -r -d '' src_path; do
        rel_path="${src_path#"${skill_dir}/"}"
        dest_path="${skill_dest}/${rel_path}"

        if [ -d "$src_path" ]; then
          mkdir -p "$dest_path"
        else
          mkdir -p "$(dirname "$dest_path")"
          cat "$src_path" > "$dest_path"
        fi
      done < <(find "$skill_dir" -mindepth 1 -print0)
    done
  done
}

write_markdown_agent() {
  local dest_file=$1
  local frontmatter=$2
  local body_file=$3
  local source_name=$4
  local tmp_file

  tmp_file="$(mktemp)"

  {
    printf '%s\n' "$frontmatter"
    printf '\n'
    printf '<!-- Generated from agents/%s/AGENT.md by scripts/sync-platform-adapters.sh. Do not edit directly. -->\n\n' "$source_name"
    cat "$body_file"
  } > "$tmp_file"

  mv "$tmp_file" "$dest_file"
}

write_codex_agent() {
  local dest_file=$1
  local body_file=$2
  local agent_name=$3
  local description=$4
  local tmp_file

  tmp_file="$(mktemp)"

  {
    printf '# Generated from agents/%s/AGENT.md by scripts/sync-platform-adapters.sh. Do not edit directly.\n\n' "$agent_name"
    printf 'name = "%s"\n' "$(printf '%s' "$agent_name" | escape_toml_basic_string)"
    printf 'description = "%s"\n' "$(printf '%s' "$description" | escape_toml_basic_string)"
    printf 'developer_instructions = """\n'
    cat "$body_file"
    printf '\n"""\n'
  } > "$tmp_file"

  mv "$tmp_file" "$dest_file"
}

sync_agents() {
  local agent_dir agent_name agent_src description body_tmp
  local claude_model claude_color claude_tools

  mkdir -p "$CLAUDE_AGENTS_DIR" "$GEMINI_AGENTS_DIR" "$OPENCODE_AGENTS_DIR" "$CODEX_AGENTS_DIR"

  for agent_dir in "${AGENTS_SRC_DIR}"/*; do
    [ -d "$agent_dir" ] || continue

    agent_name="$(basename "$agent_dir")"
    agent_src="${agent_dir}/AGENT.md"
    [ -f "$agent_src" ] || continue

    description="$(extract_frontmatter_value "$agent_src" "description")"
    claude_model="$(get_claude_model "$agent_name")"
    claude_color="$(get_claude_color "$agent_name")"
    claude_tools="$(get_claude_tools "$agent_name")"
    body_tmp="$(mktemp)"
    extract_markdown_body "$agent_src" > "$body_tmp"

    write_markdown_agent \
      "${CLAUDE_AGENTS_DIR}/${agent_name}.md" \
      "---"$'\n'"name: ${agent_name}"$'\n'"description: ${description}"$'\n'"model: ${claude_model}"$'\n'"color: ${claude_color}"$'\n'"tools: ${claude_tools}"$'\n'"---" \
      "$body_tmp" \
      "$agent_name"

    write_markdown_agent \
      "${GEMINI_AGENTS_DIR}/${agent_name}.md" \
      "---"$'\n'"name: ${agent_name}"$'\n'"description: ${description}"$'\n'"kind: local"$'\n'"---" \
      "$body_tmp" \
      "$agent_name"

    write_markdown_agent \
      "${OPENCODE_AGENTS_DIR}/${agent_name}.md" \
      "---"$'\n'"description: ${description}"$'\n'"mode: subagent"$'\n'"---" \
      "$body_tmp" \
      "$agent_name"

    write_codex_agent \
      "${CODEX_AGENTS_DIR}/${agent_name}.toml" \
      "$body_tmp" \
      "$agent_name" \
      "$description"

    rm -f "$body_tmp"
  done
}

usage() {
  cat <<'EOF'
Usage:
  ./scripts/sync-platform-adapters.sh [--with-skills|--skills-only|--agents-only|--help]

Default behavior:
  Sync agents only.

Options:
  --with-skills  Sync both skills and agents
  --skills-only  Sync skills only
  --agents-only  Sync agents only
  --help         Show this help
EOF
}

parse_args() {
  while [ $# -gt 0 ]; do
    case "$1" in
      --with-skills)
        SYNC_SKILLS=1
        SYNC_AGENTS=1
        ;;
      --skills-only)
        SYNC_SKILLS=1
        SYNC_AGENTS=0
        ;;
      --agents-only)
        SYNC_SKILLS=0
        SYNC_AGENTS=1
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        echo "" >&2
        usage >&2
        exit 1
        ;;
    esac
    shift
  done
}

main() {
  parse_args "$@"

  if [ "$SYNC_SKILLS" -eq 1 ]; then
    sync_skills
  fi

  if [ "$SYNC_AGENTS" -eq 1 ]; then
    sync_agents
  fi

  echo "Platform adapters synced:"
  if [ "$SYNC_SKILLS" -eq 1 ]; then
    echo "  Skills  -> .claude/skills, .gemini/skills"
  else
    echo "  Skills  -> skipped"
  fi
  if [ "$SYNC_AGENTS" -eq 1 ]; then
    echo "  Agents  -> .claude/agents, .gemini/agents, .opencode/agents, .codex/agents"
  else
    echo "  Agents  -> skipped"
  fi
}

main "$@"
