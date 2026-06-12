-- ============================================================================
-- init.lua DEDICADO para vscode-neovim (NO es tu config de LazyVim).
--
-- vscode-neovim corre Neovim REAL para la edición. Aquí van las opciones y tus
-- keymaps de modo normal/visual, incluidos los de LEADER (space ...), que
-- delegan en comandos de VSCode.
--
-- IMPORTANTE: usamos vim.fn.VSCodeNotify (API clásica, presente en TODAS las
-- versiones de la extensión). NO usamos require("vscode") porque en versiones
-- antiguas ese módulo no existe y haría fallar TODO el init (ningún atajo se
-- registraría).
--
-- Los atajos de Ctrl/Tab/Esc y los del explorador van en keybindings.json.
-- ============================================================================

if not vim.g.vscode then
  return
end

local map = vim.keymap.set

-- ── Leader = espacio (como tu nvim) ─────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Opciones de edición ─────────────────────────────────────────────────────
local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.timeoutlen = 300 -- popup de which-key rápido (como nvim)
opt.scrolloff = 8

-- ── which-key ────────────────────────────────────────────────────────────────
-- which-key.nvim NO funciona aquí: vscode-neovim no renderiza ventanas
-- flotantes de Neovim, así que el popup nunca se dibuja aunque el plugin
-- cargue. El popup lo da la extensión "WhichKey" (VSpaceCode.whichkey):
-- el menú vive en settings.json ("whichkey.bindings") y se dispara con
-- espacio desde keybindings.json. Cada opción reenvía las teclas a Neovim
-- con vscode-neovim.send, así los mappings de este archivo siguen mandando.

-- helper: ejecutar un comando de VSCode (compatible con toda versión)
local function vsc(command)
  return function()
    vim.fn.VSCodeNotify(command)
  end
end

-- helper SÍNCRONO: para comandos que abren un picker/quick input (quickOpen,
-- quickTextSearch...). VSCodeNotify es async: el picker tarda en robar el foco
-- y lo que tecleás justo después cae en el editor en modo normal (una 'i' te
-- mete en inserción, y "espacio + letra" dispara mappings de leader, p.ej.
-- espacio+m des-maximiza). VSCodeCall espera a que VSCode procese el comando.
local function vscall(command)
  return function()
    vim.fn.VSCodeCall(command)
  end
end

-- ════════════════════════════════════════════════════════════════════════════
-- EDICIÓN PURA (idéntico a tu nvim)
-- ════════════════════════════════════════════════════════════════════════════
map("i", "<C-b>", "<C-o>de", { desc = "Borrar hasta fin de palabra" })
map({ "i", "n", "v" }, "<C-c>", [[<C-\><C-n>]], { desc = "Escape" })

-- Deshabilitar A-j/A-k (como en tu nvim)
for _, k in ipairs({ "<A-j>", "<A-k>" }) do
  map({ "i", "n", "x" }, k, "<Nop>", { silent = true })
end

-- Borrar todas las marcas (<leader>md)
map("n", "<leader>md", function()
  vim.cmd("delmarks!")
  vim.cmd("delmarks A-Z0-9")
end, { desc = "Borrar todas las marcas" })

-- Mover líneas en visual (tu Shift+J / Shift+K de VisualLine)
map("x", "J", vsc("editor.action.moveLinesDownAction"), { desc = "Mover línea abajo" })
map("x", "K", vsc("editor.action.moveLinesUpAction"), { desc = "Mover línea arriba" })

-- ════════════════════════════════════════════════════════════════════════════
-- VENTANAS / EDITORES
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>sh", vsc("workbench.action.splitEditorRight"), { desc = "Split derecha" })
map("n", "<leader>sv", vsc("workbench.action.splitEditorDown"), { desc = "Split abajo" })
map("n", "<leader>m", vsc("workbench.action.toggleMaximizeEditorGroup"), { desc = "Maximizar grupo" })
map("n", "<leader>z", vsc("workbench.action.toggleZenMode"), { desc = "Modo Zen" })
-- Siempre abre el EXPLORADOR (no "lo último que hubiera en el sidebar").
-- Para cerrarlo: Esc con el foco en el sidebar (ver keybindings.json).
map("n", "<leader>e", vsc("workbench.view.explorer"), { desc = "Explorador de archivos" })
-- "-" = volver al ARCHIVO anterior de un salto (como el alternate file C-^ de
-- vim). Pulsado otra vez, vuelve al que estabas. Para el "atrás" fino paso a
-- paso (jumplist), usá Ctrl+o / Ctrl+i, que vscode-neovim ya mapea solo.
map("n", "-", vsc("workbench.action.openPreviousRecentlyUsedEditorInGroup"), { desc = "Archivo anterior (alternate)" })
map("n", "<leader>,", vscall("workbench.action.showAllEditors"), { desc = "Todos los editores" })

