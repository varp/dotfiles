if true then
  return {}
end

-- local defaultLayout = {
--     preset = "dropdown",
--     layout = {
--         backdrop = false,
--         width = 0.9,
--         min_width = 120,
--         height = 0.9,
--         border = "none",
--         box = "vertical",
--         {
--             box = "vertical",
--             border = "rounded",
--             title = "{title} {live} {flags}",
--             title_pos = "center",
--             height = 0.3,
--             { win = "input", height = 1,     border = "bottom" },
--             { win = "list",  border = "none" },
--         },
--         { win = "preview", title = "{preview}", height = 0, border = "rounded" },
--     },
-- }

-- return {
--     {
--         "folke/snacks.nvim",
--         opts = {
--             picker = {
--                 explorer = {
--                 },
--                 layout = defaultLayout,
--                 sources = {
--                     explorer = {
--                     }
--                 }
--             },
--         },
--     },
-- }
--

-- return {
--     "folke/snacks.nvim",
--     --- Apply after LazyVim’s default opts have been resolved
--     opts = function(_, opts)
--         -- ❶ your custom horizontal layout (list | preview)
--         local horizontal    = {
--             layout = {
--                 layout  = { preset = "dropdown", width = 0.90, height = 0.90 }, -- centred 80 × 80 %
--                 preview = { width = 0.70 },                                     -- 50 % of that width for preview
--             },
--         }

--         -- ❷ make sure picker tables exist
--         opts.picker         = opts.picker or {}
--         opts.picker.sources = opts.picker.sources or {}
--         print(opts.picker.sources.explorer)

--         ------------------------------------------------------------------
--         -- ❸ GLOBAL layout: applies to *all* pickers (incl. explorer)…
--         ------------------------------------------------------------------
--         opts.picker.layout           = horizontal.layout -- this sets the new default

--         ------------------------------------------------------------------
--         -- ❹ …then immediately re-set a layout just for the explorer,
--         --    so it keeps its vertical sidebar look.
--         ------------------------------------------------------------------
--         opts.picker.sources.explorer = vim.tbl_deep_extend(
--             "force",
--             -- keep whatever the user already had for explorer …
--             opts.picker.sources.explorer or {},
--             -- …but pin the layout back to the built-in sidebar preset
--             { layout = { preset = "sidebar", preview = true } } -- explorer default  [oai_citation:0‡GitHub](https://github.com/folke/snacks.nvim/issues/1308)
--         )
--     end,
-- }
