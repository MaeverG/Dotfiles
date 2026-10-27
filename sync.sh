#!/bin/bash
# Copy live configs from ~/.config back into this repo (only needed if not symlinked).
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO"
for dir in config/*/; do
  name="$(basename "$dir")"
  [ -L "$HOME/.config/$name" ] && continue   # symlinked: already the same files
  rsync -a --exclude='.git' --exclude='plugins/' --exclude='images/' "$HOME/.config/$name/" "$dir"
done
brew bundle dump --file="$REPO/Brewfile" --force
git status --short
