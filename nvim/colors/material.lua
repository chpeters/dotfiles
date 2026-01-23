-- Clear existing highlights and reset syntax
vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "material"
vim.g.material_theme_style = vim.g.material_theme_style or "default"
vim.g.material_terminal_italics = vim.g.material_terminal_italics or 0

local style = vim.g.material_theme_style

-- === Helpers ===

local function set_hl(group, fg, bg, attr)
  local a = attr

  if vim.g.material_terminal_italics == 0 and a == "italic" then
    a = ""
  end

  if not a or a == "" then
    a = "none"
  end

  if fg and type(fg) == "table" then
    vim.cmd(string.format("hi %s guifg=%s ctermfg=%s", group, fg.gui, fg.cterm))
  end

  if bg and type(bg) == "table" then
    vim.cmd(string.format("hi %s guibg=%s ctermbg=%s", group, bg.gui, bg.cterm))
  end

  if a and a ~= "" then
    vim.cmd(string.format("hi %s gui=%s cterm=%s", group, a, a))
  end
end

-- === Color Definitions ===

-- Default colors
vim.opt.background = "dark"

local bg = { gui = "#263238", cterm = "none" }
local fg = { gui = "#eeffff", cterm = 231 }
local invisibles = { gui = "#65738e", cterm = 66 }
local comments = { gui = "#546e7a", cterm = 145 }
local caret = { gui = "#ffcc00", cterm = 220 }
local selection = { gui = "#2c3b41", cterm = 239 }
local guides = { gui = "#37474f", cterm = 17 }
local line_numbers = { gui = "#37474f", cterm = 145 }
local line_highlight = { gui = "#1a2327", cterm = 235 }
local white = { gui = "#ffffff", cterm = 231 }
local black = { gui = "#000000", cterm = 232 }
local red = { gui = "#ff5370", cterm = 203 }
local orange = { gui = "#f78c6c", cterm = 209 }
local yellow = { gui = "#ffcb6b", cterm = 11 }
local green = { gui = "#c3e88d", cterm = 2 } -- 186 –– almost perfect match
local cyan = { gui = "#89ddff", cterm = 117 }
local blue = { gui = "#82aaff", cterm = 111 }
local paleblue = { gui = "#b2ccd6", cterm = 152 }
local purple = { gui = "#c792ea", cterm = 176 }
local brown = { gui = "#c17e70", cterm = 137 }
local pink = { gui = "#f07178", cterm = 204 }
local violet = { gui = "#bb80b3", cterm = 139 }

-- Theme-specific color overrides
if style == "palenight" or style == "palenight-community" then
  bg = { gui = "#292d3e", cterm = "none" }
  fg = { gui = "#a6accd", cterm = 146 }
  invisibles = { gui = "#4e5579", cterm = 60 }
  comments = { gui = "#676e95", cterm = 60 }
  selection = { gui = "#343b51", cterm = 60 }
  guides = { gui = "#4e5579", cterm = 60 }
  line_numbers = { gui = "#3a3f58", cterm = 60 }
  line_highlight = { gui = "#1c1f2b", cterm = 234 }
elseif style == "darker" or style == "darker-community" then
  bg = { gui = "#212121", cterm = "none" }
  fg = { gui = "#eeffff", cterm = 231 }
  invisibles = { gui = "#65737e", cterm = 66 }
  comments = { gui = "#545454", cterm = 59 }
  selection = { gui = "#2c2c2c", cterm = 237 }
  guides = { gui = "#424242", cterm = 0 }
  line_numbers = { gui = "#424242", cterm = 0 }
  line_highlight = { gui = "#171717", cterm = 0 }
