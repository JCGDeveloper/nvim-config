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

## ⚡ Copiar y pegar (Windows) — lo más rápido

### A) Instalación / actualización automática (recomendado)

Si **ya clonaste** el repo, pegá esto en **PowerShell** y hace todo
(instala nvim si falta, actualiza, copia init.lua y keybindings con backup):

```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\nvim-config\vscode\install.ps1"
```

Si **todavía NO** clonaste el repo, pegá esto primero:

```powershell
git clone https://github.com/JCGDeveloper/nvim-config.git "$env:USERPROFILE\nvim-config"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\nvim-config\vscode\install.ps1"
```

Después, en VSCode: `Ctrl+Shift+P` → **Developer: Reload Window**.

### B) Aplicar los últimos cambios (init + apariencia + which-key)

**1.** Traé los cambios y actualizá el init (PowerShell):

```powershell
git -C "$env:USERPROFILE\nvim-config" pull
Copy-Item "$env:USERPROFILE\nvim-config\vscode\init.lua" "$env:LOCALAPPDATA\nvim\init.lua" -Force
```

**2.** Actualizá tu `settings.json`: `Ctrl+Shift+P` → **Open User Settings (JSON)**
→ copiá/actualizá las claves de `vscode/settings.json` de este repo.

**3.** ⚠️ **CERRÁ VSCode por completo y reabrilo** (no "Reload Window"):
los cambios de barra de título / command center **solo** se aplican con reinicio
total. El primer arranque clona which-key (unos segundos, necesita git+internet).

**4.** Probá: en modo normal apretá `espacio` → debería salir el popup de which-key.

> `install.ps1` **no toca tu `settings.json`** (para no pisar tus preferencias).
> El `settings.json` se fusiona a mano una sola vez (ver Paso 6 más abajo).

### Permisos para ejecutar el `.ps1` (Windows)

La restricción de Windows (ExecutionPolicy) **solo afecta a archivos `.ps1`**, NO
a los comandos que pegás directo. Por eso el **bloque B (comandos directos)
siempre funciona sin permisos** — usalo si tenés dudas.

Si querés correr `install.ps1` y te lo bloquea, probá (de menos a más):

