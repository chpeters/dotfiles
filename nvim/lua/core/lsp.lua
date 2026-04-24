local SERVERS = {
  "bashls",
  "cssls",
  "dockerls",
  "html",
  "jsonls",
  "lua_ls",
  "mdx_analyzer",
  "ty",
  "tsgo",
  "tailwindcss",
}

local function on_lsp_attach(event)
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if not client then
    return
  end

  local bufnr = event.buf

  local function bufmap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  -- Diagnostics prev/next.
  bufmap("n", "[g", vim.diagnostic.goto_prev, "Prev diagnostic")
  bufmap("n", "]g", vim.diagnostic.goto_next, "Next diagnostic")

  -- Go-to navigation (gd/gy/gi/gr).
  bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
  bufmap("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
  bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  bufmap("n", "gr", vim.lsp.buf.references, "Go to references")

  bufmap("n", "K", vim.lsp.buf.hover, "Hover")
  bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  bufmap({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, "Code action")

  bufmap({ "n", "v" }, "<leader>f", function()
    local ok, conform = pcall(require, "conform")
    if ok then
      conform.format({
        async = true,
        lsp_format = "fallback",
      })
    else
      vim.lsp.buf.format({ async = true })
    end
  end, "Format buffer or selection")

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
    bufmap("n", "<leader>cl", vim.lsp.codelens.run, "CodeLens action")
  end

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

vim.opt.updatetime = 150

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = on_lsp_attach,
})

vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("LspDiagnosticsFloat", { clear = true }),
  callback = function()
    if vim.fn.pumvisible() == 1 then
      return
    end

    vim.diagnostic.open_float({
      scope = "cursor",
      focusable = false,
      border = "rounded",
      source = "if_many",
      close_events = { "CursorMoved", "InsertEnter", "BufLeave", "FocusLost" },
    })
  end,
})

for _, server in ipairs(SERVERS) do
  vim.lsp.enable(server)
end

vim.schedule(function()
  pcall(vim.cmd.doautoall, "nvim.lsp.enable FileType")
end)
