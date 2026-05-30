-- =============================================================================
-- Extra plugins: UI polish, git, C++ tools, general IDE quality-of-life
-- ~/.config/nvim/lua/plugins/extras.lua
-- =============================================================================

---@type LazySpec
return {
  -- ── Colorscheme: Catppuccin (works great with Fira Code, Neovide blur) ───
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    opts = {
      flavour          = "mocha",   -- latte | frappe | macchiato | mocha
      background       = { light = "latte", dark = "mocha" },
      transparent_background = false,
      show_end_of_buffer     = false,
      term_colors            = true,
      dim_inactive = {
        enabled    = true,
        shade      = "dark",
        percentage = 0.15,
      },
      styles = {
        comments    = { "italic" },
        conditionals = { "italic" },
        keywords    = { "bold" },
        functions   = { "bold" },
        strings     = {},
        variables   = {},
        numbers     = {},
      },
      integrations = {
        cmp        = true,
        gitsigns   = true,
        neotree    = true,
        treesitter = true,
        telescope  = { enabled = true },
        which_key  = true,
        dap        = { enabled = true, enable_ui = true },
        molten     = true,
        notify     = true,
        mason      = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors      = { "undercurl" },
            hints       = { "underdotted" },
            warnings    = { "undercurl" },
            information = { "underdotted" },
          },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ── Lualine: statusline ───────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme            = "catppuccin",
        globalstatus     = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics" },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "●", readonly = "×", unnamed = "[No Name]" } },
        },
        lualine_x = {
          -- Show active conda env
          {
            function()
              local conda = vim.env.CONDA_PREFIX
              if conda then
                return "  " .. vim.fn.fnamemodify(conda, ":t")
              end
              return ""
            end,
            color = { fg = "#a6e3a1" },
          },
          { "encoding",  cond = function() return vim.o.fileencoding ~= "utf-8" end },
          { "fileformat", icons_enabled = false },
          "progress",
        },
        lualine_y = {},
        lualine_z = { "location" },
      },
    },
  },

  -- ── Which-key: keymap discovery ───────────────────────────────────────────
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>j",  group = "Jupyter/Molten" },
        { "<leader>q",  group = "Quarto" },
        { "<leader>g",  group = "Git" },
        { "<leader>d",  group = "Diagnostics" },
        { "<leader>r",  group = "Run" },
        { "<leader>b",  group = "Buffer" },
        { "<leader>f",  group = "Find/Telescope" },
        { "<leader>l",  group = "LSP" },
        { "<leader>c",  group = "Code" },
      },
    },
  },

  -- ── Git signs in the gutter ───────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", gs.next_hunk,                    "Next hunk")
        map("n", "[h", gs.prev_hunk,                    "Prev hunk")
        map("n", "<leader>ghs", gs.stage_hunk,          "Stage hunk")
        map("n", "<leader>ghr", gs.reset_hunk,          "Reset hunk")
        map("n", "<leader>ghS", gs.stage_buffer,        "Stage buffer")
        map("n", "<leader>ghR", gs.reset_buffer,        "Reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>ghd", gs.diffthis,            "Diff this")
      end,
    },
  },

  -- ── LazyGit integration ───────────────────────────────────────────────────
  {
    "kdheepak/lazygit.nvim",
    cmd  = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- ── DiffView: rich git diff / merge ──────────────────────────────────────
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  },

  -- ── Trouble: pretty diagnostics list ─────────────────────────────────────
  {
    "folke/trouble.nvim",
    cmd  = "Trouble",
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",       desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>",           desc = "Symbols (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",            desc = "Quickfix (Trouble)" },
    },
  },

  -- ── Todo-comments ─────────────────────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    opts  = {},
    keys  = {
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
    },
  },

  -- ── Noice: better cmdline + notifications ─────────────────────────────────
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        progress     = { enabled = true },
        override     = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"]   = true,
        },
        hover        = { enabled = false }, -- let AstroLSP handle hover
        signature    = { enabled = false },
      },
      presets = {
        bottom_search         = true,
        command_palette       = true,
        long_message_to_split = true,
        inc_rename            = true,
        lsp_doc_border        = true,
      },
    },
  },

  -- ── nvim-notify: notification backend ────────────────────────────────────
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout    = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width  = function() return math.floor(vim.o.columns * 0.75) end,
      on_open    = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },

  -- ── C++: clangd_extensions (extra LSP features) ───────────────────────────
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft   = { "c", "cpp" },
    opts = {
      inlay_hints = {
        parameter_hints_prefix   = "  ← ",
        other_hints_prefix       = "  » ",
      },
    },
  },

  -- ── C++: CMake integration ────────────────────────────────────────────────
  {
    "Civitasv/cmake-tools.nvim",
    ft   = { "cmake", "cpp", "c" },
    opts = {
      cmake_build_directory        = "build",
      cmake_build_type             = "Debug",
      cmake_generate_options       = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
      cmake_soft_link_compile_commands = true,   -- symlink compile_commands.json to root
    },
    keys = {
      { "<leader>cb",  "<cmd>CMakeBuild<cr>",         desc = "CMake build" },
      { "<leader>cg",  "<cmd>CMakeGenerate<cr>",      desc = "CMake generate" },
      { "<leader>cr",  "<cmd>CMakeRun<cr>",           desc = "CMake run" },
      { "<leader>cd",  "<cmd>CMakeDebug<cr>",         desc = "CMake debug" },
      { "<leader>ct",  "<cmd>CMakeSelectBuildTarget<cr>", desc = "CMake select target" },
      { "<leader>cs",  "<cmd>CMakeSelectBuildType<cr>",   desc = "CMake select build type" },
    },
  },

  -- ── Autopairs ─────────────────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts  = {
      check_ts        = true,           -- use treesitter for smarter pairing
      ts_config       = {
        lua    = { "string", "source" },
        python = { "string" },
      },
    },
  },

  -- ── Surround ──────────────────────────────────────────────────────────────
  {
    "kylechui/nvim-surround",
    version = "*",
    event   = "VeryLazy",
    opts    = {},
  },

  -- ── inc-rename: live rename preview ──────────────────────────────────────
  {
    "smjonas/inc-rename.nvim",
    cmd    = "IncRename",
    config = true,
    keys   = {
      {
        "<F2>",
        function() return ":IncRename " .. vim.fn.expand("<cword>") end,
        expr = true,
        desc = "LSP rename (live preview)",
      },
    },
  },

  -- ── Mini.comment: smart commenting ───────────────────────────────────────
  {
    "echasnovski/mini.comment",
    version = "*",
    event   = "VeryLazy",
    opts    = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring()
              or vim.bo.commentstring
        end,
      },
    },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  },

  -- ── Projects: auto-detect project roots ──────────────────────────────────
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        detection_methods   = { "pattern", "lsp" },
        patterns            = { ".git", "pyproject.toml", "setup.py", "CMakeLists.txt", ".nvim.lua" },
        show_hidden         = false,
        silent_chdir        = true,
      })
      -- Telescope integration
      require("telescope").load_extension("projects")
    end,
  },
}
