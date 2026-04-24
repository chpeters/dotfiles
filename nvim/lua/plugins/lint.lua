local M = {}

local function setup_lint()
  local lint = require("lint")
  local uv = vim.uv or vim.loop

  lint.linters_by_ft = {
    javascript = { "biomejs", "eslint_d" },
    typescript = { "biomejs", "eslint_d" },
    javascriptreact = { "biomejs", "eslint_d" },
    typescriptreact = { "biomejs", "eslint_d" },
    python = { "ruff" },
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
      if lint.linters[name] then
        if name == "biomejs" then
          if has_biome_config(dirname) then
            return "biomejs"
          end
        elseif name == "eslint_d" and vim.fn.executable("eslint_d") ~= 1 then
        elseif name == "ruff" and vim.fn.executable("ruff") ~= 1 then
        else
          return name
        end
      end
    end
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
    group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
    callback = lint_current,
  })

  return lint_current
end

local function is_file_buffer(bufnr)
  return vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_get_name(bufnr) ~= ""
end

function M.setup(pack)
  local configured = false
  local lint_current

  local function ensure_lint()
    if not configured then
      configured = true
      pack.load("nvim-lint")
      lint_current = setup_lint()
    end

    return lint_current
  end

  pack.defer({
    { src = pack.gh("mfussenegger/nvim-lint"), name = "nvim-lint" },
  })

  pack.once_on_events_with_replay({ "BufReadPost", "BufNewFile" }, is_file_buffer, function(event)
    local run_lint = ensure_lint()
    if event.buf and vim.api.nvim_buf_is_valid(event.buf) then
      vim.api.nvim_buf_call(event.buf, run_lint)
    end
  end)
end

return M
