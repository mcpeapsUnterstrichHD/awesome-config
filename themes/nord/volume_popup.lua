-- FIX: TÁ MUITO FEIO
local awful              = require "awful"
local gears              = require "gears"
local wibox              = require "wibox"
local beautiful          = require "beautiful"

local current = 0
awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout)
    current = tonumber(stdout) or 0
end)
local max = 100
local popup = nil
local popup_timer = nil

local function popup_function(current_brightness)
    local icon = ""

    if current == 0 then
        icon = "󰝟 "
    elseif current <= 30 then
        icon = " "
    elseif current <= 70 then
        icon = "󰕾 "
    elseif current > 70 then
        icon = " "
    end


    local widget = {
        {
            {
                {
                    text   = icon,
                    widget = wibox.widget.textbox,
                    font   = "sans 50",
                    align  = "center",
                },
                {
                    value            = current_brightness,
                    max_value        = max,
                    forced_height    = 10,
                    forced_width     = 200,
                    color            = beautiful.border_focus,
                    background_color = beautiful.bg_focus,
                    widget           = wibox.widget.progressbar,
                },
                layout = wibox.layout.fixed.vertical,
            },
            widget = wibox.container.place,
            halign = "center",
            valgin = "center",
        },
        widget  = wibox.container.margin,
        margins = 20,
    }
    popup = popup or awful.popup {
        widget         = widget,
        ontop          = true,
        minimum_width  = 200,
        minimum_height = 200,
        placement      = awful.placement.bottom,
    }
    popup:setup(widget)
    popup.visible = true
    if (popup_timer ~= nil) then
        popup_timer:again()
    else
        popup_timer = gears.timer {
            timeout = 2,
            single_shot = true,
            callback = function()
                popup.visible = false
            end,
        }
        popup_timer:start()
    end
end

globalkeys = gears.table.join(globalkeys,
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn("pamixer -i 10")
        awful.spawn("pamixer -u")
        awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout)
            current = tonumber(stdout) or 0
            popup_function(current)
        end)
    end, { description = "Increase Volume", group = "Function keys" }),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn("pamixer -d 10")
        awful.spawn("pamixer -u")
        awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout)
            current = tonumber(stdout) or 0
            popup_function(current)
        end)
    end, { description = "Decrease Volume", group = "Function keys" }),
    awful.key({}, "XF86AudioMute", function()
        awful.spawn("pamixer -t")
        awful.spawn.easy_async_with_shell("pamixer --get-mute", function(stdout)
            -- Se for verdadeiro, consideramos o som com volume igual a zero
            if stdout:find("true") then
                current = 0
                popup_function(current)
            end
            -- Se for falso, consideramos o som como ele é
            if stdout:find("false") then
                current = 0
                awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout2)
                    current = tonumber(stdout2) or 0
                    popup_function(current)
                end)
            end
        end)
    end, { description = "Toggle Mute", group = "Function keys" })
)
