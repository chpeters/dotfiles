local M = {}

local function biome_available(dirname)
  if vim.fn.executable("biome") ~= 1 then
    return false
  end

  return vim.fs.find({ "biome.json", "biome.jsonc" }, {
    path = dirname,
    upward = true,
  })[1] ~= nil
end

local function conform_opts()
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
end

local function is_file_buffer(bufnr)
  return vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_get_name(bufnr) ~= ""
end

function M.setup(pack)
  local configured = false

  local function ensure_conform()
    if configured then
      return
    end

    configured = true
    pack.load("conform.nvim")
    require("conform").setup(conform_opts())
  end

  pack.defer({
    {
      src = pack.gh("stevearc/conform.nvim"),
      name = "conform.nvim",
      data = { event = { "BufReadPost", "BufNewFile" }, replay = is_file_buffer, config = ensure_conform },
    },
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("conform_format", { clear = true }),
    callback = function(event)
      ensure_conform()
      require("conform").format({
        bufnr = event.buf,
        timeout_ms = 500,
        lsp_format = "fallback",
      })
    end,
  })
end

return M
