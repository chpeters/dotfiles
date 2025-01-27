-- History
vim.opt.history = 500

-- Auto read when a file is changed from the outside
vim.opt.autoread = true

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fast saving
vim.keymap.set("n", "<leader>w", ":w!<CR>", { silent = true })

----------------------------------------------------------------
-- Plugins
----------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim plugin manager...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "kaicataldo/material.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.material_theme_style = "default"
    end
  },
  {
    "w0rp/ale",
    config = function()
      vim.g.ale_linter_aliases = { typescriptreact = "typescript" }
      vim.g.ale_javascript_prettier_use_local_config = 1
      vim.g.ale_completion_enabled = 0
      vim.g.ale_fix_on_save = 1
      vim.g.ale_fixers = {
        javascript = { "prettier", "eslint" },
        typescript = { "prettier", "eslint" },
        ["typescript.tsx"] = { "prettier", "eslint" },
        dart = { "dartfmt" },
      }
      vim.g.ale_linters = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        ["typescript.tsx"] = { "eslint" },
        clojure = { "clj-kondo", "joker" },
        dart = { "dartanalyzer" },
      }
    end
  },
  
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      vim.opt.updatetime = 300
      vim.opt.signcolumn = "yes"

      local function checkBackspace()
        local col = vim.fn.col(".") - 1
        return col == 0 or string.match(vim.fn.getline("."):sub(col, col), "%s") ~= nil
      end

      -- Tab navigation for Coc popups
      vim.api.nvim_set_keymap(
        "i",
        "<TAB>",
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.MCheckBackspace() ? "\\<Tab>" : coc#refresh()',
        { noremap = true, silent = true, expr = true }
      )
      vim.api.nvim_set_keymap(
        "i",
        "<S-TAB>",
        'coc#pum#visible() ? coc#pum#prev(1) : "\\<C-h>"',
        { noremap = true, silent = true, expr = true }
      )

      -- <CR> to accept completion
      vim.api.nvim_set_keymap(
        "i",
        "<CR>",
        'coc#pum#visible() ? coc#pum#confirm() : "\\<C-g>u\\<CR>\\<c-r>=coc#on_enter()\\<CR>"',
        { noremap = true, silent = true, expr = true }
      )

      -- <c-space> to trigger completion
      if vim.fn.has("nvim") == 1 then
        vim.api.nvim_set_keymap("i", "<c-space>", "coc#refresh()", { noremap = true, silent = true, expr = true })
      end

      -- Code navigation
      vim.api.nvim_set_keymap("n", "gd", "<Plug>(coc-definition)", { silent = true })
      vim.api.nvim_set_keymap("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      vim.api.nvim_set_keymap("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      vim.api.nvim_set_keymap("n", "gr", "<Plug>(coc-references)", { silent = true })

      -- Show docs on K
      vim.api.nvim_set_keymap("n", "K", ":lua ShowDocumentation()<CR>", { noremap = true, silent = true })
      _G.ShowDocumentation = function()
        if vim.fn["CocAction"]("hasProvider", "hover") == 1 then
          vim.fn.CocActionAsync("doHover")
        else
          vim.api.nvim_feedkeys("K", "in", false)
        end
      end

      -- Highlight symbol on cursor hold
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.fn.CocActionAsync("highlight")
        end
      })

      -- Scroll float windows
      if vim.fn.has("nvim-0.4.0") == 1 or vim.fn.has("patch-8.2.0750") == 1 then
        local opts_expr = { silent = true, nowait = true, expr = true }
        vim.api.nvim_set_keymap("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "\\<C-f>"', opts_expr)
        vim.api.nvim_set_keymap("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "\\<C-b>"', opts_expr)
        vim.api.nvim_set_keymap("i", "<C-f>", 'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(1)\\<cr>" : "\\<Right>"', opts_expr)
        vim.api.nvim_set_keymap("i", "<C-b>", 'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(0)\\<cr>" : "\\<Left>"', opts_expr)
        vim.api.nvim_set_keymap("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "\\<C-f>"', opts_expr)
        vim.api.nvim_set_keymap("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "\\<C-b>"', opts_expr)
      end

      -- Snippet expansion for <Tab>
      vim.api.nvim_set_keymap(
        "i",
        "<TAB>",
        [[pumvisible() ? coc#_select_confirm() : coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" : v:lua.MCheckBackspace() ? "\<TAB>" : coc#refresh()]],
        { noremap = true, silent = true, expr = true }
      )

      vim.g.coc_snippet_next = "<tab>"
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "ruby", "vimdoc" },
        auto_install = true,
        highlight = { enable = true, },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
    end,
    build = ":TSUpdate",
  }, 

  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    opts = { files = { previewer = "builtin" } },
    keys = {
      { "<leader><space>", "<cmd>FzfLua git_files<CR>", desc = "Git files" },
      { "<leader>/",       "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
    },
  },

  {
    "scrooloose/nerdtree",
    config = function()
      vim.g.NERDTreeQuitOnOpen = 1
      vim.g.NERDTreeShowHidden = 1
      vim.keymap.set("n", "<leader>o", ":NERDTreeToggle<CR>", { silent = true })
    end
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({  numhl = true})
    end
  },

  {
    "davidmh/mdx.nvim",
    config = true,
    dependencies = {"nvim-treesitter/nvim-treesitter"}
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "mdx", "Avante", "codecompanion" },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          path = 1, -- show relative file path
        }
      })
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      }
    }
  },

  { "Xuyuanp/nerdtree-git-plugin" },
  { "pangloss/vim-javascript" },
  { "amadeus/vim-jsx" },
  { "leafgarland/typescript-vim" },
  { "peitalin/vim-jsx-typescript" },
  { "tommcdo/vim-exchange" },
  { "tpope/vim-commentary" },
  { "tpope/vim-surround" },
  { "christoomey/vim-tmux-navigator" },
  {
    "alvan/vim-closetag",
    config = function()
      vim.g.closetag_regions = {
        ["typescript.tsx"] = "jsxRegion,tsxRegion",
        ["javascript.jsx"] = "jsxRegion",
      }
      vim.g.closetag_filenames = "*.html,*.xhtml,*.phtml,*.js,*.tsx"
    end
  },
  { "jparise/vim-graphql" },
  { "guns/vim-sexp", ft = { "clojure" } },
  { "liquidz/vim-iced", ft = { "clojure" } },
  { "liquidz/vim-iced-coc-source", ft = { "clojure" } },
  { "pantharshit00/vim-prisma" },
  { "jparise/vim-graphql" },
  { "github/copilot.vim" },
}