elseif style == "ocean" or style == "ocean-community" then
  bg = { gui = "#0f111a", cterm = "none" }
  fg = { gui = "#8f93a2", cterm = 103 }
  invisibles = { gui = "#80869e", cterm = 103 }
  comments = { gui = "#464b5d", cterm = 60 }
  selection = { gui = "#1f2233", cterm = 60 }
  guides = { gui = "#3b3f51", cterm = 17 }
  line_numbers = { gui = "#3b3f51", cterm = 60 }
  line_highlight = { gui = "#0a0c12", cterm = 0 }
elseif style == "lighter" or style == "lighter-community" then
  vim.opt.background = "light"
  bg = { gui = "#fafafa", cterm = "none" }
  fg = { gui = "#90a4ae", cterm = 109 }
  invisibles = { gui = "#e7eaec", cterm = 189 }
  comments = { gui = "#90a4ae", cterm = 109 }
  caret = { gui = "#272727", cterm = 0 }
  selection = { gui = "#ebf4f3", cterm = 254 }
  guides = { gui = "#b0bec5", cterm = 146 }
  line_numbers = { gui = "#cfd8dc", cterm = 188 }
  line_highlight = { gui = "#ecf0f1", cterm = 253 }
  white = { gui = "#ffffff", cterm = 231 }
  black = { gui = "#000000", cterm = 0 }
  red = { gui = "#e53935", cterm = 160 }
  orange = { gui = "#f76d47", cterm = 202 }
  yellow = { gui = "#ffb62c", cterm = 214 }
  green = { gui = "#91b859", cterm = 107 }
  cyan = { gui = "#39adb5", cterm = 37 }
  blue = { gui = "#6182b8", cterm = 67 }
  paleblue = { gui = "#8796b0", cterm = 103 }
  purple = { gui = "#7c4dff", cterm = 99 }
  brown = { gui = "#c17e70", cterm = 137 }
  pink = { gui = "#ff5370", cterm = 203 }
  violet = { gui = "#945eb8", cterm = 97 }
end

-- === Global map for Airline, etc. ===

local map = {}
map.bg = bg
map.fg = fg
map.invisibles = invisibles
map.comments = comments
map.caret = caret
map.selection = selection
map.guides = guides
map.line_numbers = line_numbers
map.line_highlight = line_highlight
map.white = white
map.black = black
map.red = red
map.orange = orange
map.yellow = yellow
map.green = green
map.cyan = cyan
map.blue = blue
map.paleblue = paleblue
map.purple = purple
map.brown = brown
map.pink = pink
map.violet = violet

vim.g.material_colorscheme_map = map

-- === Highlights ===

-- Vim Editor
set_hl("ColorColumn", nil, invisibles, nil)
set_hl("Cursor", bg, caret, nil)
set_hl("CursorColumn", nil, line_highlight, nil)
set_hl("CursorLine", nil, line_highlight, nil)
set_hl("CursorLineNr", comments, nil, nil)
set_hl("Directory", blue, nil, nil)
set_hl("DiffAdd", green, bg, nil)
set_hl("DiffDelete", red, bg, nil)
set_hl("DiffChange", yellow, bg, nil)
set_hl("DiffText", orange, bg, nil)
set_hl("ErrorMsg", bg, red, "bold")
set_hl("FoldColumn", line_numbers, bg, nil)
set_hl("Folded", brown, bg, "bold")
set_hl("LineNr", line_numbers, nil, nil)
set_hl("MatchParen", caret, bg, "bold")
set_hl("ModeMsg", green, nil, nil)
set_hl("MoreMsg", green, nil, nil)
set_hl("NonText", comments, nil, nil)
set_hl("Normal", fg, bg, nil)
set_hl("Pmenu", fg, selection, nil)
set_hl("PmenuSel", bg, cyan, nil)
set_hl("PmenuSbar", nil, selection, nil)
set_hl("PmenuThumb", nil, comments, nil)
set_hl("Question", blue, nil, nil)
set_hl("IncSearch", white, comments, "none")
set_hl("Search", white, comments, "none")
set_hl("SignColumn", fg, bg, nil)
set_hl("SpecialKey", comments, nil, nil)
set_hl("SpellCap", blue, nil, "undercurl")
set_hl("SpellBad", red, nil, "undercurl")
set_hl("StatusLine", fg, selection, nil)
set_hl("StatusLineNC", comments, selection, nil)
set_hl("StatusLineTerm", bg, green, nil)
set_hl("StatusLineTermNC", bg, green, nil)
set_hl("TabLine", fg, line_numbers, nil)
set_hl("TabLineFill", fg, selection, nil)
set_hl("TabLineSel", bg, cyan, nil)
set_hl("Title", green, nil, nil)
set_hl("VertSplit", comments, nil, nil)
set_hl("Visual", fg, selection, nil)
set_hl("WarningMsg", red, nil, nil)
set_hl("WildMenu", bg, cyan, nil)

