vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use { 'vim-scripts/AutoComplPop' }
	use { 'junegunn/fzf' }
	use { 'junegunn/fzf.vim' }
	use { 'tpope/vim-fugitive' }
	use { 'itchyny/vim-gitbranch' }
	use { 'akinsho/toggleterm.nvim' }
	use { 'neovim/nvim-lspconfig' }
	use { 'fatih/vim-go' }
	use { 'moll/vim-node' }
	use { 'pangloss/vim-javascript' }
	use { 'maksimr/vim-jsbeautify' }
	use { 'leafgarland/typescript-vim' }
	use { 'dart-lang/dart-vim-plugin' }
	use { 'natebosch/vim-lsc' }
	use { 'natebosch/vim-lsc-dart' }
	use { 'OmniSharp/omnisharp-vim' }
	use { 'rhysd/vim-clang-format' }
	use { 'averms/black-nvim' }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { 'udalov/kotlin-vim' }
  use { "rust-lang/rust.vim" }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use { 'bluz71/vim-moonfly-colors', as = 'moonfly' }
	use { 'ellisonleao/gruvbox.nvim' }
  use { "loctvl842/monokai-pro.nvim" }
  use { "ziglang/zig.vim" }
  use { "peterhoeg/vim-qml", as = "vim-qml" }
  use { 'rktjmp/lush.nvim'}
  use { "metalelf0/jellybeans-nvim" }
  use { "EdenEast/nightfox.nvim" }
  use { "shaunsingh/nord.nvim" }
  use { "drewxs/ash.nvim" }
  use { "cocopon/iceberg.vim" }
  use { "nvim-treesitter/nvim-treesitter" }
  use { "zenbones-theme/zenbones.nvim" }
  use { "catppuccin/nvim", as = "catppuccin" }
  use { "kvrohit/rasmus.nvim" }
  use { "maxmx03/solarized.nvim" }
  use { "kyazdani42/blue-moon" }
  use { 'projekt0n/github-nvim-theme' }
  use { "rebelot/kanagawa.nvim" }
  use { "wtfox/jellybeans.nvim" }
  use { "sainnhe/sonokai" }
end)
