local map = require('config.utils').map
local nvim_tree = require('nvim-tree.api')



map('n', '<Tab>', nvim_tree.tree.focus)
map('n', '<A-CR>', vim.lsp.buf.code_action)
map('n', 'gD', vim.lsp.buf.declaration)
map('n', 'gd', vim.lsp.buf.definition)
map('n', 'gi', vim.lsp.buf.implementation)
map('n', 'ff', function () vim.lsp.buf.format({async=false}) end)

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
