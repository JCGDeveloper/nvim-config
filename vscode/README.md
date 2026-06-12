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

## 🆕 Instalación 100% copiar-y-pegar (sin scripts, sin git, cualquier usuario)

Para portátiles de empresa donde no se pueden ejecutar scripts. No usa rutas con
tu usuario: todo se abre desde VSCode o con variables de Windows, así que vale
para **cualquier persona en cualquier máquina**.

### 1. Instalar Neovim (si no lo tenés)

Pegá esto en PowerShell (es un comando directo, NO un script — la ExecutionPolicy
no lo bloquea):

```powershell
winget install Neovim.Neovim
```

Si winget tampoco está permitido: descargá el instalador `.msi` desde
<https://github.com/neovim/neovim/releases> e instalalo con doble clic.

### 2. Instalar las extensiones de VSCode

En VSCode: `Ctrl+Shift+X` → buscá e instalá una a una:

| Extensión | ID |
|---|---|
| VSCode Neovim | `asvetliakov.vscode-neovim` |
| WhichKey | `VSpaceCode.whichkey` |
| Kanagawa (theme) | `qufiwefefwoyn.kanagawa` |
| Material Icon Theme | `pkief.material-icon-theme` |
| GlassIt (transparencia, opcional) | `s-nlf-fh.glassit` |
| Todo Tree | `Gruntfuggly.todo-tree` |
| GitLens | `eamodio.gitlens` |
| ABAP remote filesystem | `murbani.vscode-abap-remote-fs` |

### 3. El `init.lua` de Neovim

1. Abrí el archivo [`vscode/init.lua`](./init.lua) de este repo en GitHub →
   botón **Raw** → `Ctrl+A`, `Ctrl+C`.
2. `Win+R` → escribí `%LOCALAPPDATA%` → Enter. Si no existe una carpeta `nvim`,
   creala.
3. Dentro de `nvim`, creá un archivo llamado `init.lua` (clic derecho → Nuevo →
   Documento de texto, y renombralo a `init.lua` exacto, sin `.txt`) → abrilo
   con el bloc de notas o VSCode → pegá → guardá.

### 4. Los atajos (`keybindings.json`)

1. Copiá todo el contenido de [`vscode/keybindings.json`](./keybindings.json)
   (Raw → `Ctrl+A`, `Ctrl+C`).
2. En VSCode: `Ctrl+Shift+P` → **Preferences: Open Keyboard Shortcuts (JSON)**.
3. Reemplazá TODO el contenido del archivo por lo copiado → guardá.

### 5. La configuración (`settings.json`)

1. Copiá todo el contenido de [`vscode/settings.json`](./settings.json).
2. En VSCode: `Ctrl+Shift+P` → **Preferences: Open User Settings (JSON)**.
3. Si tu settings está vacío (`{}`), reemplazalo entero. Si ya tenés cosas,
   pegá las claves dentro de tus llaves, sin duplicar.

**⚠️ Ajustes que SÍ dependen de tu máquina (cambialos tras pegar):**

- `todo-tree.ripgrep`: la ruta lleva el usuario de Windows del autor. Instalá
  ripgrep (`winget install BurntSushi.ripgrep.MSVC`), buscá tu ruta con:

  ```powershell
  Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" -Recurse -Filter rg.exe | Select-Object -ExpandProperty FullName
  ```

  y poné esa ruta (con `\\` dobles). Si no vas a usar Todo Tree, borrá la línea.
- `vscode-neovim.neovimExecutablePaths.win32`: comprobá que tenés
  `C:\Program Files\Neovim\bin\nvim.exe`; si nvim quedó en otro sitio, ajustala.
- **Tu conexión SAP**: añadí tu propio bloque `abapfs.remote` con la URL,
  usuario y mandante de tu sistema. **Nunca subas ese bloque a git.** La
  contraseña no va en settings: la pide al conectar y se guarda en el
  administrador de credenciales de Windows.

### 6. Reinicio y prueba

Cerrá VSCode **por completo** (todas las ventanas) y reabrilo. En un archivo,
en modo normal, apretá `espacio`: debería salir el popup de which-key con el
menú. `espacio f t` abre la terminal, `Ctrl+hjkl` mueve entre splits.

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
total. El popup de which-key lo da la extensión `VSpaceCode.whichkey` (ver
sección de extensiones), no which-key.nvim — en vscode-neovim los plugins de
UI flotante no se renderizan.

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

## 🎹 Chuleta COMPLETA de atajos

`<leader>` = **barra espaciadora** en modo normal. Al pulsarla sale el popup de
which-key con el menú — no hace falta memorizar nada, pero aquí está todo.

### Menú leader (popup de which-key)

**Directos**
| Atajo | Acción |
|------|--------|
| `espacio espacio` | 🗂️ Buscar archivos (quick open) |
| `espacio ,` | 📑 Lista de todos los editores abiertos |
| `espacio e` | 🌲 Abrir el explorador de archivos (siempre el explorador) |
| `espacio z` | 🧘 Modo Zen |

