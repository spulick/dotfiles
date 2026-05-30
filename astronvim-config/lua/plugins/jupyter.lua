-- =============================================================================
-- Jupyter + Quarto: inline execution via Molten + Quarto plugin
-- ~/.config/nvim/lua/plugins/jupyter.lua
-- =============================================================================
-- Prerequisites (install in conda env):
--   pip install pynvim jupyter_client cairosvg plotly kaleido pyperclip
--   pip install nbformat
--   For Quarto: install quarto-cli from https://quarto.org

---@type LazySpec
return {
  -- ── Molten: inline Jupyter execution ────────────────────────────────────
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    init = function()
      -- Output window appearance
      vim.g.molten_image_provider           = "image.nvim"  -- use image.nvim for plots
      vim.g.molten_output_win_max_height    = 24
      vim.g.molten_output_win_border        = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      vim.g.molten_virt_text_output         = true    -- show truncated output inline
      vim.g.molten_virt_lines_off_by_one    = false
      vim.g.molten_auto_open_output         = true
      vim.g.molten_wrap_output              = true
      vim.g.molten_enter_output_behavior    = "open_then_enter"
      vim.g.molten_output_crop_border       = true
      vim.g.molten_output_show_more         = true
      vim.g.molten_use_border_highlights    = true
      vim.g.molten_tick_rate                = 142     -- ~match 144 Hz display
      vim.g.molten_save_path                = vim.fn.stdpath("data") .. "/molten"
    end,
    dependencies = {
      { "3rd/image.nvim" }, -- image rendering (needs imagemagick + ueberzug or kitty/ghostty)
    },
  },

  -- ── image.nvim: render plots inside nvim ─────────────────────────────────
  -- Ghostty supports the kitty graphics protocol, so this works out of the box
  {
    "3rd/image.nvim",
    lazy = true,
    opts = {
      backend                        = "kitty",  -- Ghostty supports kitty protocol
      integrations                   = {},
      max_width                      = 100,
      max_height                     = 40,
      max_height_window_percentage   = math.huge,
      max_width_window_percentage    = math.huge,
      window_overlap_clear_enabled   = true,
      window_overlap_clear_ft        = { "cmp_menu", "cmp_docs", "" },
    },
  },

  -- ── NotebookNavigator: cell movement + execution ─────────────────────────
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dependencies = {
      "echasnovski/mini.comment",
      "benlubas/molten-nvim",
      "anuvyklack/hydra.nvim", -- optional: hydra for cell navigation mode
    },
    opts = {
      cell_markers = {
        python   = "# %%",
        markdown = "```",
      },
      -- Activate Molten automatically when opening .py files with cell markers
      activate_hydra_keys = nil,   -- set e.g. "<leader>jn" to enable hydra mode
    },
    keys = {
      -- Execute cell and move to next (like Shift+Enter in Jupyter)
      {
        "<S-CR>",
        function()
          require("notebook-navigator").run_cell()
          require("notebook-navigator").move_cell("d")
        end,
        desc = "Run cell and move to next",
      },
      -- Execute cell, stay put (like Ctrl+Enter)
      {
        "<C-CR>",
        function() require("notebook-navigator").run_cell() end,
        desc = "Run cell",
      },
      -- Run all cells above
      {
        "<leader>ja",
        function() require("notebook-navigator").run_all_cells() end,
        desc = "Molten: run all cells",
      },
    },
  },

  -- ── Quarto: .qmd file support ─────────────────────────────────────────────
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",        -- embedded language LSP in code blocks
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto" },
    opts = {
      lspFeatures = {
        enabled      = true,
        chunks       = "curly",
        languages    = { "python", "r", "julia", "bash" },
        diagnostics  = { enabled = true, triggers = { "BufWritePost" } },
        completion   = { enabled = true },
      },
      codeRunner = {
        enabled        = true,
        default_method = "molten",  -- use Molten for inline execution
      },
      keymap = {
        -- Disable quarto's default keymaps; we set them in astrocore.lua
        hover         = "<F10>",
        definition    = "<F12>",
        rename        = "<F2>",
        references    = "<S-F12>",
        format        = "<leader>lf",
        -- Preview is mapped to <leader>qp in astrocore.lua
      },
    },
  },

  -- ── Otter: LSP for embedded code blocks in Quarto/markdown ───────────────
  {
    "jmbuhr/otter.nvim",
    lazy = true,
    opts = {
      lsp = {
        hover = { border = "rounded" },
      },
      buffers = {
        set_filetype = true,
      },
    },
  },
}
