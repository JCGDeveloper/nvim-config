return {
  "jonroosevelt/gemini-cli.nvim",
  cmd = "Gemini", -- Solo carga cuando ejecutes :Gemini
  keys = {
    { "og", desc = "Toggle Gemini CLI", mode = { "n" } },
  },
  config = function()
    require("gemini").setup({
      split_direction = "horizontal",
    })
  end,
}
