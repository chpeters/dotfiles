return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = { "markdown" },
  cmd = { "Obsidian" },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
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
      -- base_id is what the command passed as `id` (after trimming) OR what :ObsidianNew passes as title.
      if base_id and base_id ~= "" then
        local s = tostring(base_id)

        -- If someone pastes a path, parse_as_path already peeled dirs off before calling note_id_func,
        -- but this makes it robust anyway.
        s = s:gsub("\\", "/"):match("([^/]+)$") or s

        -- generate_id() strips ".md" too, but do it here to keep behavior obvious.
        s = s:gsub("%.[mM][dD]$", "")

        -- Avoid accidental empty names
        s = vim.trim(s)
        s = s:gsub("%s+", "-")
        if s ~= "" then
          return s
        end
      end
    end
  },
}
