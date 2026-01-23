return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", },
  config = function()
    require(
      "lualine").setup({
      options = {
        theme = "material",
        icons_enabled = true,
        path = 1,
      }
    })
  end,
}
