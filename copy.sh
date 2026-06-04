#!/bin/sh

DOTFILES="$HOME/code/dotfiles"
ERRORS=0

# ──────────────────────────────────────────────────────────
#  INDIVIDUAL FILES
#  Format: "source_file   dest_subdir"   → copies into subdir
#          "source_file"                 → copies into dotfiles root
# ──────────────────────────────────────────────────────────
FILES="
$HOME/.config/starship.toml     .config/
$HOME/.bash_profile
$HOME/.bashrc
$HOME/.fehbg
$HOME/.xinitrc
$HOME/.Xauthority
"

# ──────────────────────────────────────────────────────────
#  DIRECTORIES (copied recursively)
#  Format: "source_dir   dest_name"   → mirrors into dest_name/
#          "source_dir"               → mirrors into dotfiles root
# ──────────────────────────────────────────────────────────

DIRS="
$HOME/.fluxbox          .fluxbox
$HOME/.config/polybar   .config/polybar
$HOME/.config/nvim      .config/nvim
/etc/X11/               etc/X11
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