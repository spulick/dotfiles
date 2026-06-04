#!bin/bash

DOTFILES="$HOME/code/dotfiles"

DIRS="
$HOME/.fluxbox/init     fluxbox
$HOME/.config/polybar   polybar
$HOME/.config/nvim      nvim
"


FILES="
$HOME/.config/starship.toml 



#!/bin/sh
# fetch-dotfiles.sh
# Copies live config files and directories into ~/code/dotfiles/
# Edit the FILES and DIRS sections below to match what you want tracked.
# Run from anywhere: sh ~/code/dotfiles/fetch-dotfiles.sh

DOTFILES="$HOME/code/dotfiles"
ERRORS=0

# ──────────────────────────────────────────────────────────
#  INDIVIDUAL FILES
#  Format: "source_file   dest_subdir"   → copies into subdir
#          "source_file"                 → copies into dotfiles root
# ──────────────────────────────────────────────────────────
FILES="
$HOME/.profile                shell
$HOME/.shrc                   shell
$HOME/.xinitrc                x11
$HOME/.Xresources             x11
"

# ──────────────────────────────────────────────────────────
#  DIRECTORIES (copied recursively)
#  Format: "source_dir   dest_name"   → mirrors into dest_name/
#          "source_dir"               → mirrors into dotfiles root
# ──────────────────────────────────────────────────────────
DIRS="
$HOME/.fluxbox                fluxbox
$HOME/.config/polybar         polybar
$HOME/.config/picom           picom
$HOME/.config/qtpass          qtpass
$HOME/.gnupg                  gnupg
"

# ──────────────────────────────────────────────────────────
#  HELPERS
# ──────────────────────────────────────────────────────────
log()  { printf '  \033[32m✔\033[0m  %s\n' "$1"; }
warn() { printf '  \033[33m⚠\033[0m  %s\n' "$1"; }
err()  { printf '  \033[31m✘\033[0m  %s\n' "$1"; ERRORS=$((ERRORS + 1)); }

copy_file() {
    src="$1"
    dest="${2:+$DOTFILES/$2}"
    dest="${dest:-$DOTFILES}"

    if [ ! -f "$src" ]; then
        warn "Skipping (not found): $src"
        return
    fi

    mkdir -p "$dest" || { err "Could not create: $dest"; return; }
    cp "$src" "$dest/" && log "$src" || err "Failed: $src"
}

copy_dir() {
    src="$1"
    dest="${2:+$DOTFILES/$2}"
    dest="${dest:-$DOTFILES}"

    if [ ! -d "$src" ]; then
        warn "Skipping (not found): $src"
        return
    fi

    mkdir -p "$dest" || { err "Could not create: $dest"; return; }
    cp -r "$src/." "$dest/" && log "$src" || err "Failed: $src"
}

# ──────────────────────────────────────────────────────────
#  MAIN
# ──────────────────────────────────────────────────────────
echo ""
echo "Fetching dotfiles into $DOTFILES"
echo "──────────────────────────────────────"

echo "\nFiles:"
echo "$FILES" | while IFS= read -r line; do
    [ -z "$(echo "$line" | tr -d '[:space:]')" ] && continue
    src=$(echo "$line"  | awk '{print $1}')
    dest=$(echo "$line" | awk '{print $2}')
    copy_file "$src" "$dest"
done

echo "\nDirectories:"
echo "$DIRS" | while IFS= read -r line; do
    [ -z "$(echo "$line" | tr -d '[:space:]')" ] && continue
    src=$(echo "$line"  | awk '{print $1}')
    dest=$(echo "$line" | awk '{print $2}')
    copy_dir "$src" "$dest"
done

echo "\n──────────────────────────────────────"
if [ "$ERRORS" -eq 0 ]; then
    echo "Done. All items fetched successfully."
else
    echo "Done with $ERRORS error(s). Check output above."
fi
echo ""