local M = {}

local opts = {
  completions = {
    lsp = {
      enabled = true,
    },
  },
  code = {
    highlight = "RenderMarkdownCode",
    highlight_info = "RenderMarkdownCodeInfo",
    highlight_language = nil,
    highlight_border = "RenderMarkdownCodeBorder",
    highlight_fallback = "RenderMarkdownCodeFallback",
    highlight_inline = "RenderMarkdownCodeInline",
  },
  bullet = {
    right_pad = 1,
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
    pack.load("render-markdown.nvim")
    require("render-markdown").setup(opts)
  end

  pack.defer({
    { src = pack.gh("MeanderingProgrammer/render-markdown.nvim"), name = "render-markdown.nvim" },
  })

  pack.once_on_filetypes_with_replay(filetypes, function()
    ensure_markdown()
  end)
end

return M
