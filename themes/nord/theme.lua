---------------------------------------------------------------
-- Nord personalizado por mim, utilizei a paleta de cores de --
--     https://www.nordtheme.com/docs/colors-and-palettes    --
---------------------------------------------------------------

local theme_assets     = require("beautiful.theme_assets")
local xresources       = require("beautiful.xresources")
local dpi              = xresources.apply_dpi
local awful            = require("awful")

local gfs              = require("gears.filesystem")
local themes_path      = gfs.get_configuration_dir() .. "themes/"

local theme            = {}

theme.font             = "CaskaydiaCove 11"

theme.bg_normal        = "#3b4252"
theme.bg_focus         = "#5e81ac"
theme.bg_urgent        = "#bf616a"
theme.bg_minimize      = "#444444"

theme.fg_normal        = "#aaaaaa"
theme.fg_focus         = "#d8dee9"
theme.fg_urgent        = "#ffffff"
theme.fg_minimize      = "#ffffff"

theme.useless_gap      = dpi(0)
theme.border_width     = dpi(5)
theme.border_normal    = "#000000"
theme.border_focus     = "#81a1c1"
theme.border_marked    = "#91231c"
--
-- Tasklist:
theme.tasklist_spacing = 15


-- Minimizado
theme.tasklist_bg_minimize             = "#d8dee9"
theme.tasklist_fg_minimize             = "#000000"

-- Cores da taglist (workspaces)
theme.taglist_bg_urgent                = theme.bg_urgent
theme.taglist_bg_occupied              = theme.bg_normal
theme.taglist_shape_border_width_empty = 1
theme.taglist_shape_border_color_empty = theme.bg_normal


-- Generate taglist squares:
local taglist_square_size                       = dpi(4)
theme.taglist_squares_sel                       = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel                     = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

theme.menu_submenu_icon                         = themes_path .. "nord/submenu.png"
theme.menu_height                               = dpi(15)
theme.menu_width                                = dpi(100)

-- Define the image to load
theme.titlebar_close_button_normal              = themes_path .. "nord/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = themes_path .. "nord/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal           = themes_path .. "nord/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = themes_path .. "nord/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive     = themes_path .. "nord/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = themes_path .. "nord/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = themes_path .. "nord/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = themes_path .. "nord/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = themes_path .. "nord/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = themes_path .. "nord/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = themes_path .. "nord/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = themes_path .. "nord/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = themes_path .. "nord/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = themes_path .. "nord/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = themes_path .. "nord/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = themes_path .. "nord/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "nord/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "nord/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path .. "nord/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path .. "nord/titlebar/maximized_focus_active.png"

theme.wallpaper                                 = themes_path .. "nord/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh                              = themes_path .. "nord/layouts/fairhw.png"
theme.layout_fairv                              = themes_path .. "nord/layouts/fairvw.png"
theme.layout_floating                           = themes_path .. "nord/layouts/floatingw.png"
theme.layout_magnifier                          = themes_path .. "nord/layouts/magnifierw.png"
theme.layout_max                                = themes_path .. "nord/layouts/maxw.png"
theme.layout_fullscreen                         = themes_path .. "nord/layouts/fullscreenw.png"
theme.layout_tilebottom                         = themes_path .. "nord/layouts/tilebottomw.png"
theme.layout_tileleft                           = themes_path .. "nord/layouts/tileleftw.png"
theme.layout_tile                               = themes_path .. "nord/layouts/tilew.png"
theme.layout_tiletop                            = themes_path .. "nord/layouts/tiletopw.png"
theme.layout_spiral                             = themes_path .. "nord/layouts/spiralw.png"
theme.layout_dwindle                            = themes_path .. "nord/layouts/dwindlew.png"
theme.layout_cornernw                           = themes_path .. "nord/layouts/cornernww.png"
theme.layout_cornerne                           = themes_path .. "nord/layouts/cornernew.png"
theme.layout_cornersw                           = themes_path .. "nord/layouts/cornersww.png"
theme.layout_cornerse                           = themes_path .. "nord/layouts/cornersew.png"


-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme   = nil

-- Change theme of all kitty sessions
awful.spawn.with_shell("kitten themes --reload-in=all 'Nord'")

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
