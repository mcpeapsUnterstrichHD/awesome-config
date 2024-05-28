-- FIX: TÁ MUITO FEIO
local awful              = require "awful"
local gears              = require "gears"
local wibox              = require "wibox"
local beautiful          = require "beautiful"

local current_brightness = 0
awful.spawn.easy_async_with_shell("brightnessctl get", function(stdout)
    current_brightness = tonumber(stdout) or 0
end)
local max_brightness = 0
awful.spawn.easy_async_with_shell("brightnessctl max", function(stdout)
    max_brightness = tonumber(stdout) or 0
end)
local brightness_popup = nil
local brightness_popup_timer = nil

local function brightness_popup_function(current_brightness)
    local widget = {
        {
            {
                {
                    text   = '󰃟 ',
                    widget = wibox.widget.textbox,
                    font   = "sans 50",
                    align  = "center",
                },
                {
                    value            = current_brightness,
                    max_value        = max_brightness,
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
    brightness_popup = brightness_popup or awful.popup {
        widget         = widget,
        ontop          = true,
        minimum_width  = 200,
        minimum_height = 200,
        placement      = awful.placement.bottom,
    }
    -- local popup = awful.popup {
    --     widget         = widget,
    --     ontop          = true,
    --     minimum_width  = 200,
    --     minimum_height = 200,
    --     placement      = awful.placement.bottom,
    -- }
    brightness_popup:setup(widget)
    brightness_popup.visible = true
    if (brightness_popup_timer ~= nil) then
        brightness_popup_timer:again()
    else
        brightness_popup_timer = gears.timer {
            timeout = 2,
            single_shot = true,
            callback = function()
                brightness_popup.visible = false
            end,
        }
        brightness_popup_timer:start()
    end
end

globalkeys = gears.table.join(globalkeys,
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn("brightnessctl set 3%+")
        awful.spawn.easy_async_with_shell("brightnessctl get", function(stdout)
            current_brightness = tonumber(stdout) or 0
            brightness_popup_function(current_brightness)
        end)
    end, { description = "Increase Brightness", group = "Function keys" }),
    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn("brightnessctl set 3%-")
        awful.spawn.easy_async_with_shell("brightnessctl get", function(stdout)
            current_brightness = tonumber(stdout) or 0
            brightness_popup_function(current_brightness)
        end)
    end, { description = "Decrease Brightness", group = "Function keys" })
)
