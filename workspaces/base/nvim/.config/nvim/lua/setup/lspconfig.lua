local servers = {
  'bashls',
  'clangd',
  'dockerls',
  'groovyls',
  'marksman',
  'jedi_language_server',
  'ruff_lsp',
  'sumneko_lua',
  'terraformls',
  'tsserver',
  'yamlls'
}

require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = servers
})

local navic = require("nvim-navic")

local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

local lspconfig = require('lspconfig')

require('mason-lspconfig').setup_handlers({
  function(server_name)
    local opts = {
      on_attach = on_attach,
    }
    
    lspconfig[server_name].setup(opts)
  end,
})

vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
