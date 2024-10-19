local wezterm = require('wezterm')

local config = {
   --  font = wezterm.font {
   --      family = "JetBrainsMono Nerd Font",
   --      -- family = "Monaspace Neon",
   --      weight = 'Regular',   -- default = regular
   --      -- harfbuzz_features = { "calt=1", "clig=0"},
   --  },
   font = wezterm.font(
        "JetBrainsMono Nerd Font",
        { weight = 'Regular' }
    ),
    bold_brightens_ansi_colors = false,
    -- dpi = 144.0,
    -- freetype_load_target = "Normal",
    -- freetype_render_target = "HorizontalLcd",

    color_scheme = 'Catppuccin Mocha',

    enable_tab_bar = false,
	font_size = 16.0,

    macos_window_background_blur = 30,

    window_background_opacity = 1.0,

    window_decorations = 'RESIZE',

    keys = {
		{
			key = 'f',
			mods = 'CTRL',
			action = wezterm.action.ToggleFullScreen,
		},
		{
			key = '\'',
			mods = 'CTRL',
			action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
		},
	},
    mouse_bindings = {
        -- Ctrl-click will open the link under the mouse cursor
        {
          event = { Up = { streak = 1, button = 'Left' } },
          mods = 'CTRL',
          action = wezterm.action.OpenLinkAtMouseCursor,
        },
    },
}

return config
