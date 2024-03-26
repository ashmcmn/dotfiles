local map = require('config.utils').map

local function on_attach_fn(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', '<Tab>', api.tree.close,        opts('Close'))
end

require("nvim-tree").setup({
  view = {
    width = 50,
  },
  on_attach = on_attach_fn,
})
