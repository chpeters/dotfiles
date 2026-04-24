local M = {}

local hook_group = vim.api.nvim_create_augroup("pack_hooks", { clear = true })
local deferred_group = vim.api.nvim_create_augroup("pack_deferred", { clear = true })
local hook_callbacks = {}
local once_id = 0

local function listify(value)
  if type(value) == "table" then
    return value
  end

  return { value }
end

function M.ensure_packpath()
  local site_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site")
  local packpath = vim.opt.packpath:get()

  if not vim.list_contains(packpath, site_dir) then
    vim.opt.packpath:append(site_dir)
  end
end

function M.gh(repo)
  return "https://github.com/" .. repo
end

function M.add(specs, opts)
  local add_opts = vim.tbl_extend("force", { confirm = false }, opts or {})
  return vim.pack.add(specs, add_opts)
end

function M.start(specs)
  return M.add(specs, { load = true })
end

function M.defer(specs)
  return M.add(specs, { load = false })
end

function M.load(names)
  for _, name in ipairs(listify(names)) do
    vim.cmd("packadd " .. vim.fn.fnameescape(name))
  end
end

function M.on_change(name, callback)
  hook_callbacks[name] = hook_callbacks[name] or {}
  table.insert(hook_callbacks[name], callback)
end

function M.once(events, opts, callback)
  once_id = once_id + 1
  local autocmd_opts = vim.tbl_extend("force", opts or {}, {
    group = vim.api.nvim_create_augroup("pack_once_" .. once_id, { clear = true }),
    once = true,
    callback = callback,
  })

  vim.api.nvim_create_autocmd(events, autocmd_opts)
end

function M.once_on_events(events, callback, opts)
  M.once(events, opts, callback)
end

function M.once_on_filetypes(filetypes, callback)
  M.once("FileType", { pattern = listify(filetypes) }, callback)
end

function M.once_on_user(pattern, callback)
  M.once("User", { pattern = pattern }, callback)
end

function M.proxy_command(name, opts, callback)
  vim.api.nvim_create_user_command(name, function(ctx)
    pcall(vim.api.nvim_del_user_command, name)
    callback(ctx)
  end, opts)
end

function M.command_line(ctx)
  local command = ctx.name

  if ctx.bang then
    command = command .. "!"
  end

  if ctx.args ~= "" then
    command = command .. " " .. ctx.args
  end

  return command
end

function M.plugin_config_dirs()
  local config_dir = vim.fn.stdpath("config")
  local dirs = {
    vim.fs.joinpath(config_dir, "plugin"),
    vim.fs.joinpath(config_dir, "lua", "plugins"),
  }

  return vim
    .iter(dirs)
    :filter(function(dir)
      return (vim.uv or vim.loop).fs_stat(dir) ~= nil
    end)
    :totable()
end

function M.find_buffer(predicate)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and predicate(buf) then
      return buf
    end
  end
end

function M.replay_buffer(predicate, callback)
  vim.schedule(function()
    local buf = M.find_buffer(predicate)
    if buf then
      callback({
        buf = buf,
        event = "PackReplay",
        match = vim.bo[buf].filetype,
      })
    end
  end)
end

function M.once_on_events_with_replay(events, predicate, callback, opts)
  M.once_on_events(events, callback, opts)
  M.replay_buffer(predicate, callback)
end

function M.once_on_filetypes_with_replay(filetypes, callback)
  local wanted = {}
  for _, filetype in ipairs(listify(filetypes)) do
    wanted[filetype] = true
  end

  M.once_on_filetypes(filetypes, callback)
  M.replay_buffer(function(buf)
    return wanted[vim.bo[buf].filetype] == true
  end, callback)
end

M.ensure_packpath()

vim.api.nvim_create_autocmd("PackChanged", {
  group = hook_group,
  callback = function(event)
    local callbacks = hook_callbacks[event.data.spec.name]
    if not callbacks then
      return
    end

    for _, callback in ipairs(callbacks) do
      callback(event)
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = deferred_group,
  once = true,
  callback = function()
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("User", {
        pattern = "PackDeferred",
        modeline = false,
      })
    end)
  end,
})

return M
