#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

export XDG_CONFIG_HOME="$tmp/config"
export XDG_DATA_HOME="$tmp/data"
export XDG_STATE_HOME="$tmp/state"
export XDG_CACHE_HOME="$tmp/cache"
export HOME="$tmp"
mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME"

# Ghostty ships a native config validator.
ghostty +validate-config --config-file="$root/ghostty/config.ghostty"
echo "ghostty: config valid"

# Zellij validates the full KDL config, including keybind blocks.
zellij -c "$root/zellij/config.kdl" setup --check >/dev/null
echo "zellij: config valid"

# Kitty does not have a --validate flag, but its Python entry point can load
# the same parser used at startup without opening a window.
cd "$root/kitty"
for conf in *.conf; do
    if ! output="$(KITTY_CONF="$conf" kitty +runpy '
import os
import kitty.config as kitty_config

bad_lines = []
kitty_config.load_config(os.environ["KITTY_CONF"], accumulate_bad_lines=bad_lines)
if bad_lines:
    for line in bad_lines:
        print(line)
    raise SystemExit(1)
print("kitty: %s parsed" % os.environ["KITTY_CONF"])
' 2>&1)"; then
        printf '%s\n' "$output" >&2
        exit 1
    fi
    printf '%s\n' "$output"

    while IFS= read -r line; do
        if [[ "$line" == *"Ignoring unknown config key"* ]] ||
            [[ "$line" == *"Could not find included config file"* ]]; then
            echo "::warning title=kitty config::${line}"
        fi
    done <<< "$output"
done