-- Syntax
set_hl("Comment", comments, nil, "italic")
set_hl("Conceal", brown, bg, nil)
set_hl("Constant", orange, nil, nil)
set_hl("String", green, nil, nil)
set_hl("Character", green, nil, nil)
set_hl("Identifier", red, nil, nil)
set_hl("Function", blue, nil, nil)
set_hl("Statement", purple, nil, nil)
set_hl("Operator", cyan, nil, nil)
set_hl("PreProc", cyan, nil, nil)
set_hl("Include", blue, nil, nil)
set_hl("Define", purple, nil, nil)
set_hl("Macro", purple, nil, nil)
set_hl("Type", yellow, nil, nil)
set_hl("Structure", cyan, nil, nil)
set_hl("Special", violet, nil, nil)
set_hl("Underlined", blue, nil, nil)
set_hl("Error", bg, red, nil)
set_hl("Todo", orange, bg, "italic")

-- Legacy diff links
vim.cmd("hi! link diffFile DiffAdd")
vim.cmd("hi! link diffNewFile DiffAdd")
vim.cmd("hi! link diffOldFile DiffDelete")
vim.cmd("hi! link diffAdded DiffAdd")
vim.cmd("hi! link diffChanged DiffChange")
vim.cmd("hi! link diffLine DiffChange")
vim.cmd("hi! link diffRemoved DiffDelete")

-- Git Commit Messages
set_hl("gitcommitHeader", purple, nil, nil)
set_hl("gitcommitUnmerged", green, nil, nil)
set_hl("gitcommitSelectedFile", green, nil, nil)
set_hl("gitcommitDiscardedFile", red, nil, nil)
set_hl("gitcommitUnmergedFile", yellow, nil, nil)
set_hl("gitcommitSelectedType", green, nil, nil)
set_hl("gitcommitSummary", blue, nil, nil)
set_hl("gitcommitDiscardedType", red, nil, nil)

vim.cmd("hi link gitcommitNoBranch gitcommitBranch")
vim.cmd("hi link gitcommitUntracked gitcommitComment")
vim.cmd("hi link gitcommitDiscarded gitcommitComment")
vim.cmd("hi link gitcommitSelected gitcommitComment")
vim.cmd("hi link gitcommitDiscardedArrow gitcommitDiscardedFile")
vim.cmd("hi link gitcommitSelectedArrow gitcommitSelectedFile")
vim.cmd("hi link gitcommitUnmergedArrow gitcommitUnmergedFile")

-- Javascript
set_hl("javaScriptBraces", fg, nil, nil)
set_hl("javaScriptNull", orange, nil, nil)
set_hl("javaScriptIdentifier", purple, nil, nil)
set_hl("javaScriptNumber", orange, nil, nil)
set_hl("javaScriptRequire", cyan, nil, nil)
set_hl("javaScriptReserved", purple, nil, nil)

