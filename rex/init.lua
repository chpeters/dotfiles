-- Reuse the Rex actions shipped by the Neovim backend, without another manager.
local data = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
local module = data .. "/nvim/site/pack/core/opt/smart-splits-backend-rex/rex/lua/smart-splits-rex/init.lua"
dofile(module).setup({ resize_amount = 3 })
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
    rex.bind("ctrl+" .. key, "smart_splits_focus", { direction = direction, key = "ctrl+" .. key })
    rex.bind("alt+" .. key, "smart_splits_resize", { direction = direction, key = "alt+" .. key })
end
