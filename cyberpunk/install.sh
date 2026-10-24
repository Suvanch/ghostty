#!/usr/bin/env bash
# Put the cyberpunk Ghostty setup in place from this folder. Safe to re-run:
# anything it would overwrite is backed up first, and ~/.bashrc is only
# appended to once. See README.md for what each file does.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.config/ghostty/pre-cyberpunk-backup-$(date +%Y%m%d-%H%M%S)"

backup() {  # backup <file>: copy it into $BACKUP if it exists
    if [[ -e $1 ]]; then
        mkdir -p "$BACKUP"
        cp -a "$1" "$BACKUP/"
    fi
}

warn() { printf '\e[33m!\e[0m %s\n' "$*"; }
ok() { printf '\e[36m✓\e[0m %s\n' "$*"; }

# --- Requirements (not installed by this script) ---
command -v ghostty >/dev/null || warn "Ghostty not found: install it first (README step 1)"
command -v python3 >/dev/null || warn "python3 not found: the intro needs it"
python3 -c "import qrcode" 2>/dev/null || warn "python3-qrcode not found: the intro shows the plain ring instead of the QR creature (sudo apt install python3-qrcode)"
command -v starship >/dev/null || warn "Starship not found: the prompt falls back to plain bash (README step 2)"
fc-list | grep -q "JetBrainsMono Nerd Font" || warn "JetBrainsMono Nerd Font not found: used as the fallback font (README step 2)"

# --- Ghostty config, theme, shaders ---
mkdir -p ~/.config/ghostty/themes ~/.config/ghostty/shaders
backup ~/.config/ghostty/config
backup ~/.config/ghostty/themes/Edgerunner
backup ~/.config/ghostty/shaders/sandevistan_trail.glsl
backup ~/.config/ghostty/shaders/crt.glsl
# The config uses absolute shader paths; point them at this user's home
sed "s|/home/suvanch|$HOME|g" "$SRC/files/config/ghostty/config" > ~/.config/ghostty/config
cp "$SRC/files/config/ghostty/themes/Edgerunner" ~/.config/ghostty/themes/
cp "$SRC/files/config/ghostty/shaders/"*.glsl ~/.config/ghostty/shaders/
ok "Ghostty config, Edgerunner theme and shaders"

# --- Starship prompt ---
backup ~/.config/starship.toml
cp "$SRC/files/config/starship.toml" ~/.config/starship.toml
ok "Starship prompt config"

# --- Font ---
mkdir -p ~/.local/share/fonts/ShareTechMono
cp "$SRC/files/local/share/fonts/ShareTechMono/"* ~/.local/share/fonts/ShareTechMono/
fc-cache -f ~/.local/share/fonts >/dev/null
ok "Share Tech Mono font"

# --- Intro script (edgerunner-fetch loads the QR creature from qr-ring beside it) ---
mkdir -p ~/.local/bin
backup ~/.local/bin/edgerunner-fetch
backup ~/.local/bin/qr-ring
install -m 755 "$SRC/edgerunner-fetch" ~/.local/bin/edgerunner-fetch
install -m 755 "$SRC/qr-ring" ~/.local/bin/qr-ring
ok "edgerunner-fetch intro and qr-ring in ~/.local/bin"

# --- ~/.bashrc hook ---
if grep -q "edgerunner-fetch" ~/.bashrc 2>/dev/null; then
    ok "~/.bashrc already runs the intro (left unchanged)"
else
    backup ~/.bashrc
    { echo; cat "$SRC/files/bashrc-additions.sh"; } >> ~/.bashrc
    ok "added the intro and Starship block to ~/.bashrc"
fi

[[ -d $BACKUP ]] && ok "previous files backed up to $BACKUP"
command -v ghostty >/dev/null && ghostty +validate-config && ok "Ghostty config is valid"
echo "Done. Open a new Ghostty window."
