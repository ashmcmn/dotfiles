-- disable netrw 
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- esc delay fix
if vim.fn.has('gui_running') == 0 then
    vim.opt.ttimeoutlen = 10

    -- Create an autocommand group 'FastEscape'
    vim.api.nvim_exec([[
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
    ]], false)
end

-- required for feline
vim.opt.termguicolors = true

require('config.settings')
require('config.plugins')
require('config.mappings')

-- adjust tabs for nvim-tree
local nvim_tree_events = require('nvim-tree.events')
local bufferline_api = require('bufferline.api')

local function get_tree_size()
  return require'nvim-tree.view'.View.width
end

nvim_tree_events.subscribe('TreeOpen', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
  bufferline_api.set_offset(0)
end)

-- theme
vim.g.gruvbox_material_background = 'soft'

vim.cmd([[colorscheme gruvbox-material]])
