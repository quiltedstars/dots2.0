local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local gfs = require("gears.filesystem")
require("awful.autofocus")

beautiful.init(gfs.get_configuration_dir() .. "theme/theme.lua")

terminal = "xfce4-terminal"
browser = "librewolf"
fm = "nemo"
vscode = "geany"
discord = "discord"
editor = os.getenv("EDITOR") or "geany"
editor_cmd = terminal .. " -e " .. editor

myawesomemenu = {
    { "Restart", awesome.restart },
    { "Quit", function() awesome.quit() end },
    { "Shutdown", terminal .. " shutdown now " },
    { "Reboot", terminal .. " reboot "}
  }
  
myapps = {
    { "File", nemo },
    { "Browser", librewolf },
    { "Editor", geany },
    { "Kitty", xfce4-terminal },
    { "Discord", discord }
}

  mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon},
                                      { "apps", myapps},
                                     { "term", terminal }
                                   }
                         })
