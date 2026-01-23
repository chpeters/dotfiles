-- https://mason-registry.dev/registry/list
local PACKAGES = {
  -- LSP
  "basedpyright",
  "bashls",
  "cssls",
  "dockerls",
  "html",
  "jsonls",
  "lua_ls",
  "mdx-analyzer",
  "ty",
  "vtsls",
  "yamlls",
  "tailwindcss",
  -- Format
  "biome",
  "prettierd",
  "ruff",
  -- Lint
  "eslint_d",
  "pylint",
}

-- Shared on_attach: this replaces all your CoC LSP keymaps
local function on_attach(client, bufnr)
  local function bufmap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  -- Diagnostics prev/next (CoC had [g / ]g)
  bufmap("n", "[g", vim.diagnostic.goto_prev, "Prev diagnostic")
  bufmap("n", "]g", vim.diagnostic.goto_next, "Next diagnostic")

  -- Go-to navigation (gd/gy/gi/gr)
  bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
  bufmap("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
  bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  bufmap("n", "gr", vim.lsp.buf.references, "Go to references")

  -- Hover docs (K)
  bufmap("n", "K", vim.lsp.buf.hover, "Hover")

  -- Rename symbol
  bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")

  -- Code actions (normal + visual)
  bufmap({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, "Code action")

  -- Format (prefer conform if available, otherwise LSP format)
  bufmap({ "n", "v" }, "<leader>f", function()
    local ok, conform = pcall(require, "conform")
    if ok then
      conform.format({
        async = true,
        lsp_format = 'fallback',
      })
    else
      vim.lsp.buf.format({ async = true })
    end
  end, "Format buffer or selection")

  -- CodeLens actions if server supports it
  if client.server_capabilities.codeLensProvider then
    bufmap("n", "<leader>cl", vim.lsp.codelens.run, "CodeLens action")
  end

  -- Document highlight on CursorHold (similar to CocAction('highlight'))
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })

    vim.api.nvim_create_autocmd("CursorHold", {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      vim.opt.updatetime = 150

      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          if vim.fn.pumvisible() == 1 then return end

          vim.diagnostic.open_float({
            scope = "cursor",
            focusable = false,
            border = "rounded",
            source = "if_many",
            close_events = { "CursorMoved", "InsertEnter", "BufLeave", "FocusLost" },
          })
        end,
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    event = { "VeryLazy" },
    opts = {
      ui = {
        border = "rounded",
        height = 0.85,
        width = 0.8,
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      handlers = {
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            on_attach = on_attach,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim", "require" },
                },
                workspace = {
                  checkThirdParty = false,
                  library = vim.api.nvim_get_runtime_file("", true),
                },
              },
            },
          })
        end,

        ["*"] = function(server_name)
          require("lspconfig")[server_name].setup({
            on_attach = on_attach,
          })
        end,
      }
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = function()
      local packages = vim.tbl_deep_extend("force", {}, PACKAGES)

      return {
        ensure_installed = packages,
        integrations = {
          ["mason-lspconfig"] = true,
        },
      }
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = function()
      local function biome_available(dirname)
        if vim.fn.executable("biome") ~= 1 then
          return false
        end
        return vim.fs.find({ "biome.json", "biome.jsonc" }, {
          path = dirname,
          upward = true,
        })[1] ~= nil
      end

      return {
        default_format_opts = {
          lsp_format = "fallback",
        },

        formatters_by_ft = {
          javascript = { "biome", "prettier", "eslint_d", stop_after_first = true },
          typescript = { "biome", "prettier", "eslint_d", stop_after_first = true },
          javascriptreact = { "biome", "prettier", "eslint_d", stop_after_first = true },
          typescriptreact = { "biome", "prettier", "eslint_d", stop_after_first = true },
          python = { "ruff", stop_after_first = true },
        },

        format_on_save = {
          timeout_ms = 500,
        },

        formatters = {
          biome = {
            condition = function(ctx)
              return biome_available(ctx.dirname)
            end,
          },
          prettier = {
            condition = function(ctx)
              return not biome_available(ctx.dirname)
            end,
          },
          eslint_d = {
            condition = function(ctx)
              return not biome_available(ctx.dirname)
            end,
          },
        },
      }
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local uv = vim.uv or vim.loop

      lint.linters_by_ft = {
        javascript      = { "biomejs", "eslint_d" },
        typescript      = { "biomejs", "eslint_d" },
        javascriptreact = { "biomejs", "eslint_d" },
        typescriptreact = { "biomejs", "eslint_d" },

        python          = { "ruff", "pylint" },
      }

      local function has_biome_config(dirname)
        return vim.fs.find({ "biome.json", "biome.jsonc" }, { path = dirname, upward = true })[1] ~= nil
      end

      local function pick_linter(ft, dirname)
        local candidates = lint.linters_by_ft[ft]
        if type(candidates) ~= "table" then
          return nil
        end

        for _, name in ipairs(candidates) do
          -- must exist in nvim-lint
          if lint.linters[name] then
            if name == "biomejs" then
              if has_biome_config(dirname) then
                return "biomejs"
              end
            else
              if name == "eslint_d" and vim.fn.executable("eslint_d") ~= 1 then
              elseif name == "ruff" and vim.fn.executable("ruff") ~= 1 then
              elseif name == "pylint" and vim.fn.executable("pylint") ~= 1 then
              else
                return name
              end
            end
          end
        end

        return nil
      end

      local function lint_current()
        local bufnr = vim.api.nvim_get_current_buf()
        local ft = vim.bo[bufnr].filetype
        if not ft or ft == "" then
          return
        end

        local filename = vim.api.nvim_buf_get_name(bufnr)
        local dirname = (filename ~= "" and vim.fn.fnamemodify(filename, ":p:h")) or uv.cwd()

        local chosen = pick_linter(ft, dirname)
        if chosen then
          lint.try_lint({ chosen })
        end
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = lint_current,
      })
    end,
  },

  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (workspace, Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Diagnostics (buffer, Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix (Trouble)",
      },
    },
  },
}
