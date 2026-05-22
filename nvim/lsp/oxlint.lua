local ROOT_MARKERS = { "package.json", "tsconfig.json", "jsconfig.json", ".git" }

local function project_root(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local dirname = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()

  return vim.fs.root(dirname, ROOT_MARKERS) or dirname
end

---@type vim.lsp.Config
return {
  cmd = { "oxlint", "--lsp" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
    "astro",
  },
  root_dir = function(bufnr, on_dir)
    local root = project_root(bufnr)
    if root then
      on_dir(root)
    end
  end,
  workspace_required = true,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "LspOxlintFixAll", function()
      client:exec_cmd({
        title = "Apply Oxlint automatic fixes",
        command = "oxc.fixAll",
        arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
      })
    end, {
      desc = "Apply Oxlint automatic fixes",
    })
  end,
  settings = {},
}
