---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local awful = require 'awful'

local toggler = wibox.widget {
   {
    markup = '',
    align = 'center',
    font = beautiful.nerd_font .. ' 10',
    widget = wibox.widget.textbox,
        forced_height = 25,
        forced_width = 30,    
},
        bottom = 5,
        top = 8,
        left = 0,
        right = 0,
        widget = wibox.container.margin,
}

toggler:add_button(awful.button({}, 1, function ()
    awesome.emit_signal('dashboard::toggle')
end))

return toggler
