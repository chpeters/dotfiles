local M = {}

local opts = {
  completions = {
    lsp = {
      enabled = true,
    },
  },
  code = {
    border = "thick",
    conceal_delimiters = false,
    highlight = "RenderMarkdownCode",
    highlight_info = "RenderMarkdownCodeInfo",
    highlight_language = nil,
    highlight_border = "RenderMarkdownCodeBorder",
    highlight_fallback = "RenderMarkdownCodeFallback",
    highlight_inline = "RenderMarkdownCodeInline",
  },
  heading = {
    enabled = false,
  },
  win_options = {
    conceallevel = {
      default = 0,
      rendered = 0,
    },
  },
  bullet = {
    enabled = false,
  },
  checkbox = {
    enabled = false,
  },
  dash = {
    enabled = false,
  },
  document = {
    enabled = false,
  },
  html = {
    enabled = false,
  },
  indent = {
    enabled = false,
  },
  inline_highlight = {
    enabled = false,
  },
  latex = {
    enabled = false,
  },
  link = {
    enabled = false,
  },
  paragraph = {
    enabled = false,
  },
  pipe_table = {
    enabled = false,
  },
  quote = {
    enabled = false,
  },
}

function M.setup(pack)
  local configured = false
  local filetypes = { "markdown", "mdx", "Avante", "codecompanion" }

  local function ensure_markdown()
    if configured then
      return
    end

    configured = true
    vim.g.render_markdown_config = opts
    pack.load("render-markdown.nvim")
    require("render-markdown").setup(opts)
  end

  pack.defer({
    {
      src = pack.gh("MeanderingProgrammer/render-markdown.nvim"),
      name = "render-markdown.nvim",
      data = {
        event = "FileType",
        pattern = filetypes,
        replay = function(bufnr) return vim.list_contains(filetypes, vim.bo[bufnr].filetype) end,
        config = ensure_markdown,
      },
    },
  })
end

return M
