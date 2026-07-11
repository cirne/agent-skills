#!/usr/bin/env bash
#
# setup.sh — sync ~/.agents/skills into each agent via per-skill symlinks
#
# Usage: ~/.agents/setup.sh
# Idempotent. Prefer this over hand-written ln -s loops.
#
# See README.md in this directory for the full workflow.
#

set -euo pipefail

AGENTS_DIR="${HOME}/.agents"
SKILLS_SRC="${AGENTS_DIR}/skills"

# path:relative_link_prefix (from <agent>/skills/ to ~/.agents/skills/)
AGENTS=(
  "${HOME}/.claude:../../.agents/skills"
  "${HOME}/.codex:../../.agents/skills"
  "${HOME}/.cursor:../../.agents/skills"
  "${HOME}/.gemini:../../.agents/skills"
  "${HOME}/.amp:../../.agents/skills"
  "${HOME}/.config/opencode:../../../.agents/skills"
  "${HOME}/.config/goose:../../../.agents/skills"
  "${HOME}/.config/crush:../../../.agents/skills"
)

sync_agent() {
  local agent_dir="${1%%:*}"
  local rel_prefix="${1##*:}"
  local skills_dir="${agent_dir}/skills"
  local name="${agent_dir/#"${HOME}"/\~}"

  [ -d "${agent_dir}" ] || return 0

  if [ -L "${skills_dir}" ]; then
    echo "  ! ${name}/skills: replacing directory symlink with real dir"
    rm "${skills_dir}"
  fi

  mkdir -p "${skills_dir}"

  local added=0 existing=0 removed=0 skipped=0

  for skill_path in "${SKILLS_SRC}"/*/; do
    [ -d "${skill_path}" ] || continue
    local skill_name
    skill_name="$(basename "${skill_path}")"
    [[ "${skill_name}" == .* ]] && continue

    local link="${skills_dir}/${skill_name}"
    local target="${rel_prefix}/${skill_name}"

    if [ -L "${link}" ]; then
      # Repair if pointing at the wrong place
      local current
      current="$(readlink "${link}")"
      if [ "${current}" != "${target}" ]; then
        ln -sfn "${target}" "${link}"
        added=$((added + 1))
      else
        existing=$((existing + 1))
      fi
      continue
    fi

    if [ -d "${link}" ] || [ -e "${link}" ]; then
      echo "  ! ${name}/skills/${skill_name}: real path (not a symlink) — move to ~/.agents/skills/ then re-run"
      skipped=$((skipped + 1))
      continue
    fi

    ln -s "${target}" "${link}"
    added=$((added + 1))
  done

  for link in "${skills_dir}"/*; do
    [ -e "${link}" ] || [ -L "${link}" ] || continue
    [ -L "${link}" ] || continue
    local link_name
    link_name="$(basename "${link}")"
    if [ ! -d "${SKILLS_SRC}/${link_name}" ]; then
      rm "${link}"
      removed=$((removed + 1))
    fi
  done

  echo "  ✓ ${name}/skills  +${added}  ${existing} ok  -${removed} stale  !${skipped} skipped"
}

main() {
  echo ""
  echo ".agents setup"
  echo ""

  mkdir -p "${SKILLS_SRC}"

  if [ ! -d "${AGENTS_DIR}/.git" ]; then
    git -C "${AGENTS_DIR}" init -q
    echo "  ✓ initialized git repo"
  fi

  if [ ! -f "${AGENTS_DIR}/.gitignore" ]; then
    cat > "${AGENTS_DIR}/.gitignore" << 'GITIGNORE'
# Codex may create this under a mistaken path; never track tool-owned dirs here
skills/.system/

.DS_Store
Thumbs.db
GITIGNORE
    echo "  ✓ created .gitignore"
  fi

  local hooks_dir="${AGENTS_DIR}/hooks"
  local hook="${hooks_dir}/post-merge"
  mkdir -p "${hooks_dir}"
  if [ ! -f "${hook}" ]; then
    cat > "${hook}" << 'HOOK'
#!/usr/bin/env bash
# After git pull, re-link skills into each agent.
exec "$(git rev-parse --show-toplevel)/setup.sh"
HOOK
    chmod +x "${hook}"
    echo "  ✓ created post-merge hook"
  fi

  git -C "${AGENTS_DIR}" config core.hooksPath hooks

  local total
  total="$(find "${SKILLS_SRC}" -maxdepth 1 -mindepth 1 -type d ! -name '.*' 2>/dev/null | wc -l | tr -d ' ')"

  if [ "${total}" -eq 0 ]; then
    echo "  (no skills in ~/.agents/skills yet)"
    echo ""
    return 0
  fi

  echo "  syncing ${total} skill(s) …"
  echo ""

  for agent in "${AGENTS[@]}"; do
    sync_agent "${agent}"
  done

  echo ""
  echo "  done."
  echo ""
}

main "$@"
