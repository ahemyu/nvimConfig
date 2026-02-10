#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_CONFIG_DIR="$HOME/.config/nvim"
LOCAL_BIN_DIR="$HOME/.local/bin"
NVIM_INSTALL_DIR="$HOME/.local/nvim"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

MASON_PACKAGES=(
  angular-language-server
  cmakelang
  cmakelint
  json-lsp
  lua-language-server
  markdownlint-cli2
  markdown-toc
  marksman
  neocmakelsp
  pyright
  ruff
  shfmt
  sqlfluff
  stylua
  taplo
  vtsls
  yaml-language-server
)

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

echo "==> Installing Ubuntu packages"
sudo apt update
sudo apt install -y \
  git \
  curl \
  unzip \
  build-essential \
  ripgrep \
  fd-find \
  xclip \
  python3 \
  python3-pip \
  python3-venv \
  npm \
  luarocks

echo "==> Installing Neovim stable"
mkdir -p "$LOCAL_BIN_DIR"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
curl -fL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" -o "$TMP_DIR/nvim.tar.gz"
rm -rf "$NVIM_INSTALL_DIR"
tar -xzf "$TMP_DIR/nvim.tar.gz" -C "$TMP_DIR"
mv "$TMP_DIR/nvim-linux-x86_64" "$NVIM_INSTALL_DIR"
ln -sf "$NVIM_INSTALL_DIR/bin/nvim" "$LOCAL_BIN_DIR/nvim"

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "==> Backing up existing Neovim data"
for dir in "$HOME/.config/nvim" "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"; do
  if [ -e "$dir" ] && [ "$dir" != "$SCRIPT_DIR" ]; then
    mv "$dir" "${dir}.backup-${TIMESTAMP}"
  fi
done

echo "==> Installing this config to $TARGET_CONFIG_DIR"
mkdir -p "$TARGET_CONFIG_DIR"
if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete --exclude ".git" "$SCRIPT_DIR/" "$TARGET_CONFIG_DIR/"
else
  cp -a "$SCRIPT_DIR/." "$TARGET_CONFIG_DIR/"
  rm -rf "$TARGET_CONFIG_DIR/.git"
fi

echo "==> Bootstrapping LazyVim plugins"
require_cmd nvim
nvim --headless "+Lazy! sync" +qa

echo "==> Installing Mason tools"
nvim --headless "+MasonInstall ${MASON_PACKAGES[*]}" +qa

echo ""
echo "Done. Open Neovim with: nvim"
echo "If this is a fresh shell, run: source ~/.bashrc"
