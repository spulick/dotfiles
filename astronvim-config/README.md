# AstroNvim v4 IDE Setup
## Python · C++ · Jupyter · Quarto — FreeBSD + Ghostty + Neovide

---

## File Layout

Copy each file to the matching path under `~/.config/nvim/`:

```
~/.config/nvim/
└── lua/
    └── plugins/
        ├── astrocore.lua      ← options, keymaps, autocmds
        ├── astrolsp.lua       ← LSP servers (pyright, ruff, clangd, marksman)
        ├── mason.lua          ← tool installer
        ├── treesitter.lua     ← syntax, textobjects
        ├── jupyter.lua        ← Molten + NotebookNavigator + Quarto
        ├── dap.lua            ← debugger (debugpy + codelldb)
        ├── formatting.lua     ← conform.nvim (ruff, clang-format, prettier)
        ├── extras.lua         ← colorscheme, git, UI, C++ tools
        └── gui.lua            ← Neovide font + Ghostty settings

~/.config/ghostty/config       ← copy ghostty-config here
<project-root>/.nvim.lua       ← copy example.nvim.lua, rename, edit per project
```

---

## First-Launch Checklist

### 1. Install Python dependencies (in your base or default conda env)
```sh
pip install pynvim jupyter_client cairosvg plotly kaleido pyperclip nbformat
```
These are required by Molten for inline Jupyter execution and plot rendering.

### 2. Install system packages on FreeBSD
```sh
# C++ tools
sudo pkg install llvm clang cmake ninja

# Image rendering for Molten (Ghostty kitty protocol — no ueberzug needed)
sudo pkg install imagemagick7

# Quarto CLI (grab the latest tarball from https://quarto.org/docs/download/)
# There is no FreeBSD pkg; use the Linux binary under Linuxulator, or build from source.
# Alternatively, install via conda:
conda install -c conda-forge quarto
```

### 3. Open nvim and install plugins
```
nvim
```
Lazy.nvim will auto-install all plugins on first launch.

### 4. Install LSP servers + formatters via Mason
```
:MasonToolsInstall
```
This installs: pyright, ruff-lsp, clangd, cmake-language-server, marksman,
black, clang-format, prettier, ruff, codelldb, debugpy.

### 5. Install Treesitter parsers
```
:TSInstall python cpp c cmake markdown markdown_inline lua yaml json bash
```
Or `:TSUpdateSync` to install all configured parsers.

### 6. Verify Molten can find a kernel
Open a `.py` file (or `.ipynb`), then:
```
:MoltenInit python3
```
If you see "Kernel started", you're good. If not, check `:checkhealth molten`.

### 7. Enable per-project `.nvim.lua` (exrc)
Add this to a dedicated `~/.config/nvim/lua/plugins/exrc.lua` (or add to astrocore opts):
```lua
vim.opt.exrc   = true
vim.opt.secure = true
```
Then copy `example.nvim.lua` to your project root as `.nvim.lua` and edit it.

---

## Keybindings Reference

| Key | Action |
|-----|--------|
| **Navigation** | |
| `Ctrl+h/j/k/l` | Move between windows |
| `Shift+h / Shift+l` | Previous / next buffer |
| `[c / ]c` | Previous / next notebook cell |
| **LSP** | |
| `F2` | Rename (live preview) |
| `F4` | Code action |
| `F10` | Hover docs |
| `F12` | Go to definition |
| `Shift+F12` | Find references |
| `[d / ]d` | Previous / next diagnostic |
| `<leader>dl` | List all diagnostics |
| **Formatting** | |
| `<leader>lf` | LSP format |
| `<leader>cf` | Conform format |
| **Debug (DAP)** | |
| `F5` | Start / continue |
| `F6` | Step over |
| `F9` | Toggle breakpoint |
| `F11` | Step into |
| `Shift+F11` | Step out |
| `F7` | Toggle DAP UI |
| **Python** | |
| `<leader>rp` | Run current file in terminal |
| **Jupyter / Molten** | |
| `<leader>ji` | Init kernel |
| `Ctrl+Enter` | Run cell (stay) |
| `Shift+Enter` | Run cell + move next |
| `<leader>jr` | Re-run cell / run visual selection |
| `<leader>jo/jh` | Show / hide output |
| `<leader>jx / jR` | Interrupt / restart kernel |
| `<leader>ja` | Run all cells |
| **Quarto** | |
| `<leader>qp` | Preview document |
| `<leader>qq` | Close preview |
| `<leader>qr` | Run chunks above cursor |
| **C++ / CMake** | |
| `<leader>cg` | CMake generate |
| `<leader>cb` | CMake build |
| `<leader>cr` | CMake run |
| `<leader>cd` | CMake debug |
| **Git** | |
| `<leader>gg` | LazyGit |
| `<leader>gd` | Diff view |
| `]h / [h` | Next / prev hunk |
| `<leader>ghs/r` | Stage / reset hunk |
| **Neovide** | |
| `Ctrl++ / Ctrl+-` | Increase / decrease scale |
| `Ctrl+0` | Reset scale |
| `F11` | Toggle fullscreen |

---

## Troubleshooting

**Molten can't find kernels**
Run `jupyter kernelspec list` in your active conda env. If empty:
`python -m ipykernel install --user --name base`

**Clangd can't find headers**
Make sure your project has a `compile_commands.json`.
CMakeTools generates it automatically with `cmake_generate_options = {"-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"}`.
For non-CMake projects, use `bear -- make` to generate it.

**Codelldb crashes on FreeBSD**
Mason's bundled codelldb uses a Linux binary. Install native LLDB:
`sudo pkg install llvm` then adjust the `codelldb_path` in `dap.lua` to use
`/usr/local/bin/lldb-dap` (LLDB 16+) or `lldb-vscode` (older).

**Images not rendering in Molten**
Ghostty supports the kitty graphics protocol — confirm your Ghostty version is
recent (0.9+). Run `:checkhealth image` inside nvim to diagnose.

**Quarto not found**
If installed via conda, ensure the conda env is activated before launching nvim
so `quarto` is on `$PATH`. Or set the path explicitly:
`vim.env.PATH = vim.env.HOME .. "/.conda/envs/base/bin:" .. vim.env.PATH`
in `astrocore.lua`'s `options.g` section.