-- pangloss/vim-javascript
if not tostring(style):match("%-community$") then
  set_hl("jsArrowFunction", purple, nil, nil)
  set_hl("jsAsyncKeyword", purple, nil, nil)
  set_hl("jsBooleanTrue", orange, nil, nil)
  set_hl("jsBooleanFalse", orange, nil, nil)
  set_hl("jsBrackets", pink, nil, nil)
  set_hl("jsCatch", cyan, nil, "italic")
  set_hl("jsClassBraces", cyan, nil, nil)
  set_hl("jsClassDefinition", yellow, nil, nil)
  set_hl("jsClassFuncName", pink, nil, nil)
  set_hl("jsClassProperty", pink, nil, nil)
  set_hl("jsClassKeyword", purple, nil, nil)
  set_hl("jsConditional", cyan, nil, "italic")
  set_hl("jsDocParam", green, nil, nil)
  set_hl("jsDocTags", cyan, nil, nil)
  set_hl("jsDot", cyan, nil, nil)
  set_hl("jsException", cyan, nil, "italic")
  set_hl("jsExceptions", yellow, nil, nil)
  set_hl("jsExport", cyan, nil, "italic")
  set_hl("jsExportDefault", cyan, nil, "italic")
  set_hl("jsExtendsKeyword", purple, nil, nil)
  set_hl("jsFinally", cyan, nil, "italic")
  set_hl("jsFinallyBraces", cyan, nil, nil)
  set_hl("jsFlowArgumentDef", yellow, nil, nil)
  set_hl("jsForAwait", cyan, nil, "italic")
  set_hl("jsFrom", cyan, nil, "italic")
  set_hl("jsFuncBraces", cyan, nil, nil)
  set_hl("jsFuncCall", blue, nil, nil)
  set_hl("jsFuncParens", cyan, nil, nil)
  set_hl("jsFunction", purple, nil, nil)
  set_hl("jsFunctionKey", pink, nil, nil)
  set_hl("jsGlobalObjects", yellow, nil, nil)
  set_hl("jsGlobalNodeObjects", yellow, nil, nil)
  set_hl("jsIfElseBraces", cyan, nil, nil)
  set_hl("jsImport", cyan, nil, "italic")
  set_hl("jsModuleAs", cyan, nil, "italic")
  set_hl("jsModuleBraces", cyan, nil, nil)
  set_hl("jsNull", cyan, nil, nil)
  set_hl("jsNoise", cyan, nil, nil)
  set_hl("jsObjectBraces", cyan, nil, nil)
  set_hl("jsObjectColon", cyan, nil, nil)
  set_hl("jsObjectKey", pink, nil, nil)
  set_hl("jsObjectSeparator", cyan, nil, nil)
  set_hl("jsParens", pink, nil, nil)
  set_hl("jsRepeat", cyan, nil, "italic")
  set_hl("jsReturn", cyan, nil, "italic")
  set_hl("jsStorageClass", purple, nil, nil)
  set_hl("jsTemplateBraces", cyan, nil, nil)
  set_hl("jsTemplateExpression", fg, nil, nil)
  set_hl("jsTemplateString", green, nil, nil)
  set_hl("jsThis", cyan, nil, "italic")
  set_hl("jsTry", cyan, nil, "italic")
  set_hl("jsTryCatchBraces", cyan, nil, nil)
  set_hl("jsUndefined", cyan, nil, nil)
else
  set_hl("jsArrowFunction", purple, nil, nil)
  set_hl("jsAsyncKeyword", purple, nil, nil)
  set_hl("jsExtendsKeyword", purple, nil, nil)
  set_hl("jsClassKeyword", purple, nil, nil)
  set_hl("jsDocParam", green, nil, nil)
  set_hl("jsDocTags", cyan, nil, nil)
  set_hl("jsForAwait", purple, nil, nil)
  set_hl("jsFlowArgumentDef", yellow, nil, nil)
  set_hl("jsFrom", purple, nil, nil)
  set_hl("jsImport", purple, nil, nil)
  set_hl("jsExport", purple, nil, nil)
  set_hl("jsExportDefault", purple, nil, nil)
  set_hl("jsFuncCall", blue, nil, nil)
  set_hl("jsFunction", purple, nil, nil)
  set_hl("jsGlobalObjects", yellow, nil, nil)
  set_hl("jsGlobalNodeObjects", yellow, nil, nil)
  set_hl("jsModuleAs", purple, nil, nil)
  set_hl("jsNull", orange, nil, nil)
  set_hl("jsStorageClass", purple, nil, nil)
  set_hl("jsTemplateBraces", red, nil, nil)
  set_hl("jsTemplateExpression", red, nil, nil)
  set_hl("jsThis", red, nil, nil)
  set_hl("jsUndefined", orange, nil, nil)
