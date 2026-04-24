local M = {}

function M.setup(pack)
  pack.defer({
    { src = pack.gh("davidmh/mdx.nvim"), name = "mdx.nvim" },
  })

  pack.once_on_events_with_replay({ "BufReadPre", "BufNewFile" }, function(bufnr)
    return vim.api.nvim_buf_get_name(bufnr):match("%.mdx$") ~= nil
  end, function()
    pack.load("mdx.nvim")
  end, {
    pattern = "*.mdx",
  })
end

return M
