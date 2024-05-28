local wibox = require "wibox"
local beautiful = require "beautiful"
local awful = require "awful"
local client = client
local gears = require "gears"


-- Create a textclock widget
local mytextclock = wibox.container.background(
    wibox.widget.textclock(),
    beautiful.bg_normal,
    gears.shape.rounded_rect
)

-- Battery widget
local battery = require "themes.nord.battery_widget"

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 10 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Movido para o tema
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "󰭹" }, s, awful.layout.layouts[1])

    awful.tag.setlayout(awful.layout.suit.magnifier,
        awful.tag.find_by_name(s, "󰭹")) -- Define o layout da tag de mensagens como magnifier
    awful.tag.setproperty(awful.tag.find_by_name(s, "󰭹"),
        "master_width_factor", 0.9) -- Define o tamanho da janela principal

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    -- s.mytaglist = awful.widget.taglist {
    --     screen  = s,
    --     filter  = awful.widget.taglist.filter.all,
    --     buttons = taglist_buttons,
    --     style   = {
    --         shape = gears.shape.powerline
    --     },
    --     layout  = {
    --         spacing_widget = {
    --             color  = "#dddddd",
    --             shape  = gears.shape.powerline,
    --             widget = wibox.widget.separator,
    --         } },
    -- }
    s.mytaglist = awful.widget.taglist {
        screen          = s,
        filter          = awful.widget.taglist.filter.all,
        style           = {
            shape = gears.shape.powerline,
        },
        layout          = {
            spacing        = -0,
            spacing_widget = {
                color  = beautiful.border_focus,
                widget = wibox.widget.separator,
            },
            layout         = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            {
                                id     = "index_role",
                                widget = wibox.widget.textbox,
                            },
                            margins = 0.1,
                            widget  = wibox.container.margin,
                        },
                        shape  = gears.shape.star,
                        widget = wibox.container.background,
                    },
                    {
                        {
                            id     = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        margins = 5,
                        widget  = wibox.container.margin,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left   = 13,
                right  = 5,
                widget = wibox.container.margin
            },
            id              = "background_role",
            widget          = wibox.container.background,
            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id("index_role")[1].markup = "<b> " .. c3.name .. " </b>"
                self:connect_signal("mouse::enter", function()
                    if self.bg ~= beautiful.bg_urgent then
                        self.backup     = self.bg
                        self.has_backup = true
                    end
                    self.bg = beautiful.bg_urgent
                end)
                self:connect_signal("mouse::leave", function()
                    if self.has_backup then self.bg = self.backup end
                end)
            end,

            update_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id("index_role")[1].markup = "<b> " .. c3.name .. " </b>"
            end,

        },
        buttons         = taglist_buttons
    }
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style   = {
            shape = gears.shape.rounded_rect
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        bg = "#00000000",
        screen = s,
        stretch = false,
        width = 1700,
        height = 65,
        position = "top",
        -- shape = gears.shape.rounded_rect,
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        {
            layout = wibox.layout.align.horizontal,
            spacing = 5,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                --spacing_widget = wibox.widget.separator,
                spacing = 10,
                -- mylauncher,
                s.mytaglist,
                s.mypromptbox,
            },
            { -- Middle widget
                s.mytasklist,
                widget = wibox.container.margin,
                left = 50,
                right = 50,
            },

            { -- Right widgets

                {
                    {
                        {
                            layout = wibox.layout.fixed.horizontal,
                            spacing_widget = wibox.widget.separator,
                            spacing = 10,
                            wibox.widget.systray(),
                            mytextclock,
                            battery.widget,
                            s.mylayoutbox,
                        },
                        widget = wibox.container.place,
                        halign = "center",
                    },
                    widget = wibox.container.margin,
                    left = 10,
                    right = 10,
                    top = 5,
                    bottom = 5,
                },
                widget = wibox.container.background,
                bg = beautiful.bg_normal,
                shape = gears.shape.rounded_rect,
            },
        },
        widget = wibox.container.margin,
        top = 20,
        bottom = 20,
    }
end)
