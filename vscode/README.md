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

## Paso 5 — Colocá el `init.lua` (ruta por defecto)

La forma más robusta: poné el `init.lua` en la **carpeta por defecto** de nvim
en Windows. Así vscode-neovim lo carga solo y NO hay que configurar rutas (que
es donde más falla la gente).

```powershell
# 1) Verificá que en Windows NO tengas otra config de nvim (debe estar vacío o dar error)
ls $env:LOCALAPPDATA\nvim

# 2) Copiá el init a la ruta por defecto
mkdir $env:LOCALAPPDATA\nvim -Force
copy "$env:USERPROFILE\nvim-config\vscode\init.lua" "$env:LOCALAPPDATA\nvim\init.lua"
```

> ⚠️ Si el paso 1 te muestra archivos (tendrías LazyVim también en Windows),
> **NO sigas**: usarías una carpeta aparte (`nvim-vscode`) y la setting
> `vscode-neovim.neovimInitVimPaths.win32`. Pero como tu LazyVim vive en WSL, lo
> normal es que `%LOCALAPPDATA%\nvim` esté vacío y este método funcione directo.

El `init.lua` lleva un guard `if not vim.g.vscode then return end`, así que si
algún día abrís nvim normal en Windows, no molesta.

---

## Paso 6 — Fusioná `settings.json`

1. En VSCode: `Ctrl+Shift+P` → escribí **"Preferences: Open User Settings (JSON)"** → Enter.
2. Copiá el contenido de `vscode\settings.json` (de este repo) dentro de tus
   llaves `{ ... }`. Si ya tenés settings, pegá las claves nuevas sin borrar las tuyas.
3. **Ajustá la ruta de nvim.exe** a tu máquina:
   - `"vscode-neovim.neovimExecutablePaths.win32"` → la ruta del **paso 3**
     (ej. `C:\\Program Files\\Neovim\\bin\\nvim.exe`). En JSON las barras van
     **dobles**: `C:\\...`.

   > No hace falta configurar `neovimInitVimPaths`: el init va en la ruta por
   > defecto (paso 5), así que vscode-neovim lo toma solo.

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

## Tus binds (migrados desde VSCodeVim)

`<leader>` = barra espaciadora. Los de leader están en `init.lua`; los de
Ctrl/Tab/Esc y los del explorador en `keybindings.json`.

**Ventanas / editores**
| Bind | Acción |
|------|--------|
| `<C-h/j/k/l>` | Moverse entre ventanas |
| `<C-S-h/j/k/l>` | Mover editor de grupo |
| `<C-A-h/j/k/l>` | Redimensionar |
| `Tab` / `S-Tab` | Editor siguiente / anterior |
| `<leader>sh` / `<leader>sv` | Split derecha / abajo |
| `<leader>m` / `<leader>z` | Maximizar / Zen |
| `<leader>e` | Toggle explorador |
| `-` | Volver atrás |
| `<leader>,` | Todos los editores |

**Buffers / búsqueda / código**
| Bind | Acción |
|------|--------|
| `<leader>bd` / `<leader>bo` | Cerrar editor / cerrar otros |
| `<leader><space>` | Buscar archivos |
| `<leader>sg` | Grep en el proyecto |
| `<leader>gd` `<leader>gr` `<leader>gi` / `gd` `gr` | Definición / referencias / implementación |
| `K` | Hover |
| `<leader>ca` `<leader>cr` `<leader>cs` | Code action / rename / ir a símbolo |
| `<C-n>` | Multicursor (siguiente coincidencia) |

**Edición / git / debug**
| Bind | Acción |
|------|--------|
| `<C-c>` | Escape a normal |
| `<C-b>` (insert) | Borrar hasta fin de palabra |
| `<C-s>` | Guardar |
| `J` / `K` (visual) | Mover línea abajo / arriba |
| `<leader>md` | Borrar todas las marcas |
| `<leader>gg` | Git (panel SCM) |
| `<leader>da/dt/do/db/de/dc` | Debug: iniciar/parar/step/breakpoint/hover/continuar |

**En el explorador:** `r` renombrar · `a` nuevo archivo · `d` borrar · `c/x/p`
copiar/cortar/pegar · `s` abrir al lado · `Enter` abrir/expandir.

---

## Si algo no funciona

### El modo Vim funciona (j/k/dd) pero los `space` binds NO hacen nada
Es el problema más común: **tu `init.lua` no se está cargando**, así que nvim
arranca sin tus keymaps de leader.

1. Confirmá que el archivo existe en la ruta por defecto:
   ```powershell
   ls $env:LOCALAPPDATA\nvim\init.lua
   ```
   Si no está, repetí el **paso 5**.
2. Si dejaste `neovimInitVimPaths.win32` en tu `settings.json` con la ruta mal
   (p. ej. el placeholder `TU_USUARIO` sin reemplazar), **borrá esa línea**: al
   usar la ruta por defecto no hace falta.
3. `Ctrl+Shift+P` → **Developer: Reload Window**.
4. Probá en modo normal: `espacio` + `e` (explorador) o `espacio` + `espacio`
   (buscar archivos).
5. ¿Sigue sin ir? Mirá el error real: `Ctrl+Shift+P` → **Output: Focus on
   Output View** → desplegable de la derecha → **vscode-neovim**. Si hay un
   error rojo de Lua (p. ej. `module 'vscode' not found`), tu extensión es vieja:
   actualizá **VSCode Neovim** desde el panel de extensiones.

### No entra en modo Neovim (escribe letras, cursor fino)
- Revisá la ruta de `nvim.exe` en `settings.json` (paso 6).
- Asegurate de NO tener también `vscodevim.vim` instalada (paso 2). Chocan.

### `Ctrl+hjkl` / `Tab` no responden en modo normal
- En `keybindings.json`, quitá la parte `&& neovim.mode == 'normal'` del `when`
  (el nombre/valor del context key cambia según la versión de la extensión).

### El theme no aparece
- Confirmá que instalaste la extensión Kanagawa (paso 4) y que
  `workbench.colorTheme` dice exactamente `"Kanagawa"`.

---

## Actualizar más adelante

Cuando cambies algo en el repo:

```powershell
git -C "$env:USERPROFILE\nvim-config" pull
copy "$env:USERPROFILE\nvim-config\vscode\init.lua" "$env:LOCALAPPDATA\nvim-vscode\init.lua"
```

Y volvé a copiar `settings.json` / `keybindings.json` si los cambiaste.