-- ════════════════════════════════════════════════════════════════════════════
-- TODOs: saltar al siguiente/anterior comentario TODO/FIX/... (como todo-comments)
-- ════════════════════════════════════════════════════════════════════════════
local todo_pattern = [[\<\(TODO\|FIX\|FIXME\|HACK\|BUG\|NOTE\|PERF\)\>]]
map("n", "]t", function()
  vim.fn.search(todo_pattern, "w")
end, { desc = "Siguiente TODO" })
map("n", "[t", function()
  vim.fn.search(todo_pattern, "bw")
end, { desc = "TODO anterior" })

-- ════════════════════════════════════════════════════════════════════════════
-- TERMINAL (tu space f t de LazyVim)
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>ft", vsc("workbench.action.terminal.toggleTerminal"), { desc = "Toggle terminal" })

-- ════════════════════════════════════════════════════════════════════════════
-- BUFFERS / BÚSQUEDA
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>bd", vsc("workbench.action.closeActiveEditor"), { desc = "Cerrar editor" })
map("n", "<leader>bo", vsc("workbench.action.closeOtherEditors"), { desc = "Cerrar otros" })
map("n", "<leader><space>", vscall("workbench.action.quickOpen"), { desc = "Buscar archivos" })
-- Quick Search: buscador navegable con teclado (flechas + Enter), tipo telescope
-- OJO: vscall (síncrono), no vsc — ver comentario del helper
map("n", "<leader>sg", vscall("workbench.action.quickTextSearch"), { desc = "Buscar texto (teclado)" })
map("v", "<leader>sg", vscall("workbench.action.quickTextSearch"), { desc = "Buscar texto (teclado)" })
-- Panel clásico de Find in Files (por si querés reemplazar/regex avanzado)
map("n", "<leader>sG", vsc("workbench.action.findInFiles"), { desc = "Buscar en archivos (panel)" })

-- ════════════════════════════════════════════════════════════════════════════
-- CÓDIGO / LSP (tu space c *, space g *, K)
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>ca", vsc("editor.action.codeAction"), { desc = "Code action" })
map("n", "<leader>cr", vsc("editor.action.rename"), { desc = "Renombrar" })
map("n", "<leader>cs", vscall("workbench.action.gotoSymbol"), { desc = "Ir a símbolo" })
map("n", "<leader>gd", vsc("editor.action.revealDefinition"), { desc = "Definición" })
map("n", "<leader>gr", vsc("editor.action.goToReferences"), { desc = "Referencias" })
map("n", "<leader>gi", vsc("editor.action.goToImplementation"), { desc = "Implementación" })
map("n", "K", vsc("editor.action.showHover"), { desc = "Hover" })
map("n", "gd", vsc("editor.action.revealDefinition"), { desc = "Definición" })
map("n", "gr", vsc("editor.action.goToReferences"), { desc = "Referencias" })

-- ════════════════════════════════════════════════════════════════════════════
-- GIT (tu space g g) — comando único, sin runCommands
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>gg", vsc("workbench.view.scm"), { desc = "Git (SCM)" })

-- ════════════════════════════════════════════════════════════════════════════
-- DEBUG (tu space d *)
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>da", vsc("workbench.action.debug.selectandstart"), { desc = "Debug: iniciar" })
map("n", "<leader>dt", vsc("workbench.action.debug.stop"), { desc = "Debug: parar" })
map("n", "<leader>do", vsc("workbench.action.debug.stepOver"), { desc = "Debug: step over" })
map("n", "<leader>db", vsc("editor.debug.action.toggleBreakpoint"), { desc = "Debug: breakpoint" })
map("n", "<leader>de", vsc("editor.debug.action.showDebugHover"), { desc = "Debug: hover" })
map("n", "<leader>dc", vsc("workbench.action.debug.continue"), { desc = "Debug: continuar" })

-- ════════════════════════════════════════════════════════════════════════════
-- PEEK / goto-preview (como tu goto-preview.nvim: gp*)
-- ════════════════════════════════════════════════════════════════════════════
map("n", "gpd", vsc("editor.action.peekDefinition"), { desc = "Peek definición" })
map("n", "gpD", vsc("editor.action.peekDeclaration"), { desc = "Peek declaración" })
map("n", "gpi", vsc("editor.action.peekImplementation"), { desc = "Peek implementación" })
map("n", "gpy", vsc("editor.action.peekTypeDefinition"), { desc = "Peek tipo" })
map("n", "gpr", vsc("editor.action.referenceSearch.trigger"), { desc = "Peek referencias" })
map("n", "gP", vsc("closeReferenceSearch"), { desc = "Cerrar peek" })

