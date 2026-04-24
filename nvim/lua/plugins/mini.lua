local M = {}

function M.setup(pack)
  pack.start({
    { src = pack.gh("nvim-mini/mini.icons"), name = "mini.icons" },
    { src = pack.gh("nvim-tree/nvim-web-devicons"), name = "nvim-web-devicons" },
  })

  require("mini.icons").setup()
  require("nvim-web-devicons").setup({})
end

return M
