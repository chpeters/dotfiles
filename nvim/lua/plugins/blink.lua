return {
  {
    "saghen/blink.cmp",
    version = "1.*",         -- use tag with prebuilt binaries
    -- build = "cargo build --release", -- uncomment if you prefer building from source
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
    },
    event = { "InsertEnter", "CmdlineEnter" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- Snippets: use LuaSnip
      snippets = {
        preset = "luasnip",
      },

      -- Keymaps: "VS Code style" Tab completion, close to CoC behavior
      -- Tab to show/step, Shift-Tab to go back, etc.
      -- (See :h blink-cmp-config-keymap for details)
      keymap = {
        preset = "super-tab",
      },

      appearance = {
        -- use monospace nerd font alignment
        nerd_font_variant = "mono",
        -- make blink fallback to nvim-cmp highlight groups if your theme only knows those
        use_nvim_cmp_as_default = true,
      },

      completion = {
        documentation = {
          -- keep docs from auto-popping constantly; call manually when needed
          auto_show = false,
          auto_show_delay_ms = 200,
        },
      },

      sources = {
        -- basic sane defaults
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },

    config = function(_, opts)
      local blink = require("blink.cmp")
      blink.setup(opts)

      -- Hook blink's capabilities into lspconfig defaults, so every server
      -- configured by mason-lspconfig automatically advertises completion support.
      -- Pattern from blink.cmp / lspconfig docs. :contentReference[oaicite:0]{index=0}
      local lspconfig_util = require("lspconfig").util
      local defaults = lspconfig_util.default_config

      defaults.capabilities = vim.tbl_deep_extend(
        "force",
        defaults.capabilities or {},
        blink.get_lsp_capabilities()
      )
    end,
  },
}
