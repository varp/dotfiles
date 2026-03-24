-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- local function set_background_from_macos()
--   if vim.fn.has("mac") == 1 then
--     local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
--     local result = handle:read("*a")
--     handle:close()

--     local bg = result:match("Dark") and "dark" or "light"
--     if vim.o.background ~= bg then
--       vim.o.background = bg
--       return true
--     end
--   end
--   return false
-- end

-- local theme = require("config.theme")
-- theme.apply()

-- vim.api.nvim_create_autocmd({ "FocusGained", "VimEnter" }, {
--   callback = function()
--     if set_background_from_macos() then
--       theme.apply()
--     end
--   end,
-- })

-- vim.api.nvim_create_autocmd("DirChanged", {
--     once = true,
--     callback = function()
--         local env_var = "NEOVIDE_CHDIR" -- имя твоей переменной
--         local value = vim.env[env_var]
--
--         if value and value ~= "" then
--             vim.cmd("tcd " .. vim.fn.fnameescape(value))
--             vim.notify("tcd -> " .. value, vim.log.levels.INFO)
--         end
--         -- если переменная не установлена — молча игнорируем
--     end,
-- })
