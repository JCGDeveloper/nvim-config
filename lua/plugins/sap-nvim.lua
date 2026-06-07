-- sap-nvim — Plugin para desarrollo ABAP en Neovim
-- Modo offline: Tree-sitter + abaplint
-- Modo online: sapcli + MCP (cuando haya conexión SAP)
--
-- Portable: en esta máquina, si existe la copia de desarrollo local
-- (~/Desktop/sap-nvim) se usa esa; en cualquier otra máquina (p. ej. el
-- ordenador de empresa) se baja el plugin desde GitHub.

local dev_dir = vim.fn.expand("~/Desktop/sap-nvim")

local spec = {
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
  },
  -- El módulo es "sap-nvim"; con `opts` lazy resolvería el nombre erróneo
  -- ("sap"), así que llamamos a setup() explícitamente.
  config = function()
    require("sap-nvim").setup()
  end,
}

if vim.fn.isdirectory(dev_dir) == 1 then
  spec.dir = dev_dir -- desarrollo local (este Mac)
else
  spec[1] = "JCGDeveloper/sap-nvim" -- desde GitHub (otras máquinas)
end

return spec