```powershell
# 1) Solo esta ventana de terminal (sin admin)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 2) Permanente para tu usuario (sin admin)
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

> En un ordenador de empresa, si da *"deshabilitado por una directiva"* (GPO),
> IT lo bloqueó y no se puede cambiar → usá el **bloque B (comandos directos)**.

---

## 🛠️ Instalación 100% MANUAL (sin ejecutar scripts)

Si tu empresa bloquea la ejecución de scripts (`.ps1`), seguí esto: todo por la
**interfaz de VSCode** y descargas manuales. (Nota: los comandos sueltos pegados
en la terminal NO son scripts; pero acá los evitamos donde se puede.)

### 1. Extensiones (por la interfaz)
`Ctrl+Shift+X` → buscá cada una por su ID e **Install**:
- `asvetliakov.vscode-neovim`
- `qufiwefefwoyn.kanagawa`
- `s-nlf-fh.glassit`
- `pkief.material-icon-theme`
- `Gruntfuggly.todo-tree`
- `eamodio.gitlens`

### 2. Neovim en Windows
- Si podés: `winget install Neovim.Neovim` (es un comando, no un script).
- Si winget está bloqueado: descargá **`nvim-win64.zip`** de
  https://github.com/neovim/neovim/releases/latest , descomprimilo en una carpeta
  tuya (ej. `C:\Users\TU_USUARIO\nvim`) y anotá la ruta de `bin\nvim.exe`.

### 3. Fuente JetBrainsMono Nerd Font
Descargá `JetBrainsMono.zip` de https://www.nerdfonts.com/font-downloads →
seleccioná los `.ttf` → click derecho → **Instalar**.

### 4. El `init.lua` (por la interfaz, sin comandos)
1. Abrí el archivo `vscode/init.lua` de este repo en VSCode y **copiá todo** (`Ctrl+A`, `Ctrl+C`).
2. `Ctrl+Shift+P` → **Crear archivo nuevo** (o `Ctrl+N`), pegá el contenido y
   guardalo (`Ctrl+S`) en esta ruta exacta:
   `C:\Users\TU_USUARIO\AppData\Local\nvim\init.lua`
   (en el diálogo de guardar, pegá `%LOCALAPPDATA%\nvim` en la barra de ruta y
   poné nombre `init.lua`).

### 5. `settings.json` (por la interfaz)
`Ctrl+Shift+P` → **Open User Settings (JSON)** → copiá/actualizá las claves de
`vscode/settings.json` de este repo. Ajustá la ruta de `nvim.exe` (paso 2).

### 6. `keybindings.json` (por la interfaz)
`Ctrl+Shift+P` → **Open Keyboard Shortcuts (JSON)** → pegá el contenido de
`vscode/keybindings.json`.

### 7. Reiniciá
Cerrá VSCode **por completo** y reabrilo (para la barra de título; el resto toma
con Reload Window).

> Para **actualizar** más adelante sin scripts: abrí `vscode/init.lua` del repo
> (botón Sync/Pull de VSCode en el repo, o re-descargá), copiá y pegá de nuevo en
> `%LOCALAPPDATA%\nvim\init.lua`. Lo mismo con settings/keybindings.

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
- **GlassIt-VSC** (transparencia) — `s-nlf-fh.glassit`
- La extensión **ABAP** de tu empresa (o `ABAP remote filesystem`,
  `murbani.vscode-abap-remote-fs`) para conectarte a SAP.

### Fuente: JetBrainsMono Nerd Font

Para ver los iconos y las ligaduras como en tu nvim, instalá la **Nerd Font**:

1. Descargá `JetBrainsMono.zip` de https://www.nerdfonts.com/font-downloads
2. Descomprimí, seleccioná todos los `.ttf`, click derecho → **Instalar**.
3. (O por terminal, si tenés Scoop: `scoop install JetBrainsMono-NF`.)

El `settings.json` ya apunta a `'JetBrainsMono Nerd Font'`.

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

## Personalización (apariencia)

Todo se ajusta en tu `settings.json`:

| Quiero… | Clave | Valor |
|---------|-------|-------|
| Más/menos transparencia | `glassit.alpha` | `255` = opaco, `230` = más transparente. O al vuelo: `Ctrl+Alt+Z` / `Ctrl+Alt+C` |
| Tamaño de letra | `editor.fontSize` | `15` |
| Altura de línea | `editor.lineHeight` | `1.5` |
| Cursor sin animación | `editor.cursorSmoothCaretAnimation` | `"off"` |
| Más/menos aire | `editor.padding.top` / `.bottom` | `18` |
| **Ver el icono de VSCode / barra de título** | `window.customTitleBarVisibility` | `"auto"` (la vuelve a mostrar) |
| Ver la barra de iconos izquierda | `workbench.activityBar.location` | `"default"` |
| Ver pestañas | `workbench.editor.showTabs` | `"multiple"` |
| Ver el menú (File/Edit) | `window.menuBarVisibility` | `"classic"` |
| Ocultar la statusline (lualine) | `workbench.statusBar.visible` | `false` |

> **Barra de título oculta:** con `window.customTitleBarVisibility: "never"` no
> hay botones de minimizar/cerrar (lo más nvim). Para cerrar la ventana: `Alt+F4`.
> Si te molesta, ponelo en `"auto"` y vuelve.

> **GlassIt** hace transparente **toda la ventana** (se ve lo que haya detrás),
> no es blur selectivo como tu nvim — pero es lo más cercano y estable.

### which-key (el único que NO metí, y por qué)

Tu nvim muestra un popup de atajos al apretar espacio (which-key). En VSCode
eso lo daría la extensión *VSpaceCode WhichKey*, **pero choca con vscode-neovim**:
el `espacio` en modo normal lo maneja Neovim (es tu leader), así que un
which-key de VSCode tendría que robarle esa tecla y **te rompería todos tus
`space` binds**. Por eso lo dejé afuera: no vale romper lo que ya funciona.

> Alternativa fiel (avanzada, pendiente): instalar `which-key.nvim` dentro del
> `init.lua` dedicado de vscode-neovim. Requiere bootstrapear un gestor de
> plugins en ese init. Si lo querés, lo montamos aparte.

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
