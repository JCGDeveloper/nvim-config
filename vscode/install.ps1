# ============================================================================
#  install.ps1  —  Setup / actualización de VSCode + vscode-neovim en Windows
#
#  Qué hace (idempotente, con backups):
#    1. Instala Neovim con winget si falta.
#    2. Clona o actualiza este repo en %USERPROFILE%\nvim-config.
#    3. Copia init.lua a la ruta por defecto de nvim (%LOCALAPPDATA%\nvim).
#    4. Copia keybindings.json a la config de VSCode (con backup).
#    5. NO toca tu settings.json (para no pisar tus preferencias) — solo avisa.
#
#  Cómo ejecutarlo (copiá y pegá esta línea en PowerShell):
#    powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\nvim-config\vscode\install.ps1"
#
#  Si todavía NO clonaste el repo, primero:
#    git clone https://github.com/JCGDeveloper/nvim-config.git "$env:USERPROFILE\nvim-config"
# ============================================================================

$ErrorActionPreference = "Stop"

$repo     = "$env:USERPROFILE\nvim-config"
$repoUrl  = "https://github.com/JCGDeveloper/nvim-config.git"
$nvimCfg  = "$env:LOCALAPPDATA\nvim"
$codeUser = "$env:APPDATA\Code\User"
$stamp    = Get-Date -Format "yyyyMMdd-HHmmss"

function Info($m) { Write-Host "[..] $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "[OK] $m" -ForegroundColor Green }
function Warn($m) { Write-Host "[!]  $m" -ForegroundColor Yellow }

# 1) Neovim ------------------------------------------------------------------
if ((Test-Path "C:\Program Files\Neovim\bin\nvim.exe") -or (Get-Command nvim -ErrorAction SilentlyContinue)) {
  Ok "Neovim ya está instalado"
} else {
  Info "Instalando Neovim con winget..."
  winget install --id Neovim.Neovim -e --source winget
  Ok "Neovim instalado"
}

# 2) Repo --------------------------------------------------------------------
if (Test-Path "$repo\.git") {
  Info "Actualizando repo..."
  git -C $repo pull
} else {
  Info "Clonando repo en $repo..."
  git clone $repoUrl $repo
}
Ok "Repo listo: $repo"

# 2.5) Extensiones de VSCode ------------------------------------------------
if (Get-Command code -ErrorAction SilentlyContinue) {
  foreach ($ext in @("asvetliakov.vscode-neovim", "qufiwefefwoyn.kanagawa", "s-nlf-fh.glassit", "pkief.material-icon-theme", "Gruntfuggly.todo-tree", "eamodio.gitlens")) {
    Info "Instalando extension $ext..."
    code --install-extension $ext --force | Out-Null
  }
  Ok "Extensiones instaladas (vscode-neovim, kanagawa, glassit)"
} else {
  Warn "El comando 'code' no esta en el PATH; instala a mano: vscode-neovim, kanagawa, glassit."
}

# 3) init.lua -> ruta por defecto de nvim ------------------------------------
New-Item -ItemType Directory -Force -Path $nvimCfg | Out-Null
if (Test-Path "$nvimCfg\init.lua") {
  Copy-Item "$nvimCfg\init.lua" "$nvimCfg\init.lua.bak-$stamp"
  Warn "Backup del init anterior: $nvimCfg\init.lua.bak-$stamp"
}
Copy-Item "$repo\vscode\init.lua" "$nvimCfg\init.lua" -Force
Ok "init.lua copiado a $nvimCfg\init.lua"

# 4) keybindings.json -> config de VSCode ------------------------------------
New-Item -ItemType Directory -Force -Path $codeUser | Out-Null
if (Test-Path "$codeUser\keybindings.json") {
  Copy-Item "$codeUser\keybindings.json" "$codeUser\keybindings.json.bak-$stamp"
  Warn "Backup de keybindings anterior: $codeUser\keybindings.json.bak-$stamp"
}
Copy-Item "$repo\vscode\keybindings.json" "$codeUser\keybindings.json" -Force
Ok "keybindings.json copiado a $codeUser"

# 5) settings.json -> NO se pisa ---------------------------------------------
Warn "settings.json NO se toca (para no pisar tus preferencias de VSCode)."
Warn "Si es instalacion nueva, fusiona a mano las claves de: $repo\vscode\settings.json"

Write-Host ""
Ok "TERMINADO. Ultimo paso EN VSCODE:"
Write-Host "   Ctrl+Shift+P  ->  Developer: Reload Window" -ForegroundColor White
Write-Host "   Luego, en modo normal (cursor bloque), proba:  espacio s h" -ForegroundColor White