require("lazy").setup({
  spec = plugins,
  ui = { border = "rounded" },
})

-- fzf commands for muscle memory:
vim.api.nvim_create_user_command("RG", function()
  require("fzf-lua").live_grep()
end, {})

vim.api.nvim_create_user_command("GFiles", function()
  require("fzf-lua").git_files()
end, {})

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

----------------------------------------------------------------
-- Colors and Fonts
----------------------------------------------------------------

vim.cmd([[syntax enable]])
vim.opt.termguicolors = true
vim.cmd([[colorscheme material]])
vim.opt.guifont = "Hasklig:h18"
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

vim.keymap.set("n", "<leader>te", ":tabedit <C-R>=expand(\"%:p:h\")<CR>/", { silent = false })
vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { silent = true })

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

-- Delete trailing whitespace on save
local function cleanExtraSpaces()
  local save_cursor = vim.api.nvim_win_get_cursor(0)
  local old_query = vim.fn.getreg("/")
  vim.cmd([[%s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, save_cursor)
  vim.fn.setreg("/", old_query)
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.txt", "*.js", "*.py", "*.wiki", "*.sh", "*.coffee" },
  callback = cleanExtraSpaces
})

----------------------------------------------------------------
-- Spell Checking
----------------------------------------------------------------

vim.keymap.set("n", "<leader>ss", ":setlocal spell!<CR>")
vim.keymap.set("n", "<leader>sn", "]s")
vim.keymap.set("n", "<leader>sp", "[s")
vim.keymap.set("n", "<leader>sa", "zg")
vim.keymap.set("n", "<leader>s?", "z=")

----------------------------------------------------------------
-- Misc
----------------------------------------------------------------

vim.keymap.set("n", "<leader>m", [[mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm]])
vim.keymap.set("n", "<leader>q", ":e ~/buffer<CR>")
vim.keymap.set("n", "<leader>x", ":e ~/buffer.md<CR>")
vim.keymap.set("n", "<leader>pp", ":setlocal paste!<CR>")

----------------------------------------------------------------
-- Helper Functions
----------------------------------------------------------------

_G.HasPaste = function()
  if vim.opt.paste:get() then
    return "PASTE MODE  "
  end
  return ""
end

-- Auto-resize splits on VimResized
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("wincmd =")
  end
})

