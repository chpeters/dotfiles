local M = {}

local function file_preview(ctx)
  local path = Snacks.picker.util.path(ctx.item)
  if path and vim.fn.fnamemodify(path, ":e"):lower() == "pdf" then
    ctx.preview:reset()
    ctx.preview:set_title(ctx.item.title or vim.fn.fnamemodify(path, ":t"))
    ctx.preview:notify("PDF preview disabled", "warn")
    return false
  end

  return Snacks.picker.preview.file(ctx)
end

local opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
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
      }
    },
    explorer = { enabled = true, git_status_open = true, auto_close = true },
    icons = {
      files = {
        enabled = true, -- show file icons
        dir = "󰉋 ",
        dir_open = "󰝰 ",
        file = "󰈔 "
      },
      keymaps = {
        nowait = "󰓅 "
      },
      tree = {
        vertical = "│ ",
        middle   = "├╴",
        last     = "└╴",
      },
      undo = {
        saved = " ",
      },
      ui = {
        live       = "󰐰 ",
        hidden     = "h",
        ignored    = "i",
        follow     = "f",
        selected   = "● ",
        unselected = "○ ",
        -- selected = " ",
      },
      git = {
        enabled   = true, -- show git icons
        commit    = "󰜘 ", -- used by git log
        staged    = "●", -- staged changes. always overrides the type icons
        added     = "",
        deleted   = "",
        ignored   = " ",
        modified  = "○",
        renamed   = "",
        unmerged  = " ",
        untracked = "?",
      },
      diagnostics = {
        Error = " ",
        Warn  = " ",
        Hint  = " ",
        Info  = " ",
      },
      lsp = {
        unavailable = "",
        enabled = " ",
        disabled = " ",
        attached = "󰖩 "
      },
      kinds = {
        Array         = " ",
        Boolean       = "󰨙 ",
        Class         = " ",
        Color         = " ",
        Control       = " ",
        Collapsed     = " ",
        Constant      = "󰏿 ",
        Constructor   = " ",
        Copilot       = " ",
        Enum          = " ",
        EnumMember    = " ",
        Event         = " ",
        Field         = " ",
        File          = " ",
        Folder        = " ",
        Function      = "󰊕 ",
        Interface     = " ",
        Key           = " ",
        Keyword       = " ",
        Method        = "󰊕 ",
        Module        = " ",
        Namespace     = "󰦮 ",
        Null          = " ",
        Number        = "󰎠 ",
        Object        = " ",
        Operator      = " ",
        Package       = " ",
        Property      = " ",
        Reference     = " ",
        Snippet       = "󱄽 ",
        String        = " ",
        Struct        = "󰆼 ",
        Text          = " ",
        TypeParameter = " ",
        Unit          = " ",
        Unknown       = " ",
        Value         = " ",
        Variable      = "󰀫 ",
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      sources = {
        files = {
          preview = file_preview,
        },
        git_files = {
          preview = file_preview,
        },
        recent = {
          preview = file_preview,
        },
        explorer = {
          hidden = true,
          auto_close = true,
          win = {
            list = {
              keys = {
                ["s"] = "edit_vsplit",
              },
            },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = {
      enabled = false,
    },
    statuscolumn = {
      enabled = false,
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" },
      git = {
        patterns = { "GitSign", "MiniDiffSign" },
      }
    },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      }
    }
}

local function plugin_picker(snacks, pack)
  snacks.picker.files({
    cwd = vim.fn.stdpath("config"),
    dirs = pack.plugin_config_dirs(),
  })
end

local function set_keymaps(snacks, pack)
  local keymaps = {
    { "<leader><space>", function() snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>o", function() snacks.explorer() end, desc = "File Explorer" },
    { "<leader>fb", function() snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() snacks.picker.recent() end, desc = "Recent" },
    { "<leader>gb", function() snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() snacks.picker.git_log_file() end, desc = "Git Log File" },
    { "<leader>gi", function() snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>gI", function() snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    { "<leader>gp", function() snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    { "<leader>gP", function() snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    { "<leader>sb", function() snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    { '<leader>s"', function() snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sc", function() snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() plugin_picker(snacks, pack) end, desc = "Plugin Config Files" },
    { "<leader>sq", function() snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "gd", function() snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "gai", function() snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    { "gao", function() snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    { "<leader>ss", function() snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { "<leader>z", function() snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z", function() snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.", function() snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S", function() snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>bd", function() snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gg", function() snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-/>", function() snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>", function() snacks.terminal() end, desc = "which_key_ignore" },
    { "]]", function() snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  }

  for _, keymap in ipairs(keymaps) do
    local lhs = keymap[1]
    local rhs = keymap[2]
    local mode = keymap.mode or "n"
    local map_opts = {
      desc = keymap.desc,
      nowait = keymap.nowait,
      silent = true,
    }

    vim.keymap.set(mode, lhs, rhs, map_opts)
  end
end

local function setup_deferred(snacks)
  _G.dd = function(...)
    snacks.debug.inspect(...)
  end

  _G.bt = function()
    snacks.debug.backtrace()
  end

  if vim.fn.has("nvim-0.11") == 1 then
    vim._print = function(_, ...)
      dd(...)
    end
  else
    vim.print = _G.dd
  end

  snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  snacks.toggle.diagnostics():map("<leader>ud")
  snacks.toggle.line_number():map("<leader>ul")
  snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
  snacks.toggle.treesitter():map("<leader>uT")
  snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
  snacks.toggle.inlay_hints():map("<leader>uh")
  snacks.toggle.indent():map("<leader>ug")
  snacks.toggle.dim():map("<leader>uD")
end

function M.setup(pack)
  pack.start({
    { src = pack.gh("folke/snacks.nvim"), name = "snacks.nvim" },
  })

  local snacks = require("snacks")
  snacks.setup(opts)
  vim.o.statuscolumn = ""
  set_keymaps(snacks, pack)

  pack.once_on_user("PackDeferred", function()
    setup_deferred(snacks)
  end)
end

return M
