local M = {}

function M.setup(pack)
  pack.start({
    { src = pack.gh("christoomey/vim-tmux-navigator"), name = "vim-tmux-navigator" },
  })
end

return M
