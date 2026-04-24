local M = {}

local opts = {
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true,
  },
}

function M.setup(pack)
  local configured = false

  local function ensure_autotag()
    if configured then
      return
    end

    configured = true
    pack.load("nvim-ts-autotag")
    require("nvim-ts-autotag").setup(opts)
  end

  pack.defer({
    { src = pack.gh("windwp/nvim-ts-autotag"), name = "nvim-ts-autotag" },
  })

  pack.once_on_events_with_replay({ "BufReadPre", "BufNewFile" }, function(bufnr)
    return vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_get_name(bufnr) ~= ""
  end, function()
    ensure_autotag()
  end)
end

return M
