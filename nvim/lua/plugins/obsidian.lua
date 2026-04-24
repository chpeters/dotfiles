local M = {}

local opts = {
  legacy_commands = false,
  workspaces = {
    {
      name = "notes",
      path = "~/Notes/notes",
    },
    {
      name = "writing",
      path = "~/Notes/writing",
    },
    {
      name = "goals",
      path = "~/Notes/goals",
    },
  },
  daily_notes = {
    folder = "daily",
    date_format = nil,
    alias_format = nil,
    default_tags = { "daily-notes" },
    workdays_only = false,
  },
  note_id_func = function(base_id, _path)
    if base_id and base_id ~= "" then
      local s = tostring(base_id)

      s = s:gsub("\\", "/"):match("([^/]+)$") or s
      s = s:gsub("%.[mM][dD]$", "")
      s = vim.trim(s)
      s = s:gsub("%s+", "-")
      if s ~= "" then
        return s
      end
    end
  end,
}

local function setup_obsidian()
  require("obsidian").setup(opts)

  local function enter_current_buffer(buf)
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end

    local ft = vim.bo[buf].filetype
    if ft ~= "markdown" and ft ~= "quarto" then
      return
    end

    vim.api.nvim_buf_call(buf, function()
      vim.api.nvim_exec_autocmds("BufEnter", {
        buffer = buf,
        group = "obsidian_setup",
        modeline = false,
      })
    end)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("obsidian_current_buffer", { clear = true }),
    pattern = { "markdown", "quarto" },
    callback = function(args)
      vim.schedule(function()
        enter_current_buffer(args.buf)
      end)
    end,
  })

  vim.schedule(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) then
        local ft = vim.bo[buf].filetype
        if ft == "markdown" or ft == "quarto" then
          vim.api.nvim_buf_call(buf, function()
            vim.api.nvim_exec_autocmds("FileType", {
              group = "obsidian_setup",
              pattern = ft,
              modeline = false,
            })
          end)
          enter_current_buffer(buf)
        end
      end
    end
  end)
end

function M.setup(pack)
  pack.start({
    { src = pack.gh("obsidian-nvim/obsidian.nvim"), name = "obsidian.nvim" },
  })

  setup_obsidian()
end

return M
