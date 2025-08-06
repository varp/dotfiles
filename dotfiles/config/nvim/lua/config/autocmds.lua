-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
-- Enable inlay hints globally on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Enable inlay hints",
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
  end,
})