-- ════════════════════════════════════════════════════════════════════════════
-- GIT (como tu git.nvim: blame + browse) — requiere GitLens
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>gb", vsc("gitlens.toggleLineBlame"), { desc = "Blame de la línea" })
map("n", "<leader>gB", vsc("gitlens.toggleFileBlame"), { desc = "Blame de todo el archivo" })
map("n", "<leader>gh", vsc("gitlens.showQuickFileHistory"), { desc = "Historial del archivo" })
map("n", "<leader>gL", vsc("gitlens.showQuickLineHistory"), { desc = "Historial de la línea" })
map("n", "<leader>gl", vsc("gitlens.showQuickCommitFileDetails"), { desc = "Detalle del commit de la línea" })
map("n", "<leader>gc", vsc("gitlens.diffWithPrevious"), { desc = "Comparar con versión anterior" })
map("n", "<leader>go", vsc("gitlens.openFileOnRemote"), { desc = "Abrir en remoto" })
map("n", "<leader>gy", vsc("gitlens.copyRemoteFileUrlToClipboard"), { desc = "Copiar link remoto" })
map("n", "<leader>gv", vsc("gitlens.showGraph"), { desc = "Grafo de commits (GitLens)" })

-- ════════════════════════════════════════════════════════════════════════════
-- DIAGNÓSTICOS (como trouble) + outline (como symbols-outline)
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>xx", vsc("workbench.actions.view.problems"), { desc = "Diagnósticos (Problems)" })
map("n", "<leader>co", vsc("outline.focus"), { desc = "Outline de símbolos" })
map("n", "<leader>st", vsc("workbench.view.extension.todo-tree-container"), { desc = "Lista de TODOs" })

-- ════════════════════════════════════════════════════════════════════════════
-- IA: Copilot Chat + Claude Code (space a *)
--
-- Copilot Chat vive en el sidebar secundario (derecha). Claude Code tiene
-- además sus atajos nativos: Ctrl+Esc (foco editor <-> Claude) y Alt+K
-- (insertar @-mention de la selección).
-- ════════════════════════════════════════════════════════════════════════════
-- Copilot Chat
map({ "n", "v" }, "<leader>aa", vsc("workbench.action.chat.open"), { desc = "IA: abrir chat (Copilot)" })
map("n", "<leader>ax", vsc("workbench.action.closeAuxiliaryBar"), { desc = "IA: cerrar panel de chat" })
map("n", "<leader>ap", vsc("workbench.action.toggleAuxiliaryBar"), { desc = "IA: toggle panel de chat" })
map("n", "<leader>an", vsc("workbench.action.chat.newChat"), { desc = "IA: chat nuevo" })
map("n", "<leader>ah", vsc("workbench.action.chat.history"), { desc = "IA: historial de chats" })
map({ "n", "v" }, "<leader>ai", vsc("inlineChat.start"), { desc = "IA: chat inline en el editor" })
-- Acciones de Copilot sobre la selección (modo visual)
map("v", "<leader>ae", vsc("github.copilot.chat.explain"), { desc = "IA: explicar selección" })
map("v", "<leader>af", vsc("github.copilot.chat.fix"), { desc = "IA: arreglar selección" })
map("v", "<leader>ag", vsc("github.copilot.chat.generateTests"), { desc = "IA: generar tests" })
map("v", "<leader>ar", vsc("github.copilot.chat.review"), { desc = "IA: review de la selección" })
-- Claude Code (extensión anthropic.claude-code)
map("n", "<leader>ac", vsc("claude-vscode.sidebar.open"), { desc = "IA: Claude Code en sidebar" })

-- ════════════════════════════════════════════════════════════════════════════
-- SAP / ABAP (space r *) — requiere extensión ABAP remote filesystem (abapfs)
--
-- Solo tienen efecto en archivos del sistema remoto (scheme adt). Además,
-- Ctrl+G (como en Eclipse) abre el GUI embebido — está en keybindings.json.
-- Defaults de la extensión: Ctrl+Shift+F5 GUI nativo, F7 embebido, F6 browser.
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>rg", vsc("abapfs.runInEmbeddedGui"), { desc = "SAP: GUI embebido (pestaña)" })
map("n", "<leader>rG", vsc("abapfs.runInGui"), { desc = "SAP: GUI nativo (ventana)" })
map("n", "<leader>rb", vsc("abapfs.execute"), { desc = "SAP: GUI en navegador" })
map("n", "<leader>rt", vscall("abapfs.runTransaction"), { desc = "SAP: ejecutar transacción" })
map("n", "<leader>rx", vsc("abapfs.manageTextElements"), { desc = "SAP: elementos de texto" })
map("n", "<leader>ra", vsc("abapfs.activate"), { desc = "SAP: activar objeto" })

-- ════════════════════════════════════════════════════════════════════════════
-- GUARDAR (tu <C-s>)
-- ════════════════════════════════════════════════════════════════════════════
map({ "n", "i", "v" }, "<C-s>", vsc("workbench.action.files.save"), { desc = "Guardar" })
