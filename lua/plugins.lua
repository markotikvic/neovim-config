vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'vim-scripts/AutoComplPop'
	use 'junegunn/fzf'
	use 'junegunn/fzf.vim'
	use 'tpope/vim-fugitive'
	use 'itchyny/vim-gitbranch'
	use 'jacoborus/tender.vim'
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
end)