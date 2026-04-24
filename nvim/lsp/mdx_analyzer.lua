-- Based on upstream mdx_analyzer server config.
-- Install: bun install -g @mdx-js/language-server

local function get_typescript_server_path(root_dir)
  local project_roots = vim.fs.find("node_modules", { path = root_dir, upward = true, limit = math.huge })
  for _, project_root in ipairs(project_roots) do
    local typescript_path = project_root .. "/typescript"
    if (vim.uv.fs_stat(typescript_path) or {}).type == "directory" then
      return typescript_path .. "/lib"
    end
  end
  return ""
end

---@type vim.lsp.Config
return {
  cmd = { "mdx-language-server", "--stdio" },
  filetypes = { "mdx" },
  root_markers = { "package.json" },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        -- mdx-language-server registers `**/*.{mdx}`, which Neovim rejects as an invalid glob.
        dynamicRegistration = false,
      },
    },
  },
  settings = {},
  init_options = {
    typescript = {
      enabled = true,
    },
  },
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and not config.init_options.typescript.tsdk then
      config.init_options.typescript.tsdk = get_typescript_server_path(config.root_dir)
    end
  end,
}
