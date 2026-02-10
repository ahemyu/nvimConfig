## Ubuntu install

After cloning this repo run:

```bash
./install-wsl-ubuntu.sh
```

This installs Neovim stable, copies this config to `~/.config/nvim`, syncs plugins, and installs Mason tools.

## Windows one-shot install

After cloning this repo on the target machine, run in PowerShell:

```powershell
./install-windows.ps1
```

This installs Neovim, Git, Node.js, Python, ripgrep, and fd via winget, copies this config to `%LOCALAPPDATA%\nvim`, syncs plugins, and installs Mason tools.
