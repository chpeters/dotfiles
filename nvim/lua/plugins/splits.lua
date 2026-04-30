local M = {}

function M.setup(pack)
  pack.start({
    { src = pack.gh("mrjones2014/smart-splits.nvim"), name = "smart-splits.nvim" },
  })

  local smart_splits = require("smart-splits")

  smart_splits.setup({
    multiplexer_integration = "zellij",
  })

  vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Move to left split" })
  vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Move to lower split" })
  vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Move to upper split" })
  vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Move to right split" })
  vim.keymap.set("n", "<C-\\>", smart_splits.move_cursor_previous, { desc = "Move to previous split" })

  vim.keymap.set("n", "<A-h>", smart_splits.resize_left, { desc = "Resize split left" })
  vim.keymap.set("n", "<A-j>", smart_splits.resize_down, { desc = "Resize split down" })
  vim.keymap.set("n", "<A-k>", smart_splits.resize_up, { desc = "Resize split up" })
  vim.keymap.set("n", "<A-l>", smart_splits.resize_right, { desc = "Resize split right" })
end

return M
