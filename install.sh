#!/usr/bin/env bash
#===============================================================================
# nvim-config — Instalador (estilo Gentleman Programming: un script, cero fricción)
#
# Pensado para Debian / Ubuntu bajo WSL2 (ordenador de empresa), pero funciona
# en cualquier Debian/Ubuntu. Instala Neovim reciente + dependencias + esta
# config de LazyVim, y las herramientas ABAP para sap-nvim.
#
# FLUJO recomendado (un comando, tras clonar este repo en ~/.config/nvim):
#   git clone <REPO> ~/.config/nvim && bash ~/.config/nvim/install.sh
#
# Diseño:
#   - Neovim se instala a NIVEL USUARIO (~/.local) desde el tarball oficial,
#     sin sudo y sin pisar el nvim del sistema.
#   - Las deps de sistema (compilador, ripgrep, fd, node…) sí usan apt (sudo),
#     pero dentro de WSL2 eso solo toca tu Debian, nunca Windows.
#   - NO corre 'Lazy sync' headless (cuelga con configs grandes): la primera
#     vez abrís Neovim normal y lazy instala los plugins con la UI visible.
#===============================================================================

set -euo pipefail

# ─── Config ──────────────────────────────────────────────────────────────────
NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-$HOME/.config/nvim}"
LOCAL_PREFIX="$HOME/.local"
NVIM_INSTALL_DIR="$LOCAL_PREFIX/nvim"
BIN_DIR="$LOCAL_PREFIX/bin"

# Colores
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'
info()  { echo -e "${CYAN}ℹ${NC} $1"; }
ok()    { echo -e "${GREEN}✔${NC} $1"; }
warn()  { echo -e "${YELLOW}⚠${NC} $1"; }
err()   { echo -e "${RED}✘${NC} $1"; }
header(){ echo -e "\n${BOLD}$1${NC}"; }

cmd_exists() { command -v "$1" >/dev/null 2>&1; }

# ─── 0. Sanity ───────────────────────────────────────────────────────────────
if ! cmd_exists apt-get; then
  err "Este instalador asume Debian/Ubuntu (apt). En otra distro, instalá las deps a mano."
  exit 1
fi

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|amd64) NVIM_ARCH="x86_64" ;;
  aarch64|arm64) NVIM_ARCH="arm64" ;;
  *) err "Arquitectura no soportada por el tarball oficial: $ARCH"; exit 1 ;;
esac

mkdir -p "$BIN_DIR"

# ─── 1. Dependencias del sistema (apt) ───────────────────────────────────────
header "[1/4] Dependencias del sistema (apt)"
sudo apt-get update
# build-essential → compilador C para los parsers de tree-sitter
# fd-find / ripgrep → búsquedas; el binario de fd en Debian es 'fdfind'
sudo apt-get install -y \
  git curl unzip \
  build-essential \
  ripgrep fd-find \
  python3 python3-venv pipx \
  nodejs npm
ok "Paquetes de sistema instalados"

# 'fd' suele venir como 'fdfind' en Debian — alias a nivel usuario
if cmd_exists fdfind && ! cmd_exists fd; then
  ln -sf "$(command -v fdfind)" "$BIN_DIR/fd"
  ok "Alias fd → fdfind creado en $BIN_DIR"
fi

# ─── 2. Neovim (tarball oficial, a nivel usuario) ────────────────────────────
header "[2/4] Neovim (última estable, en $NVIM_INSTALL_DIR)"
TARBALL="nvim-linux-${NVIM_ARCH}.tar.gz"
URL="https://github.com/neovim/neovim/releases/latest/download/${TARBALL}"
TMP="$(mktemp -d)"

info "Descargando $URL ..."
if ! curl -fL "$URL" -o "$TMP/$TARBALL"; then
  # Fallback: releases viejas usaban 'nvim-linux64.tar.gz' (solo x86_64)
  if [ "$NVIM_ARCH" = "x86_64" ]; then
    warn "Tarball nuevo no disponible; probando nombre legacy nvim-linux64.tar.gz"
    URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
    TARBALL="nvim-linux64.tar.gz"
    curl -fL "$URL" -o "$TMP/$TARBALL"
  else
    err "No se pudo descargar Neovim para $NVIM_ARCH"; exit 1
  fi
fi

rm -rf "$NVIM_INSTALL_DIR"
mkdir -p "$NVIM_INSTALL_DIR"
tar -xzf "$TMP/$TARBALL" -C "$TMP"
EXTRACTED="$(find "$TMP" -maxdepth 1 -type d -name 'nvim-linux*' | head -1)"
cp -a "$EXTRACTED"/. "$NVIM_INSTALL_DIR/"
ln -sf "$NVIM_INSTALL_DIR/bin/nvim" "$BIN_DIR/nvim"
rm -rf "$TMP"
ok "Neovim instalado: $("$BIN_DIR/nvim" --version | head -1)"

# Asegurar ~/.local/bin en el PATH (para esta sesión y para futuras)
export PATH="$BIN_DIR:$PATH"
if ! grep -qs 'HOME/.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  ok "Añadido ~/.local/bin al PATH en ~/.bashrc"
fi

# ─── 3. Herramientas ABAP (para sap-nvim) ────────────────────────────────────
header "[3/4] Herramientas ABAP (sapcli + abaplint)"
pipx ensurepath >/dev/null 2>&1 || true

if cmd_exists sapcli; then
  ok "sapcli ya instalado"
else
  # sapcli NO está en PyPI; se instala desde el repo git vía pipx (PEP 668 safe)
  info "Instalando sapcli desde git (pipx)..."
  pipx install git+https://github.com/jfilak/sapcli.git || warn "sapcli falló; reintentá luego: pipx install git+https://github.com/jfilak/sapcli.git"
fi

if cmd_exists abaplint; then
  ok "abaplint ya instalado"
else
  info "Instalando abaplint (npm global)..."
  npm install -g @abaplint/cli || warn "abaplint falló; reintentá luego: npm install -g @abaplint/cli"
fi

# ─── 4. Verificación ─────────────────────────────────────────────────────────
header "[4/4] Verificación"
[ -f "$NVIM_CONFIG_DIR/init.lua" ] && ok "Config presente en $NVIM_CONFIG_DIR" \
  || warn "No hay init.lua en $NVIM_CONFIG_DIR — ¿clonaste este repo ahí?"
"$BIN_DIR/nvim" --version | head -1
cmd_exists sapcli   && ok "sapcli:   $(command -v sapcli)"   || warn "sapcli no en PATH (reabrí la terminal)"
cmd_exists abaplint && ok "abaplint: $(command -v abaplint)" || warn "abaplint no en PATH"

echo
echo -e "${GREEN}${BOLD}✅ Listo.${NC}"
echo "Próximos pasos:"
echo "  1) Reabrí la terminal (o: source ~/.bashrc) para tomar el PATH."
echo "  2) Abrí Neovim NORMAL (no headless):  nvim"
echo "     → lazy.nvim instala todos los plugins con la UI visible. Esperá a que termine."
echo "  3) Dentro de Neovim, instalá los parsers:  :TSInstall abap cds"
echo "  4) Verificá sap-nvim:  :checkhealth sap-nvim"
echo "  5) Conexión SAP:  :SapSetup  →  :SapDoctor   (ver README de sap-nvim; en WSL2 ojo con la VPN)"
