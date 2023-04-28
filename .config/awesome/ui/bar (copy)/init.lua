---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local awful = require 'awful'

local launchers = require 'ui.bar.modules.launchers'
--local gettaglist = require 'ui.bar.modules.tags'
local systray_toggler = require 'ui.bar.modules.systray_toggler'
local dashboard_toggler = require 'ui.bar.modules.dashboard_toggler'
local actions = require 'ui.bar.modules.actions'
local clock = require 'ui.bar.modules.date'
local getlayoutbox = require 'ui.bar.modules.layoutbox'
local powerbutton = require 'ui.bar.modules.powerbutton'

screen.connect_signal('request::desktop_decoration', function (s)
    awful.tag(
        {'1', '2', '3', '4', '5', '6'},
        s, awful.layout.layouts[1]
    )
local tasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.allscreen,
        -- sort clients by tags
        source = function()
			local ret = {}

			for _, t in ipairs(s.tags) do
				gears.table.merge(ret, t:clients())
			end

			return ret
		end,
        buttons = {
            awful.button({}, 1, function (c)
                if not c.active then
                    c:activate {
                        context = 'through_dock',
                        switch_to_tag = true,
                    }
                else
                    c.minimized = true
                end
            end),
            awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({}, 5, function() awful.client.focus.byidx( 1) end),
        },
        style = {
            shape = gears.shape.circle,
        },
        layout = {
            spacing = dpi(5),
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    margins = 2,
                    widget = wibox.container.margin,
                },
                margins = dpi(4),
                widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background,
            create_callback = function (self, c, _, _)
                self:connect_signal('mouse::enter', function ()
                    awesome.emit_signal('bling::task_preview::visibility', s, true, c)
                end)
                self:connect_signal('mouse::leave', function ()
                    awesome.emit_signal('bling::task_preview::visibility', s, false, c)
                end)
            end
        },
    }    
    local function mkcontainer(template)
        return wibox.widget {
            template,
            left = dpi(8),
            right = dpi(8),
            top = dpi(6),
            bottom = dpi(6),
            widget = wibox.container.margin,
        }
    end
    local bar_content = wibox.widget {
        {
            {
                {
                    launchers.get_launchers_widget(),
                    top = 7,
                    widget = wibox.container.margin,
                },
                nil,
                {
                    {
                        {
                            systray_toggler,
                            dashboard_toggler,
                            spacing = 9,
                            layout = wibox.layout.fixed.vertical,
                        },
                        {
                            actions,
                            bottom = 6,
                            widget = wibox.container.margin,
                        },
                        {
                            clock,
                            getlayoutbox(s),
                            powerbutton,
                            spacing = 2,
                            layout = wibox.layout.fixed.vertical,
                        },
                        layout = wibox.layout.fixed.vertical,
                    },
                    top = 5,
                    bottom = 5,
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.align.vertical,
            },
			{
            mkcontainer {
					tasklist,
					layout = wibox.layout.fixed.vertical
				},
				halign = 'center',
				widget = wibox.widget.margin,
				layout = wibox.container.place,
			},
            layout = wibox.layout.stack,
        },
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        widget = wibox.container.background,
    }

    local bar = awful.popup {
        visible = true,
        ontop = false,
        minimum_height = s.geometry.height - beautiful.useless_gap * 4,
        minimum_width = beautiful.bar_width,
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        widget = bar_content,
        screen = s,
        placement = function (d)
            return awful.placement.left(d, {
                margins = {
                    left = beautiful.useless_gap * 2
                }
            })
        end,
    }

    bar:struts {
        left = beautiful.bar_width + beautiful.useless_gap * 2,
    }
end)
