-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps her
if vim.g.neovide then
  -- Save
  vim.keymap.set("n", "<D-s>", ":w<CR>")

  -- Copy
  vim.keymap.set("v", "<D-c>", '"+y')

  -- Paste for different modes
  vim.keymap.set("n", "<D-v>", '"+P') -- Normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Insert mode
end
