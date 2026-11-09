#!/usr/bin/env bash
# Symlink dotfiles into $HOME. Existing targets are moved to <target>.bak.
set -euo pipefail
cd "$(dirname "$0")"
D=$PWD

link() { # src dst
  mkdir -p "$(dirname "$2")"
  [ -L "$2" ] || { [ -e "$2" ] && mv "$2" "$2.bak"; }
  ln -sfn "$D/$1" "$2"
  echo "$2 -> $1"
}

[ "${1:-}" = "--brew" ] && brew bundle --file=Brewfile
[ -d ~/.oh-my-zsh ] || KEEP_ZSHRC=yes RUNZSH=no CHSH=no sh -c \
  "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
xcode-select -p >/dev/null 2>&1 || xcode-select --install # cc for treesitter parsers
[ -x "$(command -v rustup)" ] && ! command -v cargo >/dev/null && rustup default stable

link nvim           ~/.config/nvim
link mole           ~/.config/mole
link tmux.conf      ~/.tmux.conf
link zshrc          ~/.zshrc
