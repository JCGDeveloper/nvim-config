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

-- ── which-key: popup de atajos al apretar leader (como tu nvim) ──────────────
-- Clona which-key.nvim en el packpath nativo (nvim lo carga solo). El primer
-- arranque necesita git + internet; si falla, no rompe nada (pcall).
local wkpath = vim.fn.stdpath("data") .. "/site/pack/vscode/start/which-key.nvim"
if not (vim.uv or vim.loop).fs_stat(wkpath) then
  pcall(vim.fn.system, {
    "git", "clone", "--depth=1",
    "https://github.com/folke/which-key.nvim", wkpath,
  })
  pcall(vim.cmd, "packloadall")
end
pcall(function()
  require("which-key").setup({ preset = "classic" })
end)

-- helper: ejecutar un comando de VSCode (compatible con toda versión)
local function vsc(command)
  return function()
    vim.fn.VSCodeNotify(command)
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
map("n", "<leader>e", vsc("workbench.action.toggleSidebarVisibility"), { desc = "Toggle explorador" })
map("n", "-", vsc("workbench.action.navigateBack"), { desc = "Volver atrás" })
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
map("n", "<leader>gb", vsc("gitlens.toggleLineBlame"), { desc = "Git blame" })
map("n", "<leader>go", vsc("gitlens.openFileOnRemote"), { desc = "Abrir en remoto" })

-- ════════════════════════════════════════════════════════════════════════════
-- DIAGNÓSTICOS (como trouble) + outline (como symbols-outline)
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>xx", vsc("workbench.actions.view.problems"), { desc = "Diagnósticos (Problems)" })
map("n", "<leader>co", vsc("outline.focus"), { desc = "Outline de símbolos" })
map("n", "<leader>st", vsc("workbench.view.extension.todo-tree-container"), { desc = "Lista de TODOs" })

-- ════════════════════════════════════════════════════════════════════════════
-- GUARDAR (tu <C-s>)
-- ════════════════════════════════════════════════════════════════════════════
map({ "n", "i", "v" }, "<C-s>", vsc("workbench.action.files.save"), { desc = "Guardar" })
