return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = {
          preset = "dropdown",
          layout = {
            backdrop = false,
            width = 0.9,
            min_width = 120,
            height = 0.9,
            border = "none",
            box = "vertical",
            {
              box = "vertical",
              border = "rounded",
              title = "{title} {live} {flags}",
              title_pos = "center",
              height = 0.3,
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
            { win = "preview", title = "{preview}", height = 0, border = "rounded" },
          },
        },
      },
    },
  },
}
