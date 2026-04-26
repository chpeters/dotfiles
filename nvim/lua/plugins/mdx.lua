local M = {}

function M.setup(pack)
  pack.defer({
    {
      src = pack.gh("davidmh/mdx.nvim"),
      name = "mdx.nvim",
      data = { event = { "BufReadPre", "BufNewFile" }, pattern = "*.mdx", replay = function(bufnr) return vim.api.nvim_buf_get_name(bufnr):match("%.mdx$") ~= nil end },
    },
  })
end

return M
