local M = {}

local function set_diff_overlay_highlights()
  local red = "#ff5f5f"

  vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { fg = red })
  vim.api.nvim_set_hl(0, "MiniDiffOverChange", { fg = red })
  vim.api.nvim_set_hl(0, "MiniDiffOverChangeBuf", { fg = red })
end

function M.setup(pack)
  pack.start({
    { src = pack.gh("nvim-mini/mini.diff"), name = "mini.diff" },
    { src = pack.gh("nvim-mini/mini.icons"), name = "mini.icons" },
    { src = pack.gh("nvim-tree/nvim-web-devicons"), name = "nvim-web-devicons" },
  })

  require("mini.diff").setup()
  set_diff_overlay_highlights()
  require("mini.icons").setup()
  require("nvim-web-devicons").setup({})

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_diff_overlay_highlights,
  })

  vim.keymap.set("n", "<leader>do", function()
    require("mini.diff").toggle_overlay()
  end, { desc = "Toggle diff overlay" })
end

return M
