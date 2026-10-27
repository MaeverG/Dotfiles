#!/bin/bash
# Bootstrap a new Mac: installs Homebrew + packages, symlinks configs, installs tmux plugins.
# Existing files are moved to <name>.bak.<timestamp> before being replaced.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

link() { # link <source> <target>
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then return; fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak.$STAMP"
    echo "backed up $dst -> $dst.bak.$STAMP"
  fi
  ln -s "$src" "$dst"
  echo "linked $dst"
}

# 1. Homebrew + packages
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew bundle --file="$REPO/Brewfile" || echo "Some Brewfile entries failed; re-run 'brew bundle --file=$REPO/Brewfile' to see which."

# 2. Symlink ~/.config/* and home dotfiles
for dir in "$REPO"/config/*/; do
  link "${dir%/}" "$HOME/.config/$(basename "$dir")"
done
link "$REPO/home/.zshenv" "$HOME/.zshenv"
# .gitconfig is copied, not linked, so machine-specific credentials stay local
[ -e "$HOME/.gitconfig" ] || cp "$REPO/home/.gitconfig" "$HOME/.gitconfig"

# 3. tmux plugin manager + plugins
TPM="$HOME/.config/tmux/plugins/tpm"
[ -d "$TPM" ] || git clone https://github.com/tmux-plugins/tpm "$TPM"
"$TPM/bin/install_plugins" || true

cat <<MSG

Done. Remaining manual steps:
  - gh auth login            (GitHub CLI credentials are not stored in this repo)
  - Set your terminal font to a Nerd Font (installed via Brewfile)
  - Open nvim once to let lazy.nvim install plugins
  - Restart your terminal
MSG
