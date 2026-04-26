local M = {}

local opts = {
  snippets = {
    preset = "luasnip",
  },
  keymap = {
    preset = "super-tab",
  },
  appearance = {
    nerd_font_variant = "mono",
    use_nvim_cmp_as_default = true,
  },
  completion = {
    documentation = {
      auto_show = false,
      auto_show_delay_ms = 200,
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
}

function M.setup(pack)
  local configured = false

  local function ensure_blink()
    if configured then
      return
    end

    configured = true
    pack.load({ "friendly-snippets", "LuaSnip", "blink.cmp" })
    require("blink.cmp").setup(opts)
  end

  pack.defer({
    { src = pack.gh("rafamadriz/friendly-snippets"), name = "friendly-snippets" },
    { src = pack.gh("L3MON4D3/LuaSnip"), name = "LuaSnip" },
    {
      src = pack.gh("saghen/blink.cmp"),
      name = "blink.cmp",
      version = vim.version.range("1"),
      data = { event = { "InsertEnter", "CmdlineEnter" }, config = ensure_blink },
    },
  })
end

return M
