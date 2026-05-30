-- =============================================================================
-- Treesitter: syntax, indentation, folding
-- ~/.config/nvim/lua/plugins/treesitter.lua
-- =============================================================================

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "python",
      "cpp", "c", "cmake",
      "markdown", "markdown_inline",  -- needed for Quarto
      "rst",
      "lua", "vim", "vimdoc",
      "json", "yaml", "toml",
      "bash",
      "regex",
      "diff",
      "query",
    },
    highlight = {
      enable = true,
      -- Disable for very large files (performance)
      disable = function(_, buf)
        local max_filesize = 500 * 1024 -- 500 KB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = { "markdown" }, -- needed for spellcheck in markdown
    },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection    = "<C-space>",
        node_incremental  = "<C-space>",
        scope_incremental = false,
        node_decremental  = "<bs>",
      },
    },
    -- nvim-treesitter-textobjects
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["ai"] = "@conditional.outer",
          ["ii"] = "@conditional.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
        goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
      },
      swap = {
        enable = true,
        swap_next     = { ["<leader>a"] = "@parameter.inner" },
        swap_previous = { ["<leader>A"] = "@parameter.inner" },
      },
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}
