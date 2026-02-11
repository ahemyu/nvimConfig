$ErrorActionPreference = "Stop"

Set-StrictMode -Version Latest

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetConfigDir = Join-Path $env:LOCALAPPDATA "nvim"
$DataDir = Join-Path $env:LOCALAPPDATA "nvim-data"
$StateDir = Join-Path $env:LOCALAPPDATA "nvim-state"
$CacheDir = Join-Path $env:LOCALAPPDATA "nvim-cache"
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

$MasonPackages = @(
  "angular-language-server",
  "clang-format",
  "clangd",
  "codelldb",
  "cmakelang",
  "cmakelint",
  "json-lsp",
  "lua-language-server",
  "markdownlint-cli2",
  "markdown-toc",
  "marksman",
  "neocmakelsp",
  "basedpyright",
  "ruff",
  "shfmt",
  "sqlfluff",
  "stylua",
  "taplo",
  "tree-sitter-cli",
  "vtsls",
  "yaml-language-server"
)

function Require-Command {
  param([Parameter(Mandatory = $true)][string]$Name)
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Missing required command: $Name"
  }
}

function Install-WithWinget {
  param(
    [Parameter(Mandatory = $true)][string]$Id,
    [Parameter(Mandatory = $true)][string]$Label
  )
  Write-Host "==> Installing $Label"
  winget install --id $Id --exact --accept-source-agreements --accept-package-agreements --silent --disable-interactivity | Out-Host
}

function Resolve-NvimPath {
  $cmd = Get-Command nvim -ErrorAction SilentlyContinue
  if ($cmd) {
    return $cmd.Source
  }

  $Candidates = @(
    (Join-Path $env:ProgramFiles "Neovim\bin\nvim.exe"),
    (Join-Path $env:LOCALAPPDATA "nvim\bin\nvim.exe")
  )

  foreach ($candidate in $Candidates) {
    if (Test-Path $candidate) {
      return $candidate
    }
  }

  $wingetRoots = Get-ChildItem -Path (Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages") -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like "Neovim.Neovim*" }

  foreach ($root in $wingetRoots) {
    $nvimExe = Join-Path $root.FullName "nvim-win64\bin\nvim.exe"
    if (Test-Path $nvimExe) {
      return $nvimExe
    }
  }

  throw "Neovim executable was not found after installation."
}

function Backup-IfExists {
  param([Parameter(Mandatory = $true)][string]$Path)
  if (Test-Path $Path) {
    Move-Item -Path $Path -Destination "${Path}.backup-$Timestamp"
  }
}

Require-Command winget

Install-WithWinget -Id "Git.Git" -Label "Git"
Install-WithWinget -Id "Neovim.Neovim" -Label "Neovim"
Install-WithWinget -Id "OpenJS.NodeJS.LTS" -Label "Node.js LTS"
Install-WithWinget -Id "Python.Python.3.13" -Label "Python"
Install-WithWinget -Id "BurntSushi.ripgrep.MSVC" -Label "ripgrep"
Install-WithWinget -Id "sharkdp.fd" -Label "fd"

$NvimExe = Resolve-NvimPath
Write-Host "==> Using Neovim executable: $NvimExe"

Write-Host "==> Backing up existing Neovim paths"
Backup-IfExists -Path $TargetConfigDir
Backup-IfExists -Path $DataDir
Backup-IfExists -Path $StateDir
Backup-IfExists -Path $CacheDir

Write-Host "==> Installing this config to $TargetConfigDir"
New-Item -ItemType Directory -Force -Path $TargetConfigDir | Out-Null

Get-ChildItem -Path $ScriptDir -Force |
  Where-Object { $_.Name -ne ".git" } |
  ForEach-Object {
    Copy-Item -Path $_.FullName -Destination (Join-Path $TargetConfigDir $_.Name) -Recurse -Force
  }

Write-Host "==> Bootstrapping LazyVim plugins"
& $NvimExe --headless "+Lazy! sync" +qa

Write-Host "==> Installing Mason tools (best effort)"
$masonCmd = "MasonInstall $($MasonPackages -join ' ')"
$env:MASON_PACKAGES = ($MasonPackages -join ' ')
$masonOutput = & $NvimExe --headless '+lua local pkgs=vim.split(vim.env.MASON_PACKAGES or "", " ", { trimempty = true }); local ok,mason=pcall(require,"mason"); if not ok then vim.api.nvim_err_writeln("MASON_SETUP_FAILED"); vim.cmd("cquit 1"); end; if not mason.has_setup then mason.setup() end; require("mason.api.command").MasonInstall(pkgs, {})' +qa 2>&1
$masonExitCode = $LASTEXITCODE
Remove-Item Env:MASON_PACKAGES -ErrorAction SilentlyContinue
if ($masonOutput) {
  $masonOutput | Out-Host
}
if ($masonExitCode -eq 0) {
  Write-Host "==> Mason install command completed"
} else {
  Write-Warning "Headless Mason install did not complete."
  Write-Host "Open Neovim and run:"
  Write-Host "  :$masonCmd"
}

Write-Host ""
Write-Host "Done. Open Neovim with: nvim"
