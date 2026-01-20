-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps her
if vim.g.neovide then
  -- Save
  vim.keymap.set("n", "<D-s>", ":w<CR>")
  vim.keymap.set("i", "<D-s>", "<Cmd>write<CR>", { silent = true })

  -- Copy
  vim.keymap.set("v", "<D-c>", '"+y')
  vim.keymap.set("i", "<D-c>", '<ESC>V"+y')

  -- Redo
  vim.keymap.set("n", "<D-z>", "u")
  vim.keymap.set("i", "<D-z>", "<Cmd>undo<CR>", { silent = true })

  -- Paste for different modes
  vim.keymap.set("n", "<D-v>", '"+p') -- Normal mode
  vim.keymap.set("v", "<D-v>", '"+p') -- Visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Command mode
  vim.keymap.set("i", "<D-v>", '<ESC>"+p') -- Insert mode

  -- Edit
  vim.keymap.set("i", "<D-BS>", "<ESC>0Dgi", { silent = true })
  vim.keymap.set("i", "<M-Left>", "<C-Left>")
  vim.keymap.set("i", "<M-Right>", "<C-Right>")
end
