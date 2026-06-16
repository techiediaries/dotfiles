#!/bin/bash
# Append all bashrc scripts to ~/.bashrc

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for file in "$DOTFILES_DIR"/bashrc/*.sh; do
  echo "" >> ~/.bashrc
  cat "$file" >> ~/.bashrc
done

source ~/.bashrc
echo "Done. Reload your terminal or run: source ~/.bashrc"
