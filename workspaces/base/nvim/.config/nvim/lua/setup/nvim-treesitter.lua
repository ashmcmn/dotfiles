require'nvim-treesitter.configs'.setup {
  ensure_installed = { 'bash', 'c', 'comment', 'cpp', 'css', 'dockerfile', 'hcl', 'html', 'javascript', 'json', 'lua', 'markdown', 'python', 'regex', 'terraform', 'vim', 'yaml' },

  sync_install = true,

  highlight = {
    enable = true,

    additional_vim_regex_highlighting = false,
  },
}
