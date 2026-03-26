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
opt.list = false


-- spellchecker
opt.spell = true
opt.spelllang = { "en_us", "ru" }
opt.spelloptions:append("camel")

local spell_augroup = vim.api.nvim_create_augroup("ProjectSpellFile", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
    group = spell_augroup,
    callback = function()
        local current_file = vim.api.nvim_buf_get_name(0)
        if current_file == "" then return end

        local start_dir = vim.fn.fnamemodify(current_file, ":p:h")
        local global_spell = vim.fn.stdpath("config") .. "/spell/global.utf-8.add"

        local found_markers = vim.fs.find({ '.nvim', '.vscode' }, {
            upward = true,
            stop = vim.loop.os_homedir(), -- Останавливаем поиск на домашней директории
            path = start_dir,
        })

        if #found_markers > 0 then
            local project_config_dir = found_markers[1]
            local local_spell = project_config_dir .. "/spell.utf-8.add"

            vim.fn.mkdir(project_config_dir, "p")

            vim.opt_local.spellfile = { local_spell, global_spell }
        else
            vim.fn.mkdir(vim.fn.fnamemodify(global_spell, ":p:h"), "p")
            vim.opt_local.spellfile = { global_spell }
        end
    end,
})

-- other
local g = vim.g
g.omni_sql_no_default_maps = 1 -- allow use arrow keys in INSERT mode
