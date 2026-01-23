return {
  "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    config = function()
      local copilot = require("copilot")
      local suggestion = require("copilot.suggestion")

      copilot.setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = false,
          },
        },
      })

      vim.keymap.set("i", "<Tab>", function()
        if suggestion.is_visible() then
          suggestion.accept()
          return ""  -- Return empty so nothing extra is inserted.
        else
          return "\t"  -- Otherwise, insert a tab.
        end
      end, { expr = true, silent = true })
    end
  }
