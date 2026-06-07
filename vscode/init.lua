-- ============================================================================
-- init.lua DEDICADO para vscode-neovim (NO es tu config de LazyVim).
--
-- vscode-neovim corre Neovim REAL para la edición. Aquí van:
--   · opciones de edición
--   · tus keymaps de modo normal/visual, incluidos los de LEADER (space ...),
--     que delegan en comandos de VSCode con require("vscode").action().
--
-- Los atajos de Ctrl/Tab/Esc y los del explorador van en keybindings.json,
-- porque esas teclas las intercepta VSCode antes que Neovim.
--
-- Instalación: copiá este archivo a una carpeta SEPARADA de tu LazyVim
-- (ej. %LOCALAPPDATA%\nvim-vscode\init.lua) y apuntá vscode-neovim a ella.
-- ============================================================================

if not vim.g.vscode then
  return
end

local vscode = require("vscode")
local map = vim.keymap.set

-- ── Leader = espacio (como tu nvim) ─────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Opciones de edición ─────────────────────────────────────────────────────
local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.timeoutlen = 1000
opt.scrolloff = 8

-- helper: ejecutar un comando de VSCode
local function vsc(command)
  return function()
    vscode.action(command)
  end
end
-- helper: ejecutar varios comandos de VSCode en orden
local function vscm(commands)
  return function()
    vscode.action("runCommands", { args = { commands = commands } })
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
-- Splits (tu space s h / space s v)
map("n", "<leader>sh", vsc("workbench.action.splitEditorRight"), { desc = "Split derecha" })
map("n", "<leader>sv", vsc("workbench.action.splitEditorDown"), { desc = "Split abajo" })

-- Maximizar / Zen (tu space m / space z)
map("n", "<leader>m", vsc("workbench.action.toggleMaximizeEditorGroup"), { desc = "Maximizar grupo" })
map("n", "<leader>z", vsc("workbench.action.toggleZenMode"), { desc = "Modo Zen" })

-- Explorador (tu space e) y volver atrás (tu '-')
map("n", "<leader>e", vsc("workbench.action.toggleSidebarVisibility"), { desc = "Toggle explorador" })
map("n", "-", vsc("workbench.action.navigateBack"), { desc = "Volver atrás" })

-- Listar editores (tu space ,)
map("n", "<leader>,", vsc("workbench.action.showAllEditors"), { desc = "Todos los editores" })

-- ════════════════════════════════════════════════════════════════════════════
-- BUFFERS / BÚSQUEDA
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>bd", vsc("workbench.action.closeActiveEditor"), { desc = "Cerrar editor" })
map("n", "<leader>bo", vsc("workbench.action.closeOtherEditors"), { desc = "Cerrar otros" })
map("n", "<leader><space>", vsc("workbench.action.quickOpen"), { desc = "Buscar archivos" })
map("n", "<leader>sg", vsc("workbench.action.findInFiles"), { desc = "Grep proyecto" })
map("v", "<leader>sg", vsc("workbench.action.findInFiles"), { desc = "Grep selección" })

-- ════════════════════════════════════════════════════════════════════════════
-- CÓDIGO / LSP (tu space c *, space g *, K)
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>ca", vsc("editor.action.codeAction"), { desc = "Code action" })
map("n", "<leader>cr", vsc("editor.action.rename"), { desc = "Renombrar" })
map("n", "<leader>cs", vsc("workbench.action.gotoSymbol"), { desc = "Ir a símbolo" })
map("n", "<leader>gd", vsc("editor.action.revealDefinition"), { desc = "Definición" })
map("n", "<leader>gr", vsc("editor.action.goToReferences"), { desc = "Referencias" })
map("n", "<leader>gi", vsc("editor.action.goToImplementation"), { desc = "Implementación" })
map("n", "K", vsc("editor.action.showHover"), { desc = "Hover" })
-- Atajos estándar de nvim también disponibles
map("n", "gd", vsc("editor.action.revealDefinition"), { desc = "Definición" })
map("n", "gr", vsc("editor.action.goToReferences"), { desc = "Referencias" })

-- ════════════════════════════════════════════════════════════════════════════
-- GIT (tu space g g)
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>gg", vscm({ "workbench.view.scm", "workbench.scm.focus" }), { desc = "Git (SCM)" })

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
-- GUARDAR (tu <C-s>)
-- ════════════════════════════════════════════════════════════════════════════
map({ "n", "i", "v" }, "<C-s>", vsc("workbench.action.files.save"), { desc = "Guardar" })
