local M = {}

M.dark = "tokyonight-night"
M.light = "tokyonight-night"

function M.apply()
  if vim.o.background == "dark" then
    vim.cmd.colorscheme(M.dark)
  else
    vim.cmd.colorscheme(M.light)
  end
end

return M
