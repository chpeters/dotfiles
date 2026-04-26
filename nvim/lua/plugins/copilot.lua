local M = {}

function M.setup(pack)
  local configured = false

  local function ensure_copilot()
    if configured then
      return
    end

    configured = true
    pack.load("copilot.lua")

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
        return ""
      end

      return "\t"
    end, { expr = true, silent = true })
  end

  pack.defer({
    { src = pack.gh("zbirenbaum/copilot.lua"), name = "copilot.lua", data = { event = "InsertEnter", config = ensure_copilot } },
  })

  pack.proxy_command("Copilot", {
    nargs = "*",
    bang = true,
    desc = "Copilot",
  }, function(ctx)
    ensure_copilot()
    vim.cmd(pack.command_line(ctx))
  end)
end

return M
