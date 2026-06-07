# VSCode con motor Neovim (estilo terminal)

Config para que VSCode edite **con Neovim real** (extensión `vscode-neovim`),
con UI minimalista (sin barras ni clics) y theme parecido a tu nvim. Pensado
para el **ordenador de empresa (Windows)**, donde la conexión SAP de la
extensión ABAP funciona nativa, sin el lío de red de WSL2.

> La **edición** será idéntica a tu nvim (modos, motions, text objects, macros,
> registros, tus keymaps). Lo que NO se traslada son los plugins **visuales** de
> nvim (smear-cursor, precognition, screenkey, veil…): eso lo maneja la UI de
> VSCode.

## Pasos (Windows)

### 1. ⚠️ Desinstalá la extensión "Vim" (vscodevim.vim)
`vscode-neovim` y `Vim` **chocan**. Tené solo una. Quitá `vscodevim.vim`.

### 2. Instalá Neovim en Windows
```powershell
winget install Neovim.Neovim
```
Anotá la ruta del ejecutable (por defecto `C:\Program Files\Neovim\bin\nvim.exe`).

### 3. Instalá las extensiones de VSCode
- **VSCode Neovim** — `asvetliakov.vscode-neovim`
- **Kanagawa** (theme) — `qufiwefefwoyn.kanagawa`
- La extensión **ABAP** que use tu empresa (o `ABAP remote filesystem`,
  `murbani.vscode-abap-remote-fs`) para conectar a SAP.

### 4. Colocá el init.lua dedicado
Copiá `vscode/init.lua` (de este repo) a una carpeta de config **separada** de
tu LazyVim, por ejemplo:
```
%LOCALAPPDATA%\nvim-vscode\init.lua
```
(equivale a `C:\Users\TU_USUARIO\AppData\Local\nvim-vscode\init.lua`).

> No lo pongas en `%LOCALAPPDATA%\nvim\` si ahí tenés LazyVim: cargar LazyVim
> entero rompe vscode-neovim. Por eso usamos una carpeta aparte.

### 5. Fusioná settings y keybindings
- `vscode/settings.json` → tu *User Settings (JSON)*.
  **Ajustá** `vscode-neovim.neovimExecutablePaths.win32` (ruta del paso 2) y
  `vscode-neovim.neovimInitVimPaths.win32` (ruta del paso 4, con tu usuario).
- `vscode/keybindings.json` → tu *Keyboard Shortcuts (JSON)*.

### 6. Reiniciá VSCode
Abrí un archivo: deberías estar en modo NORMAL de Neovim, sin barras, con
números relativos y el theme Kanagawa.

## Tus binds (replicados)

| Bind | Acción |
|------|--------|
| `<C-c>` | Escape a normal |
| `<C-b>` (insert) | Borrar hasta fin de palabra |
| `<C-s>` | Guardar |
| `-` | Explorador |
| `<C-h/j/k/l>` | Moverse entre editores (tu tmux-nav) |
| `<leader>bq` | Cerrar los demás editores |
| `<leader><space>` / `<leader>ff` | Buscar archivos |
| `<leader>sg` / `<leader>fg` | Grep en el proyecto |
| `<leader>md` | Borrar todas las marcas |
| `gd` `gr` `K` `<leader>cr` `<leader>ca` | Definición / referencias / hover / rename / code action |

## Si algo no responde

- **`Ctrl+hjkl` no cambia de editor** → en `keybindings.json`, quitá la parte
  `&& neovim.mode != 'insert'` del `when` (el nombre del context key varía
  según versión de la extensión).
- **Arranca con error de Lua** → revisá que `neovimInitVimPaths` apunte al
  `init.lua` de ESTA carpeta, no al de LazyVim.
- **No entra en modo Neovim** → verificá la ruta de `nvim.exe` y que NO tengas
  también `vscodevim.vim` instalada.
