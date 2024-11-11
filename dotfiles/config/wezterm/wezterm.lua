-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local action = wezterm.action

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Frappe'
config.font = wezterm.font 'JetBrainsMono Nerd Font Mono'
config.font_size = 16

config.default_cursor_style = 'BlinkingBlock'
config.hide_tab_bar_if_only_one_tab = true
-- config.a

config.keys = {
    --
    -- panes
    --
    {
        key = 'd',
        mods = 'CMD',
        action = action.SplitHorizontal
    },
    {
        key = 'd',
        mods = 'CMD|SHIFT',
        action = action.SplitVertical
    },
    {
        key = 'w',
        mods = 'CTRL|SHIFT',
        action = action.CloseCurrentPane { confirm = false }
    },
    -- swtiching
    {
        key = 'LeftArrow',
        mods = 'CTRL',
        action = action.ActivatePaneDirection 'Left'
    },
    {
        key = 'RightArrow',
        mods = 'CTRL',
        action = action.ActivatePaneDirection 'Right'
    },
    {
        key = 'UpArrow',
        mods = 'CTRL',
        action = action.ActivatePaneDirection 'Up'
    },
    {
        key = 'DownArrow',
        mods = 'CTRL',
        action = action.ActivatePaneDirection 'Down'
    },
    -- sizing
    {
        key = 'LeftArrow',
        mods = 'CTRL|SHIFT',
        action = action.AdjustPaneSize { 'Left', 5 }
    },
    {
        key = 'RightArrow',
        mods = 'CTRL|SHIFT',
        action = action.AdjustPaneSize { 'Right', 5 }
    },
    {
        key = 'UpArrow',
        mods = 'CTRL|SHIFT',
        action = action.AdjustPaneSize { 'Up', 5 }
    },
    {
        key = 'DownArrow',
        mods = 'CTRL|SHIFT',
        action = action.AdjustPaneSize { 'Down', 5 }
    },
    --
    -- spawn
    --
    {
        key = 'd',
        mods = 'CTRL|ALT',
        action = action.SpawnTab 'CurrentPaneDomain'
    },
    --
    -- loauncher/command pallete
    --
    {
        key = 'p',
        mods = 'CMD',
        action = action.ActivateCommandPalette
    },
    {
        key = 'p',
        mods = 'CMD|SHIFT',
        action = action.ShowLauncherArgs {
            flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS|DOMAINS|KEY_ASSIGNMENTS|WORKSPACES|COMMANDS'
        }
    },

    --
    -- tabs
    --
    {
        key = 'LeftArrow',
        mods = 'CMD|ALT',
        action = action.MoveTabRelative(-1)
    },

    {
        key = 'RightArrow',
        mods = 'CMD|ALT',
        action = action.MoveTabRelative(1)
    },


    -- scroll
    {
        key = 'PageDown',
        mods = 'SHIFT',
        action = action.ScrollByPage(1)
    },
    {
        key = 'PageUp',
        mods = 'SHIFT',
        action = action.ScrollByPage(-1)
    },
    {
        key = 'PageDown',
        mods = 'ALT',
        action = action.ScrollByLine(1)
    },
    {
        key = 'PageUp',
        mods = 'ALT',
        action = action.ScrollByLine(-1)
    },
    {
        key = 'Home',
        mods = 'SHIFT',
        action = action.ScrollToTop
    },
    {
        key = 'End',
        mods = 'SHIFT',
        action = action.ScrollToBottom
    },
    -- fonts
    -- remove default key combinations for font size manipulation
    {
        key = '=',
        mods = 'CTRL',
        action = action.DisableDefaultAssignment
    },
    {
        key = '-',
        mods = 'CTRL',
        action = action.DisableDefaultAssignment
    },
    {
        key = '0',
        mods = 'CTRL',
        action = action.DisableDefaultAssignment
    },
    {
        key = '+',
        mods = 'CTRL|SHIFT',
        action = action.DisableDefaultAssignment
    },
    {
        key = '_',
        mods = 'CTRL|SHIFT',
        action = action.DisableDefaultAssignment
    },
    {
        key = ')',
        mods = 'CTRL|SHIFT',
        action = action.DisableDefaultAssignment
    },
    -- new font manipulating key combinations
    {
        key = '+',
        mods = 'CMD|SHIFT',
        action = action.IncreaseFontSize
    },
    {
        key = '_',
        mods = 'CMD|SHIFT',
        action = action.DecreaseFontSize
    },
    {
        key = ')',
        mods = 'CMD|SHIFT',
        action = action.ResetFontSize
    },
    -- line editing/movement
    {
        key = 'Backspace',
        mods = 'ALT',
        action = action.SendKey { key = 'w', mods = 'CTRL' }
    },
    {
        key = 'LeftArrow',
        mods = 'ALT',
        action = action.SendKey { key = 'B', mods = 'ALT' }
    },
    {
        key = 'RightArrow',
        mods = 'ALT',
        action = action.SendKey { key = 'F', mods = 'ALT' }
    },
    {
        key = 'LeftArrow',
        mods = 'CMD',
        action = action.SendKey { key = 'A', mods = 'CTRL' }
    },
    {
        key = 'RightArrow',
        mods = 'CMD',
        action = action.SendKey { key = 'E', mods = 'CTRL' }
    },

}

config.mouse_bindings = {
    -- Ctrl-click will open the link under the mouse cursor
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CMD',
        action = action.OpenLinkAtMouseCursor,
    },
}


-- and finally, return the configuration to wezterm
return config
