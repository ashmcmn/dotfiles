require("nvim-tree").setup({
  view = {
    width = 50,
    mappings = {
      list = {
        { key = "<Tab>", action = "close" },
      },
    },
  },
})
