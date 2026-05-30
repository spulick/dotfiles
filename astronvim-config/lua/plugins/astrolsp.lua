-- =============================================================================
-- AstroLSP: language server configuration
-- ~/.config/nvim/lua/plugins/astrolsp.lua
-- =============================================================================

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Servers to auto-install via mason (run :MasonToolsInstall after first launch)
    servers = {
      "pyright",       -- Python static analysis
      "ruff_lsp",      -- Python linting/formatting (replaces flake8/isort/etc)
      "clangd",        -- C++ / C
      "cmake",         -- CMake files
      "marksman",      -- Markdown / Quarto cross-references
    },

    config = {
      -- ── Pyright ─────────────────────────────────────────────────────────
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths        = true,
              useLibraryCodeForTypes = true,
              diagnosticMode         = "workspace",
              typeCheckingMode       = "basic",
            },
          },
        },
        -- Dynamically pick up the active conda env
        before_init = function(_, config)
          local conda = vim.env.CONDA_PREFIX
          if conda then
            config.settings.python.pythonPath = conda .. "/bin/python3"
          else
            config.settings.python.pythonPath = vim.fn.exepath("python3")
          end
        end,
      },

      -- ── Ruff LSP ────────────────────────────────────────────────────────
      -- ruff handles linting + import sorting; pyright handles type-checking
      ruff_lsp = {
        on_attach = function(client, _)
          -- Disable hover from ruff (pyright does it better)
          client.server_capabilities.hoverProvider = false
        end,
        init_options = {
          settings = {
            args = {},
          },
        },
      },

      -- ── Clangd ──────────────────────────────────────────────────────────
      clangd = {
        capabilities = {
          offsetEncoding = "utf-16", -- clangd requires this
        },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders   = true,
          completeUnimported = true,
          clangdFileStatus  = true,
        },
      },

      -- ── Marksman (Quarto/Markdown cross-refs) ────────────────────────────
      marksman = {},
    },

    -- ── Global on_attach ─────────────────────────────────────────────────
    on_attach = function(client, bufnr)
      -- Inlay hints (Neovim 0.10+)
      if vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end,

    -- ── Diagnostic display ───────────────────────────────────────────────
    diagnostics = {
      virtual_text = {
        prefix = "●",
        spacing = 4,
      },
      update_in_insert = false,
      underline        = true,
      severity_sort    = true,
      float = {
        border = "rounded",
        source = "always",
      },
    },

    -- ── LSP UI ───────────────────────────────────────────────────────────
    lsp_handlers = {
      hover = {
        border = "rounded",
      },
      signature_help = {
        border = "rounded",
      },
    },
  },
}
