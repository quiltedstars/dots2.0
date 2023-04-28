---@diagnostic disable: undefined-global
local awful = require 'awful'
local beautiful = require 'beautiful'
local gears = require 'gears'
local wibox = require 'wibox'
local helpers = require 'helpers'
local dpi = beautiful.xresources.apply_dpi

local launchers = require 'ui.bar.modules.launchers'
--local gettaglist = require 'ui.bar.modules.tags'
local systray_toggler = require 'ui.bar.modules.systray_toggler'
local dashboard_toggler = require 'ui.bar.modules.dashboard_toggler'
local actions = require 'ui.bar.modules.actions'
--local clock = require 'ui.bar.modules.date'
local getlayoutbox = require 'ui.bar.modules.layoutbox'
local powerbutton = require 'ui.bar.modules.powerbutton'
--require 'ui.bar.calendar'
--local xbps_widget = require 'awesome-wm-widgets.xbps-widget.xbps-widget'
local pacman_widget = require 'awesome-wm-widgets.pacman-widget.pacman'
--local ram_widget = require 'awesome-wm-widgets.ram-widget.ram-widget'
local apt_widget = require 'awesome-wm-widgets.apt-widget.apt-widget'
--local email_widget, email_icon = require 'awesome-wm-widgets.email-widget.email'
local calendar = require 'widget.clock'

screen.connect_signal('request::desktop_decoration', function (s)
    awful.tag(
        {'1', '2', '3', '4', '5', '6'},
        s, awful.layout.layouts[1]
    )
    

    
    local settings_button = helpers.mkbtn({
        widget = wibox.widget.imagebox,
        image = beautiful.menu_icon,
        forced_height = dpi(16),
        forced_width = dpi(16),
        halign = 'center',
    }, beautiful.black, beautiful.dimblack)

   -- local settings_tooltip = helpers.make_popup_tooltip('Toggle dashboard', function (d)

    --end)

    --settings_tooltip.attach_to_object(settings_button)

    settings_button:add_button(awful.button({}, 1, function ()
        require 'ui.dashboard'
        awesome.emit_signal('dashboard::toggle')
    end))
     
s.mytasklist = awful.widget.tasklist {
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
            shape = gears.shape.square,
        },
        layout = {
            spacing = dpi(5),
            layout = wibox.layout.flex.vertical
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
     local clock_formats = {
        hour = '%I:%M %p',
        day = '%A %B %d',
        font = beautiful.font_name .. ' 10',
        forced_height = 10,
    }

    local clock = wibox.widget {
        format = clock_formats.hour,
        widget = wibox.widget.textclock,
    }

    local date = wibox.widget {
        {
            clock,
            forced_height = 10,
            fg = beautiful.white,
            widget = wibox.container.background,
        },
        margins = dpi(7),
        widget = wibox.container.margin,
    }

    date:connect_signal('mouse::enter', function ()
        awesome.emit_signal('calendar::visibility', true)
    end)

    date:connect_signal('mouse::leave', function ()
        awesome.emit_signal('calendar::visibility', false)
    end)

    date:add_button(awful.button({}, 1, function ()
        clock.format = clock.format == clock_formats.hour
            and clock_formats.day
            or clock_formats.hour
    end))


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

    s.mywibox = wibox 
    {
        position = 'top',
        screen = s,
        visible = true,
        ontop = true,
        width = 300,
        height = 30,
        x = s.geometry.width / 2 - 150,
        placement = function (d)
            return awful.placement.top(d)
        end,
        align = "center",
        shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 20)
            end,
    }

    s.mywibox:setup {
       
       
        {
					getlayoutbox(),
                    dashboard_toggler,
					--apt_widget(),
                    date,
                  --  pacman_widget(),
                    apt_widget(),                  
                    powerbutton,
                    --powerbutton,
                --s.mytasklist,
                spacing = dpi(10),
                layout = wibox.layout.fixed.horizontal
            },
            align = 'center',
            halign = 'center',
            valign = 'center',
            layout = wibox.container.place,
        
    }
end)
