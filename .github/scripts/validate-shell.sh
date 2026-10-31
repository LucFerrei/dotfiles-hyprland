#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$root"

mapfile -t shell_scripts < <(
    grep -rlE '^#!.*\b(bash|sh)\b' bin restart_waybar.sh .github/scripts 2>/dev/null || true
)

if ((${#shell_scripts[@]} == 0)); then
    echo "no shell scripts found" >&2
    exit 1
fi

shellcheck --severity=error --external-sources "${shell_scripts[@]}"
echo "shellcheck: ${#shell_scripts[@]} scripts ok"

zsh -n .zshrc
echo "zsh: .zshrc ok"

tmux -f "$root/.tmux.conf" -L config-ci new-session -d -s config-ci
tmux -L config-ci kill-server
echo "tmux: .tmux.conf ok"
