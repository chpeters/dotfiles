return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "mdx", "Avante", "codecompanion" },
  opts = {
    code = {
      highlight = 'markdownCodeBlock',
      highlight_info = 'markdownCodeBlock',
      highlight_language = nil,
      highlight_border = 'RenderMarkdownCodeBorder',
      highlight_fallback = 'RenderMarkdownCodeFallback',
      highlight_inline = 'markdownCodeBlock',
    },
    bullet = {
      right_pad = 1
    }
  }
}
