local map = require('config.utils').map
local nvim_tree = require('nvim-tree.api')



map('n', '<Tab>', nvim_tree.tree.focus)


map('i', '<Esc>#', '#')

-- barbar.nvim
-- Move to previous/next
map('n', '<M-,>', ':BufferPrevious<CR>')
map('n', '<M-.>', ':BufferNext<CR>')
-- Re-order to previous/next
map('n', '<M-<>', '<Cmd>BufferMovePrevious<CR>') -- Alt+<
map('n', '<M->>', '<Cmd>BufferMoveNext<CR>')     -- Alt+>
-- Pin/unpin buffer
map('n', '<M-p>', '<Cmd>BufferPin<CR>')          -- Alt+p
-- Close buffer
map('n', '<M-c>', '<Cmd>BufferClose<CR>')        -- Alt+c
