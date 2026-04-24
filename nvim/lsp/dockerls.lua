-- Based on upstream dockerls server config.
-- Install: bun install -g dockerfile-language-server-nodejs

---@type vim.lsp.Config
return {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_markers = { "Dockerfile" },
}
