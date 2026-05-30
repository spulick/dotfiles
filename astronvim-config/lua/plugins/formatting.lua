-- =============================================================================
-- conform.nvim: formatting
-- ~/.config/nvim/lua/plugins/formatting.lua
-- =============================================================================

---@type LazySpec
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd   = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      python   = { "ruff_format", "ruff_organize_imports" }, -- fast, replaces black+isort
      cpp      = { "clang_format" },
      c        = { "clang_format" },
      cmake    = { "cmake_format" },
      markdown = { "prettier" },
      quarto   = { "prettier" },
      json     = { "prettier" },
      yaml     = { "prettier" },
      toml     = { "taplo" },
      lua      = { "stylua" },
      sh       = { "shfmt" },
      -- fallback: try prettier for anything else
      ["_"]   = { "trim_whitespace", "trim_newlines" },
    },

    -- Format on save (with a timeout so it doesn't hang)
    format_on_save = {
      timeout_ms = 1500,
      lsp_fallback = true,
    },

    formatters = {
      ruff_format = {
        -- ruff is already on PATH from conda env
        prepend_args = { "--line-length", "88" },
      },
      clang_format = {
        prepend_args = { "--style", "file,{BasedOnStyle: LLVM, IndentWidth: 4}" },
      },
    },
  },
}
