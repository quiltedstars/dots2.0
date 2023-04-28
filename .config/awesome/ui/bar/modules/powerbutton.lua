---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local awful = require 'awful'
local beautiful = require 'beautiful'

local powerbutton = wibox.widget {
    markup = '⏻',
    valign = 'center',
    font = beautiful.nerd_font .. ' 10',
    widget = wibox.widget.textbox,
        forced_height = 25,
        forced_width = 25,        
}

powerbutton:add_button(awful.button({}, 1, function ()
    awesome.emit_signal('powermenu::toggle')
end))

return wibox.widget {
   {
    powerbutton,
            halign = 'center',
            layout = wibox.container.place,
        },
        bottom = 5,
        top = 5,
        left = 2,
        widget = wibox.container.margin,
    }
