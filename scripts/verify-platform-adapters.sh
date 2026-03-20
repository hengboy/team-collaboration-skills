#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

check_file() {
  local file_path=$1

  if [ ! -f "$file_path" ]; then
    echo "Missing generated runtime file: $file_path" >&2
    return 1
  fi
}

main() {
  cd "$ROOT_DIR"

  echo "== Verify skill/agent contract sync =="
  ./scripts/sync-skill-agent.sh

  echo ""
  echo "== Regenerate platform adapters =="
  ./scripts/sync-platform-adapters.sh --with-skills

  echo ""
  echo "== Check generated runtime files =="

  local skill_dir skill_name
  for skill_dir in ./skills/*; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"

    check_file "./.claude/skills/${skill_name}/SKILL.md"
    check_file "./.gemini/skills/${skill_name}/SKILL.md"
  done

  local agent_dir agent_name
  for agent_dir in ./agents/*; do
    [ -d "$agent_dir" ] || continue
    agent_name="$(basename "$agent_dir")"

    check_file "./.claude/agents/${agent_name}.md"
    check_file "./.gemini/agents/${agent_name}.md"
    check_file "./.opencode/agents/${agent_name}.md"
    check_file "./.codex/agents/${agent_name}.toml"
  done

  echo ""
  echo "== Check diff hygiene =="
  git diff --check

  local runtime_status
  runtime_status="$(git status --short --untracked-files=all -- .claude .gemini .opencode .codex)"

  if [ -n "$runtime_status" ]; then
    echo "Generated runtime files are out of date. Please run ./scripts/verify-platform-adapters.sh and commit the results." >&2
    echo "$runtime_status" >&2
    exit 1
  fi

  echo ""
  echo "Platform adapter verification passed."
}

main "$@"
