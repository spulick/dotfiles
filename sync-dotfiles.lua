#!/usr/bin/env lua
-- sync-dotfiles.lua
-- Edit DOTFILES and ENTRIES, then run: lua sync-dotfiles.lua

local HOME     = os.getenv("HOME")
local DOTFILES = HOME .. "/dotfiles"

local ENTRIES = {
  { src = HOME .. "/.config/nvim/lua/plugins", dst = ".config/nvim/lua/plugins" },
  { src = HOME .. "/.config/nvim/init.lua",    dst = ".config/nvim/init.lua"    },
  { src = HOME .. "/.config/ghostty/config",   dst = ".config/ghostty/config"   },
  -- { src = HOME .. "/.zshrc",                dst = ".zshrc"                   },
}

-- ── helpers ──────────────────────────────────────────────────────────────

local function exists(p)
  local f = io.open(p, "r")
  if f then f:close(); return true end
  return false
end

local function is_dir(p)
  local h = io.popen("test -d '" .. p .. "' && echo yes")
  local r = h:read("*l"); h:close()
  return r == "yes"
end

local function shell(cmd)
  os.execute(cmd)
end

-- ── sync ─────────────────────────────────────────────────────────────────

for _, e in ipairs(ENTRIES) do
  local src = e.src
  local dst = DOTFILES .. "/" .. e.dst

  if not exists(src) and not is_dir(src) then
    print("SKIP (not found): " .. src)
  elseif is_dir(src) then
    shell("mkdir -p '" .. dst .. "'")
    shell("cp -rp '" .. src .. "/.' '" .. dst .. "/'")
    print("DIR  " .. e.dst)
  else
    local parent = dst:match("(.*)/")
    if parent then shell("mkdir -p '" .. parent .. "'") end
    shell("cp -p '" .. src .. "' '" .. dst .. "'")
    print("FILE " .. e.dst)
  end
end

print("done.")
