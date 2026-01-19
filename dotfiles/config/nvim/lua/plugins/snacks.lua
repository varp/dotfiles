local customVertical = {
  layout = {
    backdrop = false,
    width = 0.9,
    min_width = 60,
    height = 0.9,
    min_height = 40,
    box = "vertical",
    border = true,
    title = "{title} {live} {flags}",
    title_pos = "center",
    { win = "input", height = 1, border = "bottom" },
    { win = "list", border = "none", height = 10 },
    { win = "preview", title = "{preview}", border = "top" },
  },
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = function(source)
          if source ~= "explorer" then
            return customVertical
          end
        end,
      },
    },
  },
}
