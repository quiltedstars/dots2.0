---@diagnostic disable: undefined-global
local awful = require 'awful'
local beautiful = require 'beautiful'
local gears = require 'gears'
local wibox = require 'wibox'
local helpers = require 'helpers'
local dpi = beautiful.xresources.apply_dpi

local apt_widget = require 'awesome-wm-widgets.apt-widget.apt-widget'
local getlayoutbox2 = require 'ui3.bar.modules.layoutbox'
local powerbutton2 = require 'ui3.bar.modules.powerbutton'
--local get_screenshot_icon = require 'ui.bar.actions-icons.screenshot'

require 'ui.bar.calendar'
--require 'ui.bar.tray'
--require 'ui.powermenu'

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
   --     return awful.placement.bottom_left(d, {
   --         margins = {
   --             bottom = beautiful.bar_height + beautiful.useless_gap * 2,
   --             left = beautiful.useless_gap * 2 + 165,
   --         }
   --     })
   -- end)

    --settings_tooltip.attach_to_object(settings_button)

    settings_button:add_button(awful.button({}, 1, function ()
        require 'ui.dashboard'
        awesome.emit_signal('dashboard::toggle')
    end))

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


  --  local tray_dispatcher_tooltip = helpers.make_popup_tooltip('Press to toggle the systray panel', function (d)
  --      return awful.placement.bottom_right(d, {
  --          margins = {
  --              bottom = beautiful.bar_height + beautiful.useless_gap * 2,
  --              right = beautiful.useless_gap * 33,
  --          }
  --      })
  --  end)


  --  tray_dispatcher_tooltip.attach_to_object(tray_dispatcher)

    -- make screenshot action icon global to edit it in anothers contexts.
  --  s.myscreenshot_action_icon = get_screenshot_icon(s)


    local clock_formats = {
        hour = '%I:%M %p',
        day = '%d/%m/%Y',
    }

    local clock = wibox.widget {
        format = clock_formats.hour,
        widget = wibox.widget.textclock,
    }

    local date = wibox.widget {
        {
            clock,
            fg = beautiful.blue,
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

    local base_layoutbox = awful.widget.layoutbox {
        screen = s
    }

    -- remove built-in tooltip.
    base_layoutbox._layoutbox_tooltip:remove_from_object(base_layoutbox)

    -- create button container
    local layoutbox = helpers.mkbtn(base_layoutbox, beautiful.black, beautiful.dimblack)

    -- function that returns the layout name but capitalized lol.
    local function layoutname()
        return 'Layout: ' .. helpers.capitalize(awful.layout.get(s).name)
    end

    -- make custom tooltip for the whole button
    local layoutbox_tooltip = helpers.make_popup_tooltip(layoutname(), function (d)
        return awful.placement.bottom_right(d, {
            margins = {
                bottom = beautiful.bar_height + beautiful.useless_gap * 2,
                right = beautiful.useless_gap * 2,
            }
        })
    end)

    layoutbox_tooltip.attach_to_object(layoutbox)

    -- updates tooltip content
    local update_content = function ()
        layoutbox_tooltip.widget.text = layoutname()
    end

    tag.connect_signal('property::layout', update_content)
    tag.connect_signal('property::selected', update_content)

    -- layoutbox buttons
    helpers.add_buttons(layoutbox, {
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc(-1) end),
        awful.button({ }, 5, function () awful.layout.inc( 1) end),
    })

  --  local powerbutton_tooltip = helpers.make_popup_tooltip('Open powermenu', function (d)
  --      return awful.placement.bottom_right(d, {
  --          margins = {
  --              bottom = beautiful.bar_height + beautiful.useless_gap * 2,
  --              right = beautiful.useless_gap * 2,
  --          }
  --      })
  --  end)

  --  powerbutton_tooltip.attach_to_object(powerbutton)


    s.mywibox = awful.wibar {
        position = 'top',
        screen = s,
        width = s.geometry.width,
        height = beautiful.bar_height,
        shape = gears.shape.rectangle,
    }

    s.mywibox:setup {
        {
            layout = wibox.layout.align.horizontal,
            {
                mkcontainer {
                 --   {
                 --       tray_dispatcher,
                 --       right = dpi(5),
                 --       widget = wibox.container.margin,
                 --   },
                 --   getlayoutbox2(s),
                   -- tasklist(s),
                    apt_widget(),
                 --   date,
                  --  settings_button,
                    --actions_icons_container,
                  --  powerbutton2,
                    spacing = dpi(8),
                    layout = wibox.layout.fixed.horizontal,
                    halign = 'center',
                },
                layout = wibox.layout.fixed.horizontal,
                halign = 'center'
			}
    }
    }
end)