**`espacio m` — Maximizar/Marcas**
| Atajo | Acción |
|------|--------|
| `espacio m m` | 🔲 Maximizar/restaurar el grupo de editores |
| `espacio m d` | 🧹 Borrar todas las marcas de Neovim |

**`espacio f` — Archivo/Terminal**
| Atajo | Acción |
|------|--------|
| `espacio f t` | 💻 Abrir/cerrar la terminal integrada |
| `espacio f T` | ➕ Nueva terminal |
| `espacio f n` | 🆕 Nuevo archivo sin título |
| `espacio f r` | 🕘 Archivos/carpetas recientes |
| `espacio f s` | 💾 Guardar todo |

**`espacio s` — Buscar/Split**
| Atajo | Acción |
|------|--------|
| `espacio s h` | ➡️ Split a la derecha |
| `espacio s v` | ⬇️ Split abajo |
| `espacio s g` | 🔎 Buscar texto en el proyecto (navegable con teclado) |
| `espacio s G` | 🗂️ Buscar en archivos (panel clásico, regex/reemplazo) |
| `espacio s t` | 📌 Panel de TODOs (Todo Tree) |
| `espacio s r` | ♻️ Reemplazar en archivos |

**`espacio b` — Buffers/Editores**
| Atajo | Acción |
|------|--------|
| `espacio b d` | ❌ Cerrar el editor actual |
| `espacio b o` | 🧹 Cerrar los demás editores **de este grupo** |
| `espacio b g` | 🗑️ Cerrar los **otros grupos** (splits) |
| `espacio b a` | 💥 Cerrar todos los editores |
| `espacio b r` | ♻️ Reabrir el último cerrado |

**`espacio c` — Código**
| Atajo | Acción |
|------|--------|
| `espacio c a` | 💡 Code action (quick fix) |
| `espacio c r` | ✏️ Renombrar símbolo |
| `espacio c s` | 🧭 Ir a símbolo del archivo |
| `espacio c o` | 🗺️ Outline de símbolos |
| `espacio c f` | 🪄 Formatear documento |
| `espacio c i` | 📦 Organizar imports |

**`espacio g` — Git/Goto**
| Atajo | Acción |
|------|--------|
| `espacio g g` | 🌿 Panel Git (SCM) |
| `espacio g d` / `g r` / `g i` | 🎯 Definición / 🔗 Referencias / 🧩 Implementación |
| `espacio g b` / `g B` | 👤 Blame de la línea / 👥 de todo el archivo (GitLens) |
| `espacio g h` / `g L` | 🕘 Historial del archivo / 🕐 de la línea |
| `espacio g l` | 🔍 Detalle del commit de la línea |
| `espacio g c` | ↔️ Comparar con la versión anterior |
| `espacio g o` / `g y` | 🌐 Abrir en remoto / 📋 copiar link |
| `espacio g v` | 🕸️ Grafo de commits |

**`espacio d` — Debug**
| Atajo | Acción |
|------|--------|
| `espacio d a` / `d t` | ▶️ Iniciar / ⏹️ Parar |
| `espacio d o` / `d c` | ⤵️ Step over / ⏯️ Continuar |
| `espacio d b` | 🔴 Toggle breakpoint |
| `espacio d e` | 👁️ Hover de debug |

**`espacio x` — Diagnósticos** · `espacio x x` abre Problems

**`espacio a` — IA**
| Atajo | Acción |
|------|--------|
| `espacio a a` | 💬 Chat de Copilot |
| `espacio a c` | 🤖 Claude Code en el sidebar |
| `espacio a i` | ✨ Chat inline en el editor |
| `espacio a n` / `a h` | 🆕 Chat nuevo / 🕘 historial |
| `espacio a p` / `a x` | 🔁 Toggle / ❌ cerrar panel de chat |
| (visual) `espacio a e/f/g/r` | Explicar / arreglar / generar tests / review de la selección |

**`espacio u` — UI/Toggles**
| Atajo | Acción |
|------|--------|
| `espacio u w` / `u m` | ↩️ Word wrap / 🗺️ minimap |
| `espacio u p` / `u s` | 🧰 Panel inferior / 📊 barra de estado |
| `espacio u t` / `u f` | 🎨 Elegir tema / 🖥️ pantalla completa |

**`espacio p` — Proyecto/VSCode**
| Atajo | Acción |
|------|--------|
| `espacio p p` | 🎛️ Paleta de comandos |
| `espacio p o` | 📂 Abrir carpeta |
| `espacio p s` / `p j` | ⚙️ Settings (UI) / 📝 settings.json |
| `espacio p k` | ⌨️ Atajos de teclado |
| `espacio p e` | 🧩 Extensiones |

