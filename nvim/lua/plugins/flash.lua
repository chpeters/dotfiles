local M = {}

function M.setup(pack)
  local configured = false

  local function ensure_flash()
    if configured then
      return
    end

    configured = true
    pack.load("flash.nvim")
    require("flash").setup({})

    vim.keymap.set({ "n", "x", "o" }, "s", function()
      require("flash").jump()
    end, { desc = "Flash", silent = true })
    vim.keymap.set({ "n", "x", "o" }, "S", function()
      require("flash").treesitter()
    end, { desc = "Flash Treesitter", silent = true })
    vim.keymap.set("o", "r", function()
      require("flash").remote()
    end, { desc = "Remote Flash", silent = true })
    vim.keymap.set({ "o", "x" }, "R", function()
      require("flash").treesitter_search()
    end, { desc = "Treesitter Search", silent = true })
    vim.keymap.set("c", "<c-s>", function()
      require("flash").toggle()
    end, { desc = "Toggle Flash Search", silent = true })
  end

  pack.defer({
    { src = pack.gh("folke/flash.nvim"), name = "flash.nvim" },
  })

  pack.once_on_user("PackDeferred", function()
    ensure_flash()
  end)
end

return M
