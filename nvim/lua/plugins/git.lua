local M = {}

local opts = {
  signcolumn = true,
  numhl = true,
}

function M.setup(pack)
  local configured = false

  local function ensure_gitsigns()
    if configured then
      return
    end

    configured = true
    pack.load("gitsigns.nvim")
    require("gitsigns").setup(opts)
  end

  pack.defer({
    {
      src = pack.gh("lewis6991/gitsigns.nvim"),
      name = "gitsigns.nvim",
      data = { event = { "BufReadPost", "BufNewFile" }, replay = function(bufnr) return vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_get_name(bufnr) ~= "" end, config = ensure_gitsigns },
    },
  })
end

return M