**`espacio r` — SAP/ABAP**
| Atajo | Acción |
|------|--------|
| `espacio r a` | ✅ Activar el objeto actual (si hay relacionados inactivos, saca la lista) |
| `espacio r A` | 🚀 Activar varios objetos inactivos |
| `espacio r g` / `r G` / `r b` | 🖥️ GUI embebido / 🪟 nativo / 🌐 navegador |
| `espacio r t` | ⚙️ Ejecutar transacción (SE16N sí; SE11/SE80 solo en GUI nativo) |
| `espacio r x` | 🔤 Elementos de texto |
| `espacio r s` | 🔍 Buscar objeto del sistema |
| `espacio r n` | 🆕 Crear objeto |
| `espacio r T` | 📊 Contenido de una tabla (estilo SE16) |
| `espacio r u` / `r q` / `r d` | 🧪 Unit tests / 💡 quickfix / 📚 documentación ABAP |
| `espacio r v a` | 🧪 ATC checks |
| `espacio r v b` / `v B` | 👤 Blame SAP: mostrar / ocultar |
| `espacio r v g` | 🕸️ Grafo de dependencias |
| `espacio r v c` | ↔️ Comparar objeto con otro sistema |
| `espacio r v t` | 🧫 Crear test include |
| `espacio r C c` / `C d` | 🔌 Conectar / 🔚 desconectar sistema |
| `espacio r C m` / `C p` | 🗂️ Gestor de conexiones / 🔑 borrar contraseña guardada |

### Modo normal (sin leader)

| Atajo | Acción |
|------|--------|
| `g d` / `g r` | Ir a definición / referencias |
| `K` | Hover con info del símbolo. **Segunda vez: foco dentro** (flechas para scroll, `Esc` cierra) |
| `g p d` / `g p D` | Peek de definición / declaración (recuadro sin salir del archivo) |
| `g p i` / `g p y` / `g p r` | Peek de implementación / tipo / referencias |
| `g P` | Cerrar el peek |
| `-` | Volver atrás (navegación) |
| `] t` / `[ t` | Saltar al siguiente / anterior TODO·FIX·HACK·BUG·NOTE·PERF del archivo |
| `J` / `K` (en visual) | Mover las líneas seleccionadas abajo / arriba |

### Ctrl / Alt / Tab (VSCode intercepta antes que Neovim)

| Atajo | Acción |
|------|--------|
| `Ctrl+h/j/k/l` | Moverse entre grupos de editores (splits) |
| `Ctrl+Shift+h/j/k/l` | Mover el editor actual a otro grupo |
| `Ctrl+Alt+h/j/k/l` | Redimensionar el grupo |
| `Tab` / `Shift+Tab` | Pestaña siguiente / anterior del grupo |
| `Alt+h` / `Alt+l` | **Con el foco en el panel**: pestaña anterior/siguiente (Terminal, Problems, Output…) |
| `Ctrl+n` | Multicursor: añadir siguiente coincidencia |
| `Ctrl+s` | Guardar (en cualquier modo) |
| `Ctrl+c` | Escape a modo normal |
| `Ctrl+b` (insert) | Borrar hasta fin de palabra |
| `Alt+Enter` | Aceptar sugerencia inline de IA |
| `Ctrl+G` | (solo archivos ABAP remotos) GUI embebido del objeto, como Eclipse |
| `Ctrl+Q` | Cerrar editor/webview activo; con foco en el chat IA, cierra ese panel |
| `Esc` (foco en sidebar) | Cerrar el sidebar |
| `Ctrl+l` (foco en sidebar/chat) | Volver el foco al editor |

### Dentro del explorador de archivos

| Tecla | Acción |
|------|--------|
| `r` / `d` | Renombrar / borrar |
| `a` | Nuevo archivo |
| `c` / `x` / `p` | Copiar / cortar / pegar |
| `s` / `S` | Abrir al lado / abrir en split abajo |
| `Enter` | Abrir archivo o expandir carpeta |

### Atajos propios de la extensión ABAP (de serie)

| Atajo | Acción |
|------|--------|
| `Alt+Shift+F3` | Activar objeto |
| `Ctrl+Shift+F5` / `F6` / `F7` | GUI nativo / navegador / embebido |
| `Ctrl+Alt+B` | Blame SAP en el margen |

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

### which-key (cómo está montado)

El popup de atajos al apretar espacio lo da la extensión **WhichKey**
(`VSpaceCode.whichkey`). which-key.nvim NO funciona dentro de vscode-neovim
(no renderiza ventanas flotantes de Neovim). El montaje:

- `keybindings.json` intercepta `espacio` en modo normal y abre el popup.
- El menú vive en `settings.json` (`whichkey.bindings`).
- Cada opción reenvía la secuencia a Neovim (`vscode-neovim.send`), así los
  mappings del `init.lua` siguen siendo la única fuente de verdad. Las opciones
  nuevas que no existen en nvim llaman al comando de VSCode directamente.
- Si añadís un atajo nuevo en `init.lua`, añadilo también al menú para que
  salga en el popup.

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
