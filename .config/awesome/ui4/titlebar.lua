---@diagnostic disable: undefined-global

local awful = require 'awful'
local wibox = require 'wibox'
local xresources = require 'beautiful.xresources'

local dpi = xresources.apply_dpi

client.connect_signal('request::titlebars', function (c)
    local titlebar = awful.titlebar(c, {
        position = 'left',
        size = 39
    })

    local titlebars_buttons = {
        awful.button({}, 1, function ()
            c:activate {
                context = 'titlebar',
                action = 'mouse_move',
            }
        end),
        awful.button({}, 3, function ()
            c:activate {
                context = 'titlebar',
                action = 'mouse_resize',
            }
        end)
    }

    local buttons_loader = {
        layout = wibox.layout.fixed.vertical,
        buttons = titlebars_buttons,
    }

    local function paddined_button(button, margins)
        margins = margins or {
            top = 4,
            bottom = 4,
            left = 13,
            right = 13
        }

        return wibox.widget {
            button,
            top = margins.top,
            bottom = margins.bottom,
            left = margins.left,
            right = margins.right,
            widget = wibox.container.margin,
        }
    end

    titlebar:setup {
        {
            paddined_button(awful.titlebar.widget.closebutton(c), {
                top = 14,
                bottom = 4,
                right = 13,
                left = 13
            }),
            paddined_button(awful.titlebar.widget.maximizedbutton(c)),
            paddined_button(awful.titlebar.widget.minimizebutton(c)),
            layout = wibox.layout.fixed.vertical,
        },
        buttons_loader,
        buttons_loader,
        layout = wibox.layout.align.vertical
    }
end)
