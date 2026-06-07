# VSCode con motor Neovim — Guía de instalación paso a paso

Esta guía deja VSCode editando **con Neovim real** (extensión `vscode-neovim`),
con UI minimalista (sin barras ni clics) y theme parecido a tu nvim. Pensada
para el **ordenador de empresa con Windows**, donde la extensión ABAP conecta a
SAP de forma nativa (sin el problema de red de WSL2).

> **Importante — dónde corre VSCode:** seguí esta guía con **VSCode en Windows
> (nativo)**, no en modo Remote-WSL. Así la conexión SAP usa la red de Windows
> directamente. Por eso Neovim también se instala en Windows (no en WSL).

> **Qué vas a obtener:** la **edición** es idéntica a tu nvim (modos, motions,
> text objects, macros, registros, tus keymaps). Los plugins **visuales** de
> nvim (smear-cursor, precognition, screenkey, veil…) NO se trasladan: la UI la
> pone VSCode.

---

## Requisitos previos

- Windows 10/11 con VSCode instalado.
- Permisos para instalar extensiones y `winget` (o Scoop).

---

## Paso 1 — Conseguir estos archivos

Abrí **PowerShell** y cloná el repo en tu carpeta de usuario:

```powershell
git clone https://github.com/JCGDeveloper/nvim-config.git "$env:USERPROFILE\nvim-config"
```

> Es un repo **privado**: te va a pedir login de GitHub o un token. Si no podés
> clonar, descargá el repo como ZIP desde GitHub y descomprimilo; los archivos
> que necesitás están en la carpeta `vscode\`.

A partir de acá, los archivos están en `%USERPROFILE%\nvim-config\vscode\`.

---

## Paso 2 — Desinstalá la extensión "Vim" ⚠️

`vscode-neovim` y `Vim` (`vscodevim.vim`) **chocan**. No pueden convivir.

1. En VSCode: `Ctrl+Shift+X` (Extensiones).
2. Buscá **Vim**, la de `vscodevim`.
3. **Desinstalar** (o al menos Deshabilitar).

---

## Paso 3 — Instalá Neovim en Windows

En PowerShell:

```powershell
winget install Neovim.Neovim
```

Verificá la ruta del ejecutable (la vas a necesitar en el paso 6):

```powershell
where.exe nvim
```

Normalmente es `C:\Program Files\Neovim\bin\nvim.exe`.

---

## Paso 4 — Instalá las extensiones de VSCode

`Ctrl+Shift+X` e instalá (podés buscar por el ID):

- **VSCode Neovim** — `asvetliakov.vscode-neovim`
- **Kanagawa** (theme) — `qufiwefefwoyn.kanagawa`
- La extensión **ABAP** de tu empresa (o `ABAP remote filesystem`,
  `murbani.vscode-abap-remote-fs`) para conectarte a SAP.

---

## Paso 5 — Colocá el `init.lua` dedicado

vscode-neovim necesita un `init.lua` **propio y separado** de tu LazyVim
(cargar LazyVim entero lo rompe). Creá la carpeta y copiá el archivo:

```powershell
mkdir "$env:LOCALAPPDATA\nvim-vscode" -Force
copy "$env:USERPROFILE\nvim-config\vscode\init.lua" "$env:LOCALAPPDATA\nvim-vscode\init.lua"
```

La ruta final queda en `C:\Users\TU_USUARIO\AppData\Local\nvim-vscode\init.lua`.
Para saber tu usuario exacto: `echo $env:USERNAME`.

---

## Paso 6 — Fusioná `settings.json`

1. En VSCode: `Ctrl+Shift+P` → escribí **"Preferences: Open User Settings (JSON)"** → Enter.
2. Copiá el contenido de `vscode\settings.json` (de este repo) dentro de tus
   llaves `{ ... }`. Si ya tenés settings, pegá las claves nuevas sin borrar las tuyas.
3. **Ajustá estas dos rutas** a tu máquina:
   - `"vscode-neovim.neovimExecutablePaths.win32"` → la ruta del **paso 3**
     (ej. `C:\\Program Files\\Neovim\\bin\\nvim.exe`).
   - `"vscode-neovim.neovimInitVimPaths.win32"` → la ruta del **paso 5**
     (ej. `C:\\Users\\TU_USUARIO\\AppData\\Local\\nvim-vscode\\init.lua`).

   > En JSON las barras van **dobles**: `C:\\Users\\...`.

4. Guardá (`Ctrl+S`).

---

## Paso 7 — Fusioná `keybindings.json`

1. `Ctrl+Shift+P` → **"Preferences: Open Keyboard Shortcuts (JSON)"** → Enter.
2. Copiá el contenido de `vscode\keybindings.json` dentro de los corchetes `[ ... ]`.
   Si ya tenías binds, agregá estos a la lista (separados por coma).
3. Guardá.

---

## Paso 8 — Reiniciá VSCode y probá

Cerrá y abrí VSCode. Abrí cualquier archivo. Deberías ver:

- Estás en **modo NORMAL** de Neovim (probá `i` para insertar, `Esc` para salir).
- Sin barras laterales, sin pestañas, sin minimapa.
- Números de línea relativos y theme Kanagawa.

---

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
| `gd` `gr` `K` `<leader>cr` `<leader>ca` `<leader>cf` | Definición / referencias / hover / rename / code action / formatear |
| `]d` `[d` | Diagnóstico siguiente / anterior |

(`<leader>` es la barra espaciadora.)

---

## Si algo no funciona

- **No entra en modo Neovim** → revisá la ruta de `nvim.exe` (paso 6) y que NO
  tengas instalada también `vscodevim.vim` (paso 2).
- **Arranca con error de Lua** → `neovimInitVimPaths` debe apuntar al `init.lua`
  de `nvim-vscode`, NO al de LazyVim.
- **`Ctrl+hjkl` no cambia de editor** → en `keybindings.json`, quitá la parte
  `&& neovim.mode != 'insert'` del `when` (el nombre del context key cambia
  según la versión de la extensión).
- **El theme no aparece** → confirmá que instalaste la extensión Kanagawa
  (paso 4) y que `workbench.colorTheme` dice exactamente `"Kanagawa"`.

---

## Actualizar más adelante

Cuando cambies algo en el repo:

```powershell
git -C "$env:USERPROFILE\nvim-config" pull
copy "$env:USERPROFILE\nvim-config\vscode\init.lua" "$env:LOCALAPPDATA\nvim-vscode\init.lua"
```

Y volvé a copiar `settings.json` / `keybindings.json` si los cambiaste.