end

-- JSON
set_hl("jsonBraces", fg, nil, nil)

-- CSS
set_hl("cssAttrComma", fg, nil, nil)
set_hl("cssPseudoClassId", yellow, nil, nil)
set_hl("cssBraces", fg, nil, nil)
set_hl("cssClassName", yellow, nil, nil)
set_hl("cssClassNameDot", yellow, nil, nil)
set_hl("cssFunctionName", blue, nil, nil)
set_hl("cssImportant", cyan, nil, nil)
set_hl("cssIncludeKeyword", purple, nil, nil)
set_hl("cssTagName", red, nil, nil)
set_hl("cssMediaType", orange, nil, nil)
set_hl("cssProp", fg, nil, nil)
set_hl("cssSelectorOp", cyan, nil, nil)
set_hl("cssSelectorOp2", cyan, nil, nil)

-- Sass
set_hl("sassAmpersand", red, nil, nil)
set_hl("sassClassChar", yellow, nil, nil)
set_hl("sassMixinName", blue, nil, nil)
set_hl("sassVariable", purple, nil, nil)

-- Less
set_hl("lessAmpersand", red, nil, nil)
set_hl("lessClassChar", yellow, nil, nil)
set_hl("lessCssAttribute", fg, nil, nil)
set_hl("lessFunction", blue, nil, nil)
set_hl("lessVariable", purple, nil, nil)

-- HTML
set_hl("htmlTagName", pink, nil, nil)
set_hl("htmlEndTag", cyan, nil, nil)
set_hl("htmlTag", cyan, nil, nil)
set_hl("htmlSpecialTagName", yellow, nil, nil)
set_hl("htmlArg", purple, nil, "italic")
set_hl("htmlTitle", fg, nil, nil)
set_hl("htmlLink", fg, nil, nil)
set_hl("htmlBold", pink, nil, "bold")
set_hl("htmlH1", yellow, nil, nil)
set_hl("htmlH2", yellow, nil, nil)
set_hl("htmlH3", yellow, nil, nil)
set_hl("htmlH4", yellow, nil, nil)
set_hl("htmlH5", yellow, nil, nil)
set_hl("htmlH6", yellow, nil, nil)
set_hl("htmlItalic", pink, nil, "italic")

-- XML
set_hl("xmlAttrib", purple, nil, "italic")
set_hl("xmlEndTag", cyan, nil, nil)
set_hl("xmlTag", cyan, nil, nil)
set_hl("xmlTagName", pink, nil, nil)

-- Golang
set_hl("goFunctionCall", blue, nil, nil)
set_hl("goReceiverType", green, nil, nil)
set_hl("goParamName", orange, nil, nil)
set_hl("goParamType", green, nil, nil)
set_hl("goTypeDecl", purple, nil, nil)
set_hl("goTypeName", yellow, nil, nil)
set_hl("goBuiltins", red, nil, nil)
set_hl("goType", purple, nil, nil)
set_hl("goSignedInts", purple, nil, nil)
set_hl("goUnsignedInts", purple, nil, nil)
set_hl("goFloats", purple, nil, nil)
set_hl("goComplexes", purple, nil, nil)

