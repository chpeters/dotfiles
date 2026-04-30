
-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- copy to clipboard
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "Highlight selection on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200, visual = true })
  end,
})

-- Fast saving
vim.keymap.set("n", "<leader>w", ":w!<CR>", { silent = true })

-- Clear highlight
vim.keymap.set("n", "<leader><CR>", ":noh<CR>", { silent = true })

-- Close current buffer
vim.api.nvim_create_user_command("Bclose", function()
  local currentBuf = vim.fn.bufnr("%")
  local altBuf = vim.fn.bufnr("#")

  if vim.fn.buflisted(altBuf) == 1 then
    vim.cmd("buffer #")
  else
    vim.cmd("bnext")
  end

  if vim.fn.bufnr("%") == currentBuf then
    vim.cmd("new")
  end

  if vim.fn.buflisted(currentBuf) == 1 then
    vim.cmd("bdelete! " .. currentBuf)
  end
end, {})

vim.keymap.set("n", "<leader>bd", ":Bclose<CR>:tabclose<CR>gT", { silent = true })
vim.keymap.set("n", "<leader>ba", ":bufdo bd<CR>", { silent = true })
vim.keymap.set("n", "<leader>l", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>h", ":bprevious<CR>", { silent = true })

-- Tabs
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { silent = true })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { silent = true })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { silent = true })
vim.keymap.set("n", "<leader>tm", ":tabmove ", { silent = false })
vim.keymap.set("n", "<leader>t<leader>", ":tabnext<CR>", { silent = true })

vim.g.lasttab = 1
vim.api.nvim_create_autocmd("TabLeave", {
  callback = function()
    vim.g.lasttab = vim.fn.tabpagenr()
  end
})
vim.keymap.set("n", "<leader>tl", function()
  vim.cmd("exe 'tabn ' .. g:lasttab")
end, { silent = true })

vim.cmd([[
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry
]])

-- Return to last edit position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
    end
  end
})

----------------------------------------------------------------
-- Editing Mappings
----------------------------------------------------------------

-- Remap 0 to first non-blank char
vim.keymap.set("n", "0", "^")

-- Move line up/down
vim.keymap.set("n", "<M-j>", "mz:m+<cr>`z", { silent = true })
vim.keymap.set("n", "<M-k>", "mz:m-2<cr>`z", { silent = true })
vim.keymap.set("v", "<M-j>", ":m'>+<cr>`<my`>mzgv`yo`z", { silent = true })
vim.keymap.set("v", "<M-k>", ":m'<-2<cr>`>my`<mzgv`yo`z", { silent = true })

if vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1 then
  vim.keymap.set("n", "<D-j>", "<M-j>")
  vim.keymap.set("n", "<D-k>", "<M-k>")
  vim.keymap.set("v", "<D-j>", "<M-j>")
  vim.keymap.set("v", "<D-k>", "<M-k>")
end

-- Auto-resize splits on VimResized
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("wincmd =")
  end
})


