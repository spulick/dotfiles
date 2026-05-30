-- =============================================================================
-- Mason: ensure tools are installed
-- ~/.config/nvim/lua/plugins/mason.lua
-- =============================================================================
-- Run :MasonToolsInstall after first launch to install everything below.

---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- ── LSP servers ───────────────────────────────────────────────────
        "pyright",
        "ruff-lsp",
        "clangd",
        "cmake-language-server",
        "marksman",

        -- ── Formatters ────────────────────────────────────────────────────
        "black",        -- Python formatter
        "isort",        -- Python import sorter (ruff can replace, but useful fallback)
        "clang-format", -- C++ formatter
        "prettier",     -- Markdown / YAML / JSON

        -- ── Linters ───────────────────────────────────────────────────────
        "ruff",         -- Python linter (fast, Rust-based)
        "cpplint",      -- C++ linter (optional, clangd handles most)
        "markdownlint", -- Markdown linting

        -- ── DAP (debuggers) ───────────────────────────────────────────────
        "debugpy",      -- Python debugger
        "codelldb",     -- C/C++ debugger (LLDB-based, works on FreeBSD)
      },
      auto_update = false,
      run_on_start = false, -- set true if you want auto-install on startup
    },
  },
}
