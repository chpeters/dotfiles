local M = {}

function M.setup(pack)
  pack.start({
    { src = pack.gh("nvim-lualine/lualine.nvim"), name = "lualine.nvim" },
  })

  require("lualine").setup({
    options = {
      theme = "material",
      icons_enabled = true,
      path = 1,
    },
  })
end

return M
