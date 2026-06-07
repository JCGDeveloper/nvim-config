-- ============================================================================
-- init.lua DEDICADO para vscode-neovim (NO es tu config de LazyVim).
--
-- vscode-neovim corre Neovim REAL para la edición (modos, motions, text
-- objects, macros, registros = idénticos a tu nvim). La UI, los archivos, la
-- búsqueda y el LSP los provee VSCode, así que aquí NO cargamos plugins de UI.
--
-- Instalación: copiá este archivo a una carpeta de config SEPARADA y apuntá
-- vscode-neovim a ella (ver vscode/README.md). NO lo pongas como tu init de
-- LazyVim: cargar LazyVim entero rompe vscode-neovim.
-- ============================================================================

if not vim.g.vscode then
  -- Si por error esto se carga fuera de VSCode, no hacemos nada.
  return
end

local vscode = require("vscode") -- API de vscode-neovim
local map = vim.keymap.set

-- ── Opciones de edición (las visuales las maneja VSCode) ────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.timeoutlen = 1000
opt.scrolloff = 8

-- helper: ejecutar un comando de VSCode desde un keymap
local function vsc(command)
  return function()
    vscode.action(command)
  end
end

-- ── Edición pura (idéntico a tu nvim) ───────────────────────────────────────
map("i", "<C-b>", "<C-o>de", { desc = "Borrar hasta fin de palabra" })
map({ "i", "n", "v" }, "<C-c>", [[<C-\><C-n>]], { desc = "Escape" })

-- Deshabilitar mover líneas (A-j/A-k) y unir en visual (J/K) — como en tu config
for _, k in ipairs({ "<A-j>", "<A-k>" }) do
  map({ "i", "n", "x" }, k, "<Nop>", { silent = true })
end
map("x", "J", "<Nop>", { silent = true })
map("x", "K", "<Nop>", { silent = true })

-- Borrar todas las marcas (tu <leader>md)
map("n", "<leader>md", function()
  vim.cmd("delmarks!")
  vim.cmd("delmarks A-Z0-9")
end, { desc = "Borrar todas las marcas" })

-- ── Acciones delegadas a VSCode ─────────────────────────────────────────────
-- Guardar (tu <C-s> con SaveFile)
map({ "n", "i", "v" }, "<C-s>", vsc("workbench.action.files.save"), { desc = "Guardar" })

-- Explorador (tu '-' de Oil → explorador de VSCode)
map("n", "-", vsc("workbench.view.explorer"), { desc = "Explorador" })

-- Cerrar los demás editores (tu <leader>bq)
map("n", "<leader>bq", vsc("workbench.action.closeOtherEditors"), { desc = "Cerrar otros" })

-- Buscar archivos / grep (equivalentes a los pickers de LazyVim)
map("n", "<leader><space>", vsc("workbench.action.quickOpen"), { desc = "Buscar archivos" })
map("n", "<leader>ff", vsc("workbench.action.quickOpen"), { desc = "Buscar archivos" })
map("n", "<leader>fg", vsc("workbench.action.findInFiles"), { desc = "Grep" })
map("n", "<leader>sg", vsc("workbench.action.findInFiles"), { desc = "Grep proyecto" })
map("v", "<leader>sg", vsc("workbench.action.findInFiles"), { desc = "Grep selección" })
map("n", "<leader>e", vsc("workbench.view.explorer"), { desc = "Explorador" })

-- LSP por VSCode (gd/gr/K/rename/code action — como LazyVim)
map("n", "gd", vsc("editor.action.revealDefinition"), { desc = "Ir a definición" })
map("n", "gD", vsc("editor.action.revealDeclaration"), { desc = "Ir a declaración" })
map("n", "gr", vsc("editor.action.goToReferences"), { desc = "Referencias" })
map("n", "gI", vsc("editor.action.goToImplementation"), { desc = "Implementación" })
map("n", "K", vsc("editor.action.showHover"), { desc = "Hover" })
map("n", "<leader>ca", vsc("editor.action.quickFix"), { desc = "Code action" })
map("n", "<leader>cr", vsc("editor.action.rename"), { desc = "Renombrar" })
map("n", "<leader>cf", vsc("editor.action.formatDocument"), { desc = "Formatear" })
map("n", "]d", vsc("editor.action.marker.next"), { desc = "Siguiente diagnóstico" })
map("n", "[d", vsc("editor.action.marker.prev"), { desc = "Diagnóstico anterior" })

-- NOTA: la navegación entre editores (tu C-hjkl de tmux) va en
-- keybindings.json, porque VSCode intercepta Ctrl+hjkl antes que Neovim.
