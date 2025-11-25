require('nightfox').setup({
    options = {
        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
        compile_file_suffix = "_compiled", -- Compiled file suffix
        transparent = true,                -- Disable setting background
        terminal_colors = true,            -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
        dim_inactive = false,              -- Non focused panes set to alternative background
    },
})

vim.cmd("colorscheme carbonfox")

--[[
local decay = require("decay")

local opt = vim.opt
local cmd = vim.cmd

opt.background = "dark"

decay.setup({
  style = "default",

  italics = {
    code = true,
    comments = true,
  },
  nvim_tree = {
    contrast = true
  },
})
vim.cmd.colorscheme "decayce"
]]
--[[
require("colorbuddy").colorscheme('gruvbuddy')
local colorbuddy = require('colorbuddy')
local Color = colorbuddy.Color
local Group = colorbuddy.Group
local c = colorbuddy.colors
local g = colorbuddy.groups

local s = colorbuddy.styles

-- Base Colors
Color.new('background', '#000000')     -- Dark navy background
Color.new('foreground', '#a9b1d6')     -- Pale lavender text
Color.new('cursor', '#c0caf5')         -- Bright lavender cursor

-- Background Variants
Color.new('contrast', '#16161e')       -- Darker background
Color.new('lighter', '#24283b')        -- Lighter panel
Color.new('cursorline', '#292e42')     -- Cursor line highlight
Color.new('statusline_bg', '#1f2335')  -- Status line background

-- Syntax Colors
Color.new('red', '#f7768e')           -- Error/important
Color.new('pink', '#ff75a0')          -- Special
Color.new('orange', '#ff9e64')        -- Warning/numbers
Color.new('yellow', '#e0af68')        -- Constants
Color.new('green', '#9ece6a')         -- Strings
Color.new('blue', '#7aa2f7')         -- Functions
Color.new('teal', '#73daca')          -- Special
Color.new('cyan', '#7dcfff')          -- Tags
Color.new('purple', '#bb9af7')        -- Keywords

-- UI Elements
Color.new('comments', '#565f89')      -- Comments
Color.new('black', '#000000')         -- Pure background
Color.new('white', '#c0caf5')         -- Bright text
Color.new('lavender', '#b4f9f8')      -- Special highlight
Color.new('accent', '#7aa2f7')        -- Primary accent (blue)

-- Additional Tokyo Night Colors
Color.new('magenta', '#db4b4b')       -- Deprecated
Color.new('violet', '#9d7cd8')       -- Special
Color.new('dark_red', '#db4b4b')     -- Error
]]