-- Ruby
set_hl("rubyInterpolation", cyan, nil, nil)
set_hl("rubyInterpolationDelimiter", violet, nil, nil)
set_hl("rubyRegexp", cyan, nil, nil)
set_hl("rubyRegexpDelimiter", violet, nil, nil)
set_hl("rubyStringDelimiter", green, nil, nil)

-- Rust
set_hl("CocRustTypeHint", invisibles, nil, nil)
set_hl("CocRustChainingHint", invisibles, nil, nil)

-- TeX
set_hl("texBeginEndName", blue, nil, nil)
set_hl("texMathMatcher", blue, nil, nil)
set_hl("texCite", green, nil, nil)
set_hl("texRefZone", green, nil, nil)
set_hl("texInputFile", green, nil, nil)
set_hl("texMath", orange, nil, nil)
set_hl("texMathOper", yellow, nil, nil)

-- Markdown
if not tostring(style):match("%-community$") then
  set_hl("markdownBold", pink, nil, "bold")
  set_hl("markdownBoldDelimiter", cyan, nil, nil)
  set_hl("markdownCode", paleblue, nil, nil)
  set_hl("markdownCodeBlock", paleblue, guides, nil)
  set_hl("markdownCodeDelimiter", green, nil, nil)
  set_hl("markdownHeadingDelimiter", cyan, nil, nil)
  set_hl("markdownH1", yellow, nil, nil)
  set_hl("markdownH2", yellow, nil, nil)
  set_hl("markdownH3", yellow, nil, nil)
  set_hl("markdownH4", yellow, nil, nil)
  set_hl("markdownH5", yellow, nil, nil)
  set_hl("markdownH6", yellow, nil, nil)
  set_hl("markdownItalic", pink, nil, "italic")
  set_hl("markdownItalicDelimiter", cyan, nil, nil)
  set_hl("markdownLinkDelimiter", cyan, nil, nil)
  set_hl("markdownLinkText", green, nil, nil)
  set_hl("markdownLinkTextDelimiter", cyan, nil, nil)
  set_hl("markdownListMarker", cyan, nil, nil)
  set_hl("markdownUrl", pink, nil, "underline")
  set_hl("markdownUrlTitleDelimiter", green, nil, nil)
else
  set_hl("markdownBold", yellow, nil, "bold")
  set_hl("markdownCode", cyan, nil, nil)
  set_hl("markdownCodeBlock", cyan, guides, nil)
  set_hl("markdownCodeDelimiter", cyan, nil, nil)
  set_hl("markdownHeadingDelimiter", green, nil, nil)
  set_hl("markdownHeadingRule", comments, nil, nil)
  set_hl("markdownId", purple, nil, nil)
  set_hl("markdownItalic", blue, nil, "italic")
  set_hl("markdownListMarker", orange, nil, nil)
  set_hl("markdownOrderedListMarker", orange, nil, nil)
  set_hl("markdownRule", comments, nil, nil)
  set_hl("markdownUrl", purple, nil, nil)
  set_hl("markdownUrlTitleDelimiter", yellow, nil, nil)
end

-- vim-gitgutter
set_hl("GitGutterAdd", green, nil, nil)
set_hl("GitGutterChange", yellow, nil, nil)
set_hl("GitGutterChangeDelete", orange, nil, nil)
set_hl("GitGutterDelete", red, nil, nil)

-- vim-signify
vim.cmd("hi link SignifySignAdd GitGutterAdd")
vim.cmd("hi link SignifySignChange GitGutterChange")
vim.cmd("hi link SignifySignDelete GitGutterDelete")

-- NERDTree
if vim.fn.has("nvim") == 1 then
  set_hl("NERDTreeFile", fg, nil, nil)
end

-- coc.nvim
set_hl("CocMarkdownLink", purple, nil, nil)
set_hl("CocErrorSign", red, nil, nil)
set_hl("CocWarningSign", orange, nil, nil)
set_hl("CocHintSign", yellow, nil, nil)
set_hl("CocInfoSign", green, nil, nil)

