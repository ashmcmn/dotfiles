local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local function get_setup(file_name)
    return string.format('require("setup/%s")', file_name)
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = {'nvim-lua/plenary.nvim'}
  }
  use 'romgrk/barbar.nvim'
  use {
    'nvim-tree/nvim-tree.lua',
    config = get_setup('nvim-tree'),
    requires = {'nvim-tree/nvim-web-devicons'}
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }
  use { 
    'sindrets/diffview.nvim', 
    requires = 'nvim-lua/plenary.nvim' 
  }
  use {
    'feline-nvim/feline.nvim',
    config = get_setup('feline')
  }
  use 'kvrohit/substrata.nvim'
  
  use {
    'jedrzejboczar/possession.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  -- LSPs
  use 'SmiteshP/nvim-navic'
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = get_setup('lspconfig'),
  }

    use {
    'nvim-treesitter/nvim-treesitter',
    config = get_setup('nvim-treesitter'),
    run = ':TSUpdate'
  }
  use {
    'RishabhRD/nvim-cheat.sh',
    requires = {'RishabhRD/popfix'}
  }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use {
    "hrsh7th/nvim-cmp",
    config = get_setup('nvim-cmp')
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
