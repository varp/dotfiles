local M = {}

M.dark = "tokyonight-moon"
M.light = "tokyonight-day"

function M.apply()
  if vim.o.background == "dark" then
    vim.cmd.colorscheme(M.dark)
  else
    vim.cmd.colorscheme(M.light)
  end
end

return M
