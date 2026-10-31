#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

sway_bin="$(command -v swayfx || command -v sway || true)"
if [[ -z "$sway_bin" ]]; then
    echo "swayfx/sway binary not found" >&2
    exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/.config" "$tmp/personal/wallpapers"
cp -a "$root/sway" "$tmp/.config/sway"

# The config references a wallpaper outside the repo. Create a placeholder so
# the validator checks the config itself instead of failing on the asset.
touch "$tmp/personal/wallpapers/amazônia_igaratipo.png"

HOME="$tmp" XDG_CONFIG_HOME="$tmp/.config" \
    "$sway_bin" --validate -c "$tmp/.config/sway/config"

echo "swayfx: config valid"
