# nvim-config

Mi configuración de Neovim (LazyVim). Portable: el mismo repo se instala en
cualquier máquina con un solo comando, pensado especialmente para **Debian /
Ubuntu bajo WSL2** (ordenador de empresa).

## Instalación en una máquina nueva (Debian / WSL2)

```sh
# 1) Cloná esta config en su sitio
git clone https://github.com/JCGDeveloper/nvim-config.git ~/.config/nvim

# 2) Corré el instalador (Neovim + dependencias + herramientas ABAP)
bash ~/.config/nvim/install.sh
```

> Si ya tenés una config de Neovim en `~/.config/nvim`, **hacé backup primero**
> (`mv ~/.config/nvim ~/.config/nvim.bak`) antes del `git clone`, porque el
> clone necesita el directorio vacío.

El instalador:

1. Instala dependencias de sistema con apt (`build-essential`, `ripgrep`,
   `fd-find`, `nodejs`, `npm`, `python3`, `pipx`, …). En WSL2 esto solo toca tu
   Debian, nunca Windows.
2. Instala **Neovim estable reciente** desde el tarball oficial en `~/.local`
   (a nivel usuario, sin `sudo`, sin pisar el nvim del sistema).
3. Instala las herramientas ABAP de [sap-nvim](https://github.com/JCGDeveloper/sap-nvim):
   `sapcli` (vía pipx desde git — no está en PyPI) y `abaplint` (npm).
4. **No** corre `Lazy sync` en headless (cuelga con configs grandes). La
   primera vez abrís Neovim normal y lazy instala los plugins con la UI visible.

## Después de instalar

1. Reabrí la terminal (o `source ~/.bashrc`) para tomar `~/.local/bin` en el PATH.
2. `nvim` → esperá a que lazy.nvim termine de instalar todos los plugins.
3. `:TSInstall abap cds` → parsers de tree-sitter para ABAP/CDS.
4. `:checkhealth sap-nvim` → verificá las dependencias ABAP.
5. `:SapSetup` → `:SapDoctor` → conexión SAP (en WSL2, ojo con la red/VPN; ver
   el README de sap-nvim).

## Notas de portabilidad

- `lua/config/nodejs.lua` detecta el Node.js del sistema en cualquier SO (no
  asume rutas de macOS).
- `lua/plugins/sap-nvim.lua` usa la copia de desarrollo local
  (`~/Desktop/sap-nvim`) si existe; en cualquier otra máquina baja el plugin
  desde GitHub.
- `lazy-lock.json` está versionado para reproducir exactamente las mismas
  versiones de plugins.