-- Neovim terminal and Tree-sitter
if vim.fn.has("nvim") == 1 then
  vim.g.terminal_color_background = bg.gui
  vim.g.terminal_color_foreground = fg.gui
  vim.g.terminal_color_0 = comments.gui
  vim.g.terminal_color_1 = red.gui
  vim.g.terminal_color_2 = green.gui
  vim.g.terminal_color_3 = yellow.gui
  vim.g.terminal_color_4 = blue.gui
  vim.g.terminal_color_5 = purple.gui
  vim.g.terminal_color_6 = cyan.gui
  vim.g.terminal_color_7 = white.gui
  vim.g.terminal_color_8 = vim.g.terminal_color_0
  vim.g.terminal_color_9 = vim.g.terminal_color_1
  vim.g.terminal_color_10 = vim.g.terminal_color_2
  vim.g.terminal_color_11 = vim.g.terminal_color_3
  vim.g.terminal_color_12 = vim.g.terminal_color_4
  vim.g.terminal_color_13 = vim.g.terminal_color_5
  vim.g.terminal_color_14 = vim.g.terminal_color_6
  vim.g.terminal_color_15 = vim.g.terminal_color_7

  if vim.fn.has("nvim-0.8") == 1 then
    -- Tree-sitter (Neovim v0.8+)
    set_hl("@attribute", yellow, nil, nil)
    set_hl("@attribute.builtin", yellow, nil, nil)
    set_hl("@boolean", orange, nil, nil)
    set_hl("@character", green, nil, nil)
    set_hl("@character.special", purple, nil, nil)
    set_hl("@comment", comments, nil, "italic")
    set_hl("@comment.documentation", comments, nil, "italic")
    set_hl("@comment.error", pink, nil, nil)
    set_hl("@comment.hint", cyan, nil, nil)
    set_hl("@comment.info", cyan, nil, nil)
    set_hl("@comment.todo", orange, nil, nil)
    set_hl("@comment.warning", yellow, nil, nil)
    set_hl("@constant", orange, nil, nil)
    set_hl("@constant.builtin", orange, nil, nil)
    set_hl("@constant.macro", purple, nil, nil)
    set_hl("@constructor", yellow, nil, nil)
    set_hl("@diff.delta", yellow, nil, nil)
    set_hl("@diff.minus", red, nil, nil)
    set_hl("@diff.plus", green, nil, nil)
    set_hl("@function", blue, nil, nil)
    set_hl("@function.builtin", blue, nil, nil)
    set_hl("@function.macro", purple, nil, nil)
    set_hl("@function.method", blue, nil, nil)
    set_hl("@keyword", purple, nil, nil)
    set_hl("@keyword.conditional", cyan, nil, "italic")
    set_hl("@keyword.directive", purple, nil, nil)
    set_hl("@keyword.directive.define", purple, nil, nil)
    set_hl("@keyword.exception", cyan, nil, "italic")
    set_hl("@keyword.function", purple, nil, nil)
    set_hl("@keyword.import", cyan, nil, "italic")
    set_hl("@keyword.operator", cyan, nil, "italic")
    set_hl("@keyword.repeat", cyan, nil, "italic")
    set_hl("@keyword.return", cyan, nil, "italic")
    set_hl("@label", purple, nil, nil)
    set_hl("@markup.heading", yellow, nil, nil)
    set_hl("@markup.heading.1", yellow, nil, nil)
    set_hl("@markup.heading.2", yellow, nil, nil)
    set_hl("@markup.heading.3", yellow, nil, nil)
    set_hl("@markup.heading.4", yellow, nil, nil)
    set_hl("@markup.heading.5", yellow, nil, nil)
    set_hl("@markup.heading.6", yellow, nil, nil)
    set_hl("@markup.italic", pink, nil, "italic")
    set_hl("@markup.link", pink, nil, nil)
    set_hl("@markup.list", cyan, nil, nil)
    set_hl("@markup.list.checked", cyan, nil, nil)
    set_hl("@markup.list.unchecked", cyan, nil, nil)
    set_hl("@markup.math", cyan, nil, nil)
    set_hl("@markup.quote", comments, nil, nil)
    set_hl("@markup.raw", paleblue, nil, nil)
    set_hl("@markup.strikethrough", pink, nil, "strikethrough")
    set_hl("@markup.strong", pink, nil, "bold")
    set_hl("@markup.underline", pink, nil, "underline")
    set_hl("@module", red, nil, nil)
    set_hl("@number", orange, nil, nil)
    set_hl("@number.float", orange, nil, nil)
    set_hl("@operator", cyan, nil, nil)
    set_hl("@property", fg, nil, nil)
    set_hl("@punctuation.bracket", cyan, nil, nil)
    set_hl("@punctuation.delimiter", cyan, nil, nil)
    set_hl("@string", green, nil, nil)
    set_hl("@string.documentation", comments, nil, nil)
    set_hl("@string.escape", purple, nil, nil)
    set_hl("@string.regexp", purple, nil, nil)
    set_hl("@string.special", blue, nil, nil)
    set_hl("@tag", pink, nil, nil)
    set_hl("@tag.attribute", purple, nil, nil)
    set_hl("@tag.delimiter", cyan, nil, nil)
    set_hl("@type", yellow, nil, nil)
    set_hl("@type.builtin", yellow, nil, nil)
    set_hl("@type.definition", yellow, nil, nil)
    set_hl("@variable", fg, nil, nil)
    set_hl("@variable.builtin", fg, nil, nil)
    set_hl("@variable.member", fg, nil, nil)
    set_hl("@variable.parameter", fg, nil, nil)
  else
    -- Tree-sitter (Neovim v0.7)
    set_hl("TSAttribute", yellow, nil, nil)
    set_hl("TSBoolean", pink, nil, nil)
    set_hl("TSConditional", cyan, nil, "italic")
    set_hl("TSConstructor", yellow, nil, nil)
    set_hl("TSConstBuiltin", cyan, nil, nil)
    set_hl("TSException", cyan, nil, "italic")
    set_hl("TSField", white, nil, nil)
    set_hl("TSFunction", blue, nil, nil)
    set_hl("TSFuncBuiltin", blue, nil, nil)
    set_hl("TSInclude", cyan, nil, "italic")
    set_hl("TSKeyword", purple, nil, nil)
    set_hl("TSKeywordOperator", cyan, nil, "italic")
    set_hl("TSKeywordFunction", purple, nil, nil)
    set_hl("TSKeywordReturn", cyan, nil, "italic")
    set_hl("TSMethod", blue, nil, nil)
    set_hl("TSOperator", cyan, nil, nil)
    set_hl("TSParameter", fg, nil, nil)
    set_hl("TSProperty", fg, nil, nil)
    set_hl("TSPunctBracket", cyan, nil, nil)
    set_hl("TSPunctDelimiter", cyan, nil, nil)
    set_hl("TSRepeat", cyan, nil, "italic")
    set_hl("TSTag", pink, nil, nil)
    set_hl("TSTagDelimiter", cyan, nil, nil)
    set_hl("TSTagAttribute", purple, nil, nil)
    set_hl("TSType", yellow, nil, nil)
    set_hl("TSVariable", fg, nil, nil)
    set_hl("TSVariableBuiltin", fg, nil, nil)
  end
end


-- md render.nvim
set_hl("RenderMarkdownCode", cyan, nil, nil)
set_hl("RenderMarkdownCodeInfo", cyan, nil, "italic")
set_hl("RenderMarkdownCodeBorder", cyan, nil, nil)
set_hl("RenderMarkdownCodeFallback", cyan, nil, nil)

-- Inline code: subtle pill
-- If you want it to pop more, swap fg->paleblue or cyan
set_hl("RenderMarkdownCodeInline", cyan, line_highlight, nil)
