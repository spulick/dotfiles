-- =============================================================================
-- Per-project local config: .nvim.lua (place in project root)
-- =============================================================================
-- AstroNvim will source this file automatically when you open a file in
-- this directory (requires 'exrc' + 'secure' options, set below).
--
-- Uncomment the lines you need.

-- ── Point to a specific conda env ─────────────────────────────────────────
-- Overrides the CONDA_PREFIX detection in astrocore.lua for this project.
-- vim.g.python3_host_prog = vim.env.HOME .. "/.conda/envs/myproject/bin/python3"

-- ── Per-project tab width (e.g. 2 for JS/TS projects mixed in) ───────────
-- vim.opt_local.tabstop    = 2
-- vim.opt_local.shiftwidth = 2

-- ── Per-project colorcolumn ───────────────────────────────────────────────
-- vim.opt_local.colorcolumn = "100"

-- ── Load a project-specific DAP configuration ─────────────────────────────
-- local dap = require("dap")
-- dap.configurations.python = {
--   {
--     type    = "python",
--     request = "launch",
--     name    = "FastAPI dev server",
--     module  = "uvicorn",
--     args    = { "app.main:app", "--reload" },
--     pythonPath = vim.env.HOME .. "/.conda/envs/myproject/bin/python3",
--   },
-- }

-- Safety: this file is loaded as Lua, so only place trusted code here.
