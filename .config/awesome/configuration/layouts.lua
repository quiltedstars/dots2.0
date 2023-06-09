---@diagnostic disable: undefined-global
local awful = require "awful"

local function set_layouts()
    tag.connect_signal("request::default_layouts", function ()
        awful.layout.append_default_layouts {
            awful.layout.suit.floating,
            awful.layout.suit.tile,
        }
    end)
end

set_layouts()
