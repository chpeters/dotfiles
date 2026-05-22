local M = {}

local function setup_lint()
  local lint = require("lint")

  lint.linters_by_ft = {
    python = { "ruff" },
  }

  local function pick_linter(ft)
    local candidates = lint.linters_by_ft[ft]
    if type(candidates) ~= "table" then
      return nil
    end

    for _, name in ipairs(candidates) do
      if lint.linters[name] then
        if name == "ruff" and vim.fn.executable("ruff") ~= 1 then
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

    local chosen = pick_linter(ft)
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
    {
      src = pack.gh("mfussenegger/nvim-lint"),
      name = "nvim-lint",
      data = {
        event = { "BufReadPost", "BufNewFile" },
        replay = is_file_buffer,
        config = function(event)
          local run_lint = ensure_lint()
          if event.buf and vim.api.nvim_buf_is_valid(event.buf) then
            vim.api.nvim_buf_call(event.buf, run_lint)
          end
        end,
      },
    },
  })
end

return M
