## Ubuntu install

After cloning this repo run:

```bash
./install-wsl-ubuntu.sh
```

This installs Neovim stable, copies this config to `~/.config/nvim`, syncs plugins, and installs Mason tools.

If the script warns that headless Mason installation did not complete, open Neovim and run:

```vim
:MasonInstall angular-language-server cmakelang cmakelint json-lsp lua-language-server markdownlint-cli2 markdown-toc marksman neocmakelsp pyright ruff shfmt sqlfluff stylua taplo tree-sitter-cli vtsls yaml-language-server
```

## Windows install

After cloning this repo run in PowerShell:

```powershell
./install-windows.ps1
```

This installs Neovim, Git, Node.js, Python, ripgrep, and fd via winget, copies this config to `%LOCALAPPDATA%\nvim`, syncs plugins, and installs Mason tools.
