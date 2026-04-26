local M = {}

local hook_group = vim.api.nvim_create_augroup("pack_hooks", { clear = true })
local deferred_group = vim.api.nvim_create_augroup("pack_deferred", { clear = true })
local lazy_group = vim.api.nvim_create_augroup("pack_lazy", { clear = true })

local function listify(value)
  if type(value) == "table" then
    return value
  end

  return { value }
end

local function spec_name(spec)
  return spec.name or spec.src:gsub("%.git$", ""):match("([^/:]+)$")
end

local function spec_data(spec)
  return type(spec.data) == "table" and spec.data or nil
end

local function run_build(event)
  if event.data.kind ~= "install" and event.data.kind ~= "update" then
    return
  end

  local build = spec_data(event.data.spec) and event.data.spec.data.build
  if type(build) == "function" then
    build(event)
  elseif build then
    vim.system(type(build) == "string" and { "sh", "-c", build } or build, { cwd = event.data.path })
  end
end

local function lazy_load(spec)
  local data = spec_data(spec)
  if not (data and data.event) then
    return
  end

  local name = spec_name(spec)
  local callback = function(event)
    if data.load then
      M.load(data.load)
    elseif not data.config then
      M.load(name)
    end

    if data.config then
      data.config(event)
    end
  end

  vim.api.nvim_create_autocmd(data.event, {
    group = lazy_group,
    once = true,
    pattern = data.pattern,
    callback = callback,
    desc = "Load " .. name,
  })

  if data.replay then
    M.replay_buffer(data.replay, callback)
  end
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
  local result = M.add(specs, { load = false })

  for _, spec in ipairs(specs) do
    lazy_load(spec)
  end

  return result
end

function M.load(names)
  for _, name in ipairs(listify(names)) do
    vim.cmd("packadd " .. vim.fn.fnameescape(name))
  end
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

M.ensure_packpath()

vim.api.nvim_create_autocmd("PackChanged", {
  group = hook_group,
  callback = run_build,
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
