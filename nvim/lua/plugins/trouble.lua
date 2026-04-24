local M = {}

function M.setup(pack)
  local configured = false

  local function ensure_trouble()
    if configured then
      return
    end

    configured = true
    pack.load("trouble.nvim")
    require("trouble").setup({})
  end

  pack.defer({
    { src = pack.gh("folke/trouble.nvim"), name = "trouble.nvim" },
  })

  pack.proxy_command("Trouble", {
    nargs = "*",
    bang = true,
    desc = "Trouble",
  }, function(ctx)
    ensure_trouble()
    vim.cmd(pack.command_line(ctx))
  end)

  vim.keymap.set("n", "<leader>xx", function()
    ensure_trouble()
    vim.cmd("Trouble diagnostics toggle")
  end, { desc = "Diagnostics (workspace, Trouble)", silent = true })
  vim.keymap.set("n", "<leader>xX", function()
    ensure_trouble()
    vim.cmd("Trouble diagnostics toggle filter.buf=0")
  end, { desc = "Diagnostics (buffer, Trouble)", silent = true })
  vim.keymap.set("n", "<leader>xQ", function()
    ensure_trouble()
    vim.cmd("Trouble qflist toggle")
  end, { desc = "Quickfix (Trouble)", silent = true })
end

return M
