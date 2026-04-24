-- History
vim.opt.history = 500

-- Auto read when a file is changed from the outside
vim.opt.autoread = true

----------------------------------------------------------------
-- Neovim UI / Behavior
----------------------------------------------------------------

vim.opt.wildignore:append({ "*.o", "*~", "*.pyc" })
if vim.fn.has("win16") == 1 or vim.fn.has("win32") == 1 then
  vim.opt.wildignore:append({ ".git\\*", ".hg\\*", ".svn\\*" })
else
  vim.opt.wildignore:append({ "*/.git/*", "*/.hg/*", "*/.svn/*", "*/.DS_Store" })
end

vim.opt.so = 7
vim.opt.wildmenu = true
vim.opt.ruler = true
vim.opt.cmdheight = 1
vim.opt.hidden = true
vim.opt.backspace = { "eol", "start", "indent" }
vim.opt.whichwrap:append("<,>,h,l")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.magic = true
vim.opt.lazyredraw = true
vim.opt.showmatch = true
vim.opt.mat = 2
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.tm = 500
vim.opt.foldcolumn = "1"
vim.opt.conceallevel = 2

----------------------------------------------------------------
-- Colors and Fonts
----------------------------------------------------------------

vim.cmd([[syntax enable]])
vim.opt.termguicolors = true
vim.cmd([[colorscheme material]])
vim.opt.guifont = "HasklugNerdFontMono:h18"
vim.opt.background = "dark"
vim.opt.encoding = "utf-8"
vim.opt.ffs = { "unix", "dos", "mac" }

if vim.fn.has("gui_running") == 1 then
  vim.cmd([[
    set guioptions-=T
    set guioptions-=e
    set guitablabel=%M\ %t
  ]])
end

----------------------------------------------------------------
-- Files, Backups, Undo
----------------------------------------------------------------

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

----------------------------------------------------------------
-- Text, Tab, Indent
----------------------------------------------------------------

vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.linebreak = true
vim.opt.textwidth = 500
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.number = true
vim.opt.signcolumn = "yes"

----------------------------------------------------------------
-- Visual Mode searching
----------------------------------------------------------------

local function visualSelection(direction)
  local saved_reg = vim.fn.getreg('"')
  vim.cmd([[normal! "vy]])
  local pattern = vim.fn.escape(vim.fn.getreg('"'), [[\/.*'$^~[]\]])
  pattern = pattern:gsub("\n$", "")
  if direction == "/" then
    vim.cmd("/" .. pattern)
  elseif direction == "?" then
    vim.cmd("?" .. pattern)
  end
  vim.fn.setreg("/", pattern)
  vim.fn.setreg('"', saved_reg)
end

vim.keymap.set("v", "*", function() visualSelection("/") end, { silent = true })
vim.keymap.set("v", "#", function() visualSelection("?") end, { silent = true })

----------------------------------------------------------------
-- Moving around, tabs, buffers
----------------------------------------------------------------

vim.opt.splitbelow = true
vim.opt.splitright = true
