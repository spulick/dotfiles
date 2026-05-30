-- =============================================================================
-- AstroCore: options, autocmds, keymaps
-- ~/.config/nvim/lua/plugins/astrocore.lua
-- =============================================================================

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- -------------------------------------------------------------------------
    -- Editor options
    -- -------------------------------------------------------------------------
    options = {
      opt = {
        -- Indentation
        tabstop      = 4,
        shiftwidth   = 4,
        expandtab    = true,
        smartindent  = true,

        -- Line numbers
        number         = true,
        relativenumber = true,
        signcolumn     = "yes",

        -- Search
        ignorecase = true,
        smartcase  = true,
        hlsearch   = true,
        incsearch  = true,

        -- Splits
        splitbelow = true,
        splitright = true,

        -- Wrapping / scrolling
        wrap       = false,
        scrolloff  = 8,
        sidescrolloff = 8,

        -- Misc
        termguicolors = true,
        cursorline    = true,
        colorcolumn   = "88",       -- PEP-8 / Black default
        updatetime    = 250,
        timeoutlen    = 400,
        undofile      = true,
        undolevels    = 10000,
        swapfile      = false,
        list          = true,
        listchars     = { tab = "→ ", trail = "·", nbsp = "␣" },
        -- Fira Code ligatures work best with these:
        conceallevel  = 2,          -- needed for Quarto/markdown concealment

        -- Fold via treesitter
        foldmethod    = "expr",
        foldexpr      = "nvim_treesitter#foldexpr()",
        foldlevel     = 99,         -- open all folds by default
      },
      g = {
        -- Disable unused providers (speeds up startup on FreeBSD)
        loaded_ruby_provider   = 0,
        loaded_perl_provider   = 0,
        loaded_node_provider   = 0,

        -- Python: point to the conda base or active env python
        -- Override per-project with a .nvim.lua file
        python3_host_prog = vim.fn.exepath("python3"),

        -- Neovide settings (ignored when running in Ghostty)
        neovide_refresh_rate          = 144,
        neovide_cursor_animation_length = 0.08,
        neovide_cursor_trail_size     = 0.5,
        neovide_scroll_animation_length = 0.3,
        neovide_floating_blur_amount_x  = 2.0,
        neovide_floating_blur_amount_y  = 2.0,
        neovide_transparency          = 0.95,
        neovide_remember_window_size  = true,
        -- Fira Code with ligatures in Neovide
        neovide_text_gamma            = 0.0,
        neovide_text_contrast         = 0.5,
      },
    },

    -- -------------------------------------------------------------------------
    -- Autocmds
    -- -------------------------------------------------------------------------
    autocmds = {
      -- Highlight on yank
      highlight_yank = {
        {
          event = "TextYankPost",
          desc  = "Highlight yanked text",
          callback = function()
            vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
          end,
        },
      },

      -- Python: detect conda env from $CONDA_PREFIX
      conda_python = {
        {
          event = { "BufEnter", "DirChanged" },
          pattern = { "*.py", "*.ipynb" },
          desc = "Auto-set python3_host_prog from active conda env",
          callback = function()
            local conda = vim.env.CONDA_PREFIX
            if conda then
              local py = conda .. "/bin/python3"
              if vim.fn.executable(py) == 1 then
                vim.g.python3_host_prog = py
              end
            end
          end,
        },
      },

      -- Quarto / markdown: soft wrap is nicer for prose
      prose_wrap = {
        {
          event = "FileType",
          pattern = { "markdown", "quarto", "text" },
          desc = "Soft-wrap prose files",
          callback = function()
            vim.opt_local.wrap      = true
            vim.opt_local.linebreak = true
            vim.opt_local.spell     = true
          end,
        },
      },

      -- Jupyter: treat .ipynb as JSON but open via Molten/NotebookNavigator
      ipynb_filetype = {
        {
          event = "BufEnter",
          pattern = "*.ipynb",
          desc = "Set correct filetype for notebooks",
          callback = function()
            if vim.bo.filetype ~= "ipynb" then
              vim.bo.filetype = "ipynb"
            end
          end,
        },
      },

      -- Close certain windows with q
      close_with_q = {
        {
          event = "FileType",
          pattern = {
            "help", "man", "qf", "lspinfo", "startuptime",
            "tsplayground", "PlenaryTestPopup", "notify",
          },
          desc = "Close special windows with q",
          callback = function(args)
            vim.keymap.set("n", "q", "<cmd>close<cr>",
              { buffer = args.buf, silent = true })
          end,
        },
      },
    },

    -- -------------------------------------------------------------------------
    -- Keymaps  (leader = Space, set by AstroNvim)
    -- -------------------------------------------------------------------------
    mappings = {
      n = {
        -- ── Window navigation ──────────────────────────────────────────────
        ["<C-h>"]     = { "<C-w>h",       desc = "Move to left window" },
        ["<C-j>"]     = { "<C-w>j",       desc = "Move to lower window" },
        ["<C-k>"]     = { "<C-w>k",       desc = "Move to upper window" },
        ["<C-l>"]     = { "<C-w>l",       desc = "Move to right window" },

        -- ── Resize windows ────────────────────────────────────────────────
        ["<C-Up>"]    = { "<cmd>resize +2<cr>",          desc = "Increase window height" },
        ["<C-Down>"]  = { "<cmd>resize -2<cr>",          desc = "Decrease window height" },
        ["<C-Left>"]  = { "<cmd>vertical resize -2<cr>", desc = "Decrease window width" },
        ["<C-Right>"] = { "<cmd>vertical resize +2<cr>", desc = "Increase window width" },

        -- ── Buffer navigation ─────────────────────────────────────────────
        ["<S-h>"]     = { "<cmd>bprevious<cr>", desc = "Previous buffer" },
        ["<S-l>"]     = { "<cmd>bnext<cr>",     desc = "Next buffer" },
        ["<leader>bd"] = { "<cmd>bdelete<cr>",  desc = "Delete buffer" },
        ["<leader>bD"] = { "<cmd>bdelete!<cr>", desc = "Force delete buffer" },

        -- ── File explorer ─────────────────────────────────────────────────
        ["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
        ["<leader>o"] = { "<cmd>Neotree focus<cr>",  desc = "Focus file explorer" },

        -- ── Search & replace ──────────────────────────────────────────────
        ["<leader>sr"] = { ":%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>", desc = "Replace word under cursor" },
        ["<Esc>"]      = { "<cmd>nohlsearch<cr>",    desc = "Clear search highlight" },

        -- ── LSP (F-key IDE style) ─────────────────────────────────────────
        ["<F2>"]  = { function() vim.lsp.buf.rename() end,           desc = "LSP rename" },
        ["<F4>"]  = { function() vim.lsp.buf.code_action() end,      desc = "LSP code action" },
        ["<F12>"] = { function() vim.lsp.buf.definition() end,       desc = "Go to definition" },
        ["<S-F12>"] = { function() vim.lsp.buf.references() end,     desc = "Find references" },
        ["<F10>"] = { function() vim.lsp.buf.hover() end,            desc = "LSP hover docs" },

        -- ── Diagnostics ────────────────────────────────────────────────────
        ["[d"]  = { function() vim.diagnostic.goto_prev() end, desc = "Previous diagnostic" },
        ["]d"]  = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" },
        ["<leader>dl"] = { "<cmd>Telescope diagnostics<cr>",   desc = "List diagnostics" },

        -- ── Run / Debug (F5/F9 IDE style) ─────────────────────────────────
        ["<F5>"]  = { "<cmd>lua require('dap').continue()<cr>",           desc = "DAP continue / start" },
        ["<F9>"]  = { "<cmd>lua require('dap').toggle_breakpoint()<cr>",  desc = "Toggle breakpoint" },
        ["<F11>"] = { "<cmd>lua require('dap').step_into()<cr>",          desc = "DAP step into" },
        ["<S-F11>"] = { "<cmd>lua require('dap').step_out()<cr>",         desc = "DAP step out" },
        ["<F6>"]  = { "<cmd>lua require('dap').step_over()<cr>",          desc = "DAP step over" },
        ["<F7>"]  = { "<cmd>lua require('dapui').toggle()<cr>",           desc = "Toggle DAP UI" },

        -- ── Python run (quick, no debug) ───────────────────────────────────
        ["<leader>rp"] = {
          "<cmd>split | terminal python3 %<cr>",
          desc = "Run current Python file",
        },

        -- ── Jupyter / Molten ──────────────────────────────────────────────
        ["<leader>ji"] = { "<cmd>MoltenInit<cr>",               desc = "Molten: init kernel" },
        ["<leader>jr"] = { "<cmd>MoltenReevaluateCell<cr>",     desc = "Molten: re-run cell" },
        ["<leader>jd"] = { "<cmd>MoltenDelete<cr>",             desc = "Molten: delete cell output" },
        ["<leader>jo"] = { "<cmd>MoltenShowOutput<cr>",         desc = "Molten: show output" },
        ["<leader>jh"] = { "<cmd>MoltenHideOutput<cr>",         desc = "Molten: hide output" },
        ["<leader>jx"] = { "<cmd>MoltenInterrupt<cr>",          desc = "Molten: interrupt kernel" },
        ["<leader>jR"] = { "<cmd>MoltenRestart!<cr>",           desc = "Molten: restart kernel" },
        -- Navigate cells (via NotebookNavigator)
        ["]c"] = { function() require("notebook-navigator").move_cell("d") end, desc = "Next cell" },
        ["[c"] = { function() require("notebook-navigator").move_cell("u") end, desc = "Prev cell" },

        -- ── Quarto ────────────────────────────────────────────────────────
        ["<leader>qp"] = { "<cmd>QuartoPreview<cr>",  desc = "Quarto preview" },
        ["<leader>qq"] = { "<cmd>QuartoClosePreview<cr>", desc = "Quarto close preview" },
        ["<leader>qr"] = { "<cmd>QuartoSendAbove<cr>", desc = "Quarto run above" },

        -- ── Git ───────────────────────────────────────────────────────────
        ["<leader>gg"] = { "<cmd>LazyGit<cr>",  desc = "LazyGit" },
        ["<leader>gd"] = { "<cmd>DiffviewOpen<cr>",  desc = "Diff view" },
        ["<leader>gc"] = { "<cmd>DiffviewClose<cr>", desc = "Diff view close" },

        -- ── Formatting ────────────────────────────────────────────────────
        ["<leader>lf"] = { function() vim.lsp.buf.format({ async = true }) end, desc = "Format buffer" },
        ["<leader>cf"] = { function() require("conform").format({ async = true }) end, desc = "Conform format" },

        -- ── Telescope extras ──────────────────────────────────────────────
        ["<leader>fw"] = { "<cmd>Telescope live_grep<cr>",    desc = "Live grep" },
        ["<leader>fW"] = { "<cmd>Telescope grep_string<cr>",  desc = "Grep word under cursor" },
        ["<leader>fp"] = { "<cmd>Telescope projects<cr>",     desc = "Recent projects" },

        -- ── Neovide font size ─────────────────────────────────────────────
        ["<C-=>"] = {
          function()
            if vim.g.neovide then
              vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1.0) + 0.1
            end
          end,
          desc = "Neovide: increase font scale",
        },
        ["<C-->"] = {
          function()
            if vim.g.neovide then
              vim.g.neovide_scale_factor = math.max(0.5, (vim.g.neovide_scale_factor or 1.0) - 0.1)
            end
          end,
          desc = "Neovide: decrease font scale",
        },
        ["<C-0>"] = {
          function()
            if vim.g.neovide then vim.g.neovide_scale_factor = 1.0 end
          end,
          desc = "Neovide: reset font scale",
        },
      },

      -- ── Visual mode ───────────────────────────────────────────────────────
      v = {
        -- Indent and stay in visual
        ["<"] = { "<gv", desc = "Indent left" },
        [">"] = { ">gv", desc = "Indent right" },

        -- Move selected lines
        ["J"] = { ":move '>+1<cr>gv=gv", desc = "Move selection down" },
        ["K"] = { ":move '<-2<cr>gv=gv", desc = "Move selection up" },

        -- Molten: run visual selection as cell
        ["<leader>jr"] = {
          ":<C-u>MoltenEvaluateVisual<cr>",
          desc = "Molten: run visual selection",
        },
      },

      -- ── Insert mode ───────────────────────────────────────────────────────
      i = {
        -- jk / jj to escape (ergonomic)
        ["jk"] = { "<Esc>", desc = "Escape insert mode" },
        ["jj"] = { "<Esc>", desc = "Escape insert mode" },
      },

      -- ── Terminal mode ─────────────────────────────────────────────────────
      t = {
        ["<Esc><Esc>"] = { "<C-\\><C-n>", desc = "Exit terminal mode" },
      },
    },
  },
}
