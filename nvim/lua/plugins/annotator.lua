local M = {}

local codex_export = {
  activate_delay = 0.4,
  submit_delay = 0.8,
  clipboard_restore_delay_ms = 3000,
}

local function notify(ctx, message, kind)
  ctx.notify(message, kind or "info")
end

local function restore_clipboard(value)
  vim.defer_fn(function()
    pcall(vim.fn.system, { "pbcopy" }, value or "")
  end, codex_export.clipboard_restore_delay_ms)
end

local function run_osascript(lines)
  local cmd = { "osascript" }
  for _, line in ipairs(lines) do
    table.insert(cmd, "-e")
    table.insert(cmd, line)
  end

  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return false, output
  end

  return true, nil
end

local function submit_to_codex(ctx)
  if vim.fn.has("mac") ~= 1 then
    notify(ctx, "Codex Desktop export requires macOS", "error")
    return
  end

  for _, executable in ipairs({ "pbcopy", "pbpaste", "osascript" }) do
    if vim.fn.executable(executable) ~= 1 then
      notify(ctx, executable .. " is required to send annotations to Codex", "error")
      return
    end
  end

  local previous_clipboard = vim.fn.system({ "pbpaste" })
  vim.fn.system({ "pbcopy" }, ctx.markdown)
  if vim.v.shell_error ~= 0 then
    notify(ctx, "Could not copy annotations for Codex", "error")
    return
  end

  local ok, err = run_osascript({
    'tell application "Codex" to activate',
    "delay " .. codex_export.activate_delay,
    'tell application "System Events"',
    '  tell application process "Codex"',
    "    set frontmost to true",
    "  end tell",
    "  key code 9 using {command down}",
    "  delay " .. codex_export.submit_delay,
    "  key code 36",
    "end tell",
  })

  restore_clipboard(previous_clipboard)

  if not ok then
    notify(
      ctx,
      (err or "Could not send annotations to Codex")
        .. "\nEnable Accessibility permission for your terminal if macOS blocked automation.",
      "error"
    )
    return
  end

  ctx.clear_exported()
  notify(ctx, "Sent " .. #ctx.annotations .. " annotation(s) to Codex", "info")
end

function M.setup(pack)
  pack.start({
    { src = "https://github.com/chpeters/annotator.nvim", name = "annotator.nvim" },
  })

  local annotator = require("annotator")

  annotator.setup({
    mappings = false,
    storage = "memory",
    display = {
      sign_text = "C>",
      virtual_text_prefix = " Codex: ",
    },
    hooks = {
      export = submit_to_codex,
    },
  })

  vim.keymap.set("n", "<leader>aa", function()
    annotator.add()
  end, { desc = "Annotate for Codex" })

  vim.keymap.set("x", "<leader>aa", function()
    annotator.add_visual()
  end, { desc = "Annotate selection for Codex" })

  vim.keymap.set("n", "<leader>as", function()
    annotator.suggest()
  end, { desc = "Suggest replacement for Codex" })

  vim.keymap.set("x", "<leader>as", function()
    annotator.suggest_visual()
  end, { desc = "Suggest selection replacement for Codex" })

  vim.keymap.set("n", "<leader>al", function()
    annotator.label()
  end, { desc = "Label annotation for Codex" })

  vim.keymap.set("x", "<leader>al", function()
    annotator.label_visual()
  end, { desc = "Label selection for Codex" })

  vim.keymap.set("n", "<leader>ad", function()
    annotator.mark_delete()
  end, { desc = "Mark deletion for Codex" })

  vim.keymap.set("x", "<leader>ad", function()
    annotator.mark_delete_visual()
  end, { desc = "Mark selection deletion for Codex" })

  vim.keymap.set("n", "<leader>ax", function()
    annotator.export()
  end, { desc = "Send annotations to Codex" })

  vim.keymap.set("n", "<leader>aL", function()
    annotator.list()
  end, { desc = "List Codex annotations" })

  vim.keymap.set("n", "<leader>ac", function()
    annotator.clear()
  end, { desc = "Clear Codex annotations" })
end

return M
