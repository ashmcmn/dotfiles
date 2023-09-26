local servers = {
  bashls,
  clangd,
  dockerls,
  groovyls,
  marksman,
  jedi_language_server,
  ruff_lsp,
  sumneko_lua,
  terraformls,
  tsserver,
  yamlls
}

local navic = require("nvim-navic")

local default_on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  local bufopts = {noremap = true, silent = true, buffer = bufnr}

  vim.keymap.set('n', '<F1>', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<A-CR>', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('x', '<A-CR>', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'ff', function() vim.lsp.buf.format {async = true} end, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
end

local default_lsp_config = {
    on_attach = default_on_attach,
}

local function extend_config(tbl)
    return vim.tbl_deep_extend('force', default_lsp_config, tbl)
end

local lspconfig = require('lspconfig')

local handlers = {
  function (server_name)
    lspconfig[server_name].setup(default_lsp_config)
  end,
  ["tsserver"] = function ()
    lspconfig.tsserver.setup(extend_config({
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        default_on_attach(client, bufnr)
      end
    }))
  end,
  ["yamlls"] = function ()
    lspconfig.yamlls.setup(extend_config({
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        default_on_attach(client, bufnr)
      end
    }))
  end,
}

require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = servers,
  handlers = handlers,
})

vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])

