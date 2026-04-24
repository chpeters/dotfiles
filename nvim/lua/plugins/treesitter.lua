local parsers = {
  "bash",
  "css",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "ruby",
  "sql",
  "typescript",
  "tsx",
  "vimdoc",
}

local M = {}

local highlight_filetypes = {
  "bash",
  "css",
  "ecma",
  "help",
  "html",
  "javascript",
  "javascriptreact",
  "js",
  "json",
  "jsx",
  "lua",
  "markdown",
  "mysql",
  "python",
  "py",
  "ruby",
  "sh",
  "sql",
  "ts",
  "tsx",
  "typescript",
  "typescript.tsx",
  "typescriptreact",
  "vimdoc",
  "zsh",
}

local function has_tree_sitter_cli()
  return vim.fn.executable("tree-sitter") == 1
end

local function ensure_treesitter_runtime()
  local pack_data = vim.pack.get({ "nvim-treesitter" })[1]
  local plugin_path = pack_data and pack_data.path
    or vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt", "nvim-treesitter")
  local runtime_dir = vim.fs.joinpath(plugin_path, "runtime")

  if vim.uv.fs_stat(runtime_dir) and not vim.list_contains(vim.opt.runtimepath:get(), runtime_dir) then
    vim.opt.runtimepath:append(runtime_dir)
  end
end

local function install_parsers()
  if not has_tree_sitter_cli() then
    vim.notify("nvim-treesitter requires tree-sitter-cli. Install it with: brew install tree-sitter-cli", vim.log.levels.ERROR)
    return
  end

  require("nvim-treesitter").install(parsers)
end

local function sync_parsers()
  if not has_tree_sitter_cli() then
    vim.notify("nvim-treesitter requires tree-sitter-cli. Install it with: brew install tree-sitter-cli", vim.log.levels.ERROR)
    return
  end

  require("nvim-treesitter").install(parsers):wait(300000)
end

local function set_textobject_keymaps()
  local select = require("nvim-treesitter-textobjects.select")
  local move = require("nvim-treesitter-textobjects.move")

  vim.keymap.set({ "x", "o" }, "af", function()
    select.select_textobject("@function.outer", "textobjects")
  end, { desc = "Select outer function" })
  vim.keymap.set({ "x", "o" }, "if", function()
    select.select_textobject("@function.inner", "textobjects")
  end, { desc = "Select inner function" })
  vim.keymap.set({ "x", "o" }, "ac", function()
    select.select_textobject("@class.outer", "textobjects")
  end, { desc = "Select outer class" })
  vim.keymap.set({ "x", "o" }, "ic", function()
    select.select_textobject("@class.inner", "textobjects")
  end, { desc = "Select inner class" })

  vim.keymap.set({ "n", "x", "o" }, "]m", function()
    move.goto_next_start("@function.outer", "textobjects")
  end, { desc = "Next function start" })
  vim.keymap.set({ "n", "x", "o" }, "]]", function()
    move.goto_next_start("@class.outer", "textobjects")
  end, { desc = "Next class start" })
  vim.keymap.set({ "n", "x", "o" }, "]M", function()
    move.goto_next_end("@function.outer", "textobjects")
  end, { desc = "Next function end" })
  vim.keymap.set({ "n", "x", "o" }, "][", function()
    move.goto_next_end("@class.outer", "textobjects")
  end, { desc = "Next class end" })
  vim.keymap.set({ "n", "x", "o" }, "[m", function()
    move.goto_previous_start("@function.outer", "textobjects")
  end, { desc = "Previous function start" })
  vim.keymap.set({ "n", "x", "o" }, "[[", function()
    move.goto_previous_start("@class.outer", "textobjects")
  end, { desc = "Previous class start" })
  vim.keymap.set({ "n", "x", "o" }, "[M", function()
    move.goto_previous_end("@function.outer", "textobjects")
  end, { desc = "Previous function end" })
  vim.keymap.set({ "n", "x", "o" }, "[]", function()
    move.goto_previous_end("@class.outer", "textobjects")
  end, { desc = "Previous class end" })
end

local function setup_treesitter()
  local treesitter = require("nvim-treesitter")

  ensure_treesitter_runtime()
  treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })
  vim.treesitter.language.register("bash", { "bash", "sh", "zsh" })
  vim.treesitter.language.register("javascript", { "ecma", "javascriptreact", "js", "jsx" })
  vim.treesitter.language.register("sql", { "mysql" })
  vim.treesitter.language.register("tsx", { "tsx", "typescript.tsx", "typescriptreact" })
  vim.treesitter.language.register("typescript", { "ts" })
  vim.treesitter.language.register("vimdoc", { "help", "vimdoc" })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
    pattern = highlight_filetypes,
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
    desc = "Enable Treesitter highlighting for supported filetypes",
  })

  vim.api.nvim_create_user_command("TSInstallConfigured", install_parsers, {
    desc = "Install the Treesitter parsers configured in dotfiles",
  })

  require("nvim-treesitter-textobjects").setup({
    select = {
      lookahead = true,
    },
    move = {
      set_jumps = true,
    },
  })

  set_textobject_keymaps()
end

function M.sync_parsers()
  sync_parsers()
end

function M.setup(pack)
  local setup_complete = false

  vim.g.no_plugin_maps = true

  pack.on_change("nvim-treesitter", function(event)
    local kind = event.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end

    local function run_sync()
      if not event.data.active then
        pack.load("nvim-treesitter")
      end

      sync_parsers()
    end

    if setup_complete then
      run_sync()
    else
      vim.schedule(run_sync)
    end
  end)

  pack.start({
    { src = pack.gh("nvim-treesitter/nvim-treesitter"), name = "nvim-treesitter", version = "main" },
    {
      src = pack.gh("nvim-treesitter/nvim-treesitter-textobjects"),
      name = "nvim-treesitter-textobjects",
      version = "main",
    },
  })

  setup_treesitter()
  setup_complete = true
end

return M
