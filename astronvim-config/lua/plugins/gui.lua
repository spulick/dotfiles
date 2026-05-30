-- =============================================================================
-- GUI / font configuration: Neovide + Ghostty
-- ~/.config/nvim/lua/plugins/gui.lua
-- =============================================================================
-- This file is loaded by lazy.nvim on startup.
-- Settings guarded by vim.g.neovide only affect Neovide.
-- Font settings affect both Neovide and Ghostty (terminal uses its own font,
-- but guifont is used by Neovide).

---@type LazySpec
return {
  -- A dummy spec so we can attach a config function via lazy
  {
    "AstroNvim/astrocore",    -- already loaded; we piggyback on it
    opts = function(_, opts)
      -- Only apply guifont when running as a GUI (Neovide)
      if vim.g.neovide then
        -- Fira Code Nerd Font, size 13.  Adjust size to taste.
        vim.o.guifont = "FiraCode Nerd Font Mono:h13:#e-subpixelantialias:#h-slight"

        -- Ligatures: Fira Code has beautiful ligatures; enable them in Neovide
        vim.g.neovide_text_gamma           = 0.0
        vim.g.neovide_text_contrast        = 0.5

        -- Cursor
        vim.g.neovide_cursor_vfx_mode      = "railgun"   -- ripple | railgun | torpedo | pixiedust | sonicboom | ripple | wireframe
        vim.g.neovide_cursor_vfx_opacity   = 150.0
        vim.g.neovide_cursor_vfx_particle_density = 7.0
        vim.g.neovide_cursor_animate_in_insert_mode = true

        -- Padding (gives a bit of breathing room around the editor)
        vim.g.neovide_padding_top    = 8
        vim.g.neovide_padding_bottom = 8
        vim.g.neovide_padding_left   = 10
        vim.g.neovide_padding_right  = 10

        -- Fullscreen toggle
        vim.keymap.set("n", "<F11>", function()
          vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
        end, { desc = "Neovide: toggle fullscreen" })

        -- Clipboard: Neovide uses the system clipboard seamlessly
        vim.g.neovide_input_use_logo = true  -- Use Cmd key on macOS; harmless on FreeBSD
      end

      -- ── Ghostty-specific terminal settings ────────────────────────────
      -- Ghostty supports: true color, undercurl, kitty graphics protocol,
      -- and the kitty keyboard protocol.
      if not vim.g.neovide then
        -- Enable undercurl (used by diagnostics, spell)
        vim.cmd([[let &t_Cs = "\e[4:3m"]])
        vim.cmd([[let &t_Ce = "\e[4:0m"]])

        -- Strikethrough (nice to have)
        vim.cmd([[let &t_Ts = "\e[9m"]])
        vim.cmd([[let &t_Te = "\e[29m"]])
      end

      return opts
    end,
  },
}
