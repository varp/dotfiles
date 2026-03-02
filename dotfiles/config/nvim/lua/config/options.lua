-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- neovide specific
if vim.g.neovide then
    vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
end

-- vim
local opt = vim.opt
opt.spell = true
opt.spelllang = { "en_us", "ru_ru" }
opt.guifont = "JetBrainsMono Nerd Font:h13"

opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true

opt.colorcolumn = "120"


opt.title = true
opt.titlestring = "%{fnamemodify(getcwd(), ':t')}: %t %m"


local g = vim.g
g.omni_sql_no_default_maps = 1 -- allow use arrow keys in INSERT mode
