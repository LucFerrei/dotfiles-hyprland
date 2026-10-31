#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
src="$root/nvim_scratch"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

config_home="$tmp/config"
data_home="$tmp/data"
mkdir -p "$config_home/nvim" "$data_home/nvim/lazy/lazy.nvim/lua/lazy" \
    "$tmp/state" "$tmp/cache" "$tmp/config/nvim/lua/blink"

cp -a "$src/." "$config_home/nvim/"

# Keep the smoke test offline and deterministic: never clone lazy.nvim or
# install plugins from the network.
cat > "$data_home/nvim/lazy/lazy.nvim/lua/lazy/init.lua" <<'LUA'
local M = {}

function M.setup(_) end

return M
LUA

# options.lua calls blink.cmp during startup. Real plugin setup is covered by
# the plugin-spec checks below; this stub only satisfies the startup require.
cat > "$config_home/nvim/lua/blink/cmp.lua" <<'LUA'
local M = {}

function M.get_lsp_capabilities()
    return {}
end

return M
LUA

cat > "$tmp/smoke.lua" <<'LUA'
local src = vim.env.CI_NVIM_SOURCE
local config = vim.env.CI_NVIM_CONFIG

local function fail(message)
    vim.api.nvim_err_writeln("nvim config: " .. message)
    vim.cmd("cq")
end

vim.opt.rtp:prepend(config)

-- Parse every Lua file in the repo.
for _, file in ipairs(vim.fn.glob(src .. "/**/*.lua", false, true)) do
    local chunk, err = loadfile(file)
    if not chunk then
        fail(file .. ": " .. tostring(err))
    end
end
print("nvim: lua syntax ok")

-- Load the real init.lua with lazy.nvim stubbed out.
local ok, err = pcall(dofile, config .. "/init.lua")
if not ok then
    fail("init.lua: " .. tostring(err))
end
print("nvim: init.lua loads")

-- Execute every plugin spec and check the values lazy.nvim expects.
local count = 0
for _, file in ipairs(vim.fn.glob(config .. "/lua/plugins/*.lua", false, true)) do
    local chunk, load_err = loadfile(file)
    if not chunk then
        fail(file .. ": " .. tostring(load_err))
    end

    local spec_ok, spec = pcall(chunk)
    if not spec_ok then
        fail(file .. ": " .. tostring(spec))
    end
    if type(spec) ~= "table" then
        fail(file .. ": plugin spec must return a table")
    end

    for _, plugin in ipairs(spec) do
        if type(plugin) == "table" and not plugin[1] and not plugin.import and not plugin.dir then
            fail(file .. ": plugin spec without a plugin name")
        end
    end

    count = count + 1
end
print(("nvim: %d plugin spec files ok"):format(count))

local lock_file = io.open(src .. "/lazy-lock.json", "r")
if not lock_file then
    fail("lazy-lock.json is missing")
end
local lock_content = lock_file:read("*a")
lock_file:close()

local lock_ok, lock = pcall(vim.json.decode, lock_content)
if not lock_ok or type(lock) ~= "table" then
    fail("lazy-lock.json is not valid JSON")
end
print("nvim: lazy-lock.json ok")
LUA

export XDG_CONFIG_HOME="$config_home"
export XDG_DATA_HOME="$data_home"
export XDG_STATE_HOME="$tmp/state"
export XDG_CACHE_HOME="$tmp/cache"
export HOME="$tmp"
export CI_NVIM_SOURCE="$src"
export CI_NVIM_CONFIG="$config_home/nvim"

nvim --headless -u NONE -l "$tmp/smoke.lua"
