vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'vim-scripts/AutoComplPop'
	use 'junegunn/fzf'
	use 'junegunn/fzf.vim'
	use 'tpope/vim-fugitive'
	use 'itchyny/vim-gitbranch'
  use { "catppuccin/nvim", as = "catppuccin" }
	use 'morhetz/gruvbox'
	use 'akinsho/toggleterm.nvim'
	use 'neovim/nvim-lspconfig'
	use 'fatih/vim-go'
	use 'moll/vim-node'
	use 'pangloss/vim-javascript'
	use 'maksimr/vim-jsbeautify'
	use 'leafgarland/typescript-vim'
	use 'dart-lang/dart-vim-plugin'
	use 'natebosch/vim-lsc'
	use 'natebosch/vim-lsc-dart'
	use 'OmniSharp/omnisharp-vim'
	use 'rhysd/vim-clang-format'
	use 'averms/black-nvim'
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'udalov/kotlin-vim'
  use { 'bluz71/vim-moonfly-colors', as = 'moonfly' }
  use "lukas-reineke/indent-blankline.nvim"
  use "rust-lang/rust.vim"
end)
