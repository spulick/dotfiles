-- =============================================================================
-- DAP: debugger for Python (debugpy) and C++ (codelldb)
-- ~/.config/nvim/lua/plugins/dap.lua
-- =============================================================================

---@type LazySpec
return {
  -- ── nvim-dap core ─────────────────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      local dap = require("dap")

      -- ── Python / debugpy ────────────────────────────────────────────────
      dap.adapters.python = function(cb, config)
        if config.request == "attach" then
          local port = (config.connect or config).port
          local host = (config.connect or config).host or "127.0.0.1"
          cb({ type = "server", port = port, host = host,
            options = { source_filetype = "python" } })
        else
          cb({
            type    = "executable",
            command = (vim.env.CONDA_PREFIX or "") .. "/bin/python3",
            args    = { "-m", "debugpy.adapter" },
            options = { source_filetype = "python" },
          })
        end
      end

      dap.configurations.python = {
        {
          type    = "python",
          request = "launch",
          name    = "Launch file",
          program = "${file}",
          pythonPath = function()
            return vim.env.CONDA_PREFIX and (vim.env.CONDA_PREFIX .. "/bin/python3")
              or vim.fn.exepath("python3")
          end,
        },
        {
          type    = "python",
          request = "launch",
          name    = "Launch with args",
          program = "${file}",
          args    = function()
            local args = vim.fn.input("Args: ")
            return vim.split(args, " ", { trimempty = true })
          end,
          pythonPath = function()
            return vim.env.CONDA_PREFIX and (vim.env.CONDA_PREFIX .. "/bin/python3")
              or vim.fn.exepath("python3")
          end,
        },
        {
          type    = "python",
          request = "attach",
          name    = "Attach remote (localhost:5678)",
          connect = { host = "127.0.0.1", port = 5678 },
        },
      }

      -- ── C++ / codelldb ──────────────────────────────────────────────────
      -- codelldb installed by Mason: ~/.local/share/nvim/mason/packages/codelldb/
      local mason_pkg = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
      local codelldb_path = mason_pkg .. "/extension/adapter/codelldb"
      local liblldb_path  = mason_pkg .. "/extension/lldb/lib/liblldb.so"

      -- FreeBSD note: if codelldb's bundled LLDB doesn't work, point to system:
      -- local liblldb_path = "/usr/local/lib/liblldb.so"

      local ok, dap_cpp = pcall(require, "dap")
      if ok then
        dap.adapters.codelldb = {
          type    = "server",
          port    = "${port}",
          executable = {
            command = codelldb_path,
            args    = { "--port", "${port}" },
          },
        }
      end

      dap.configurations.cpp = {
        {
          name    = "Launch (codelldb)",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
          args        = {},
        },
        {
          name    = "Attach to PID",
          type    = "codelldb",
          request = "attach",
          pid     = require("dap.utils").pick_process,
          cwd     = "${workspaceFolder}",
        },
      }
      -- C shares C++ configs
      dap.configurations.c = dap.configurations.cpp
    end,
  },

  -- ── nvim-dap-ui ────────────────────────────────────────────────────────────
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    opts = {
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▶" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open   = "o",
        remove = "d",
        edit   = "e",
        repl   = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.35 },
            { id = "breakpoints", size = 0.15 },
            { id = "stacks",      size = 0.30 },
            { id = "watches",     size = 0.20 },
          },
          size     = 45,
          position = "left",
        },
        {
          elements = {
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size     = 12,
          position = "bottom",
        },
      },
      floating = { border = "rounded" },
    },
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)
      -- Auto-open/close UI with DAP sessions
      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
    end,
  },

  -- ── nvim-dap-python: conda-aware helper ───────────────────────────────────
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "python",
    config = function()
      local python = vim.env.CONDA_PREFIX and (vim.env.CONDA_PREFIX .. "/bin/python3")
        or vim.fn.exepath("python3")
      require("dap-python").setup(python)
      -- Additional test configs
      require("dap-python").test_runner = "pytest"
    end,
  },
}
