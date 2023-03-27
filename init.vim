let mapleader = ";"

call plug#begin()
	Plug 'vim-scripts/AutoComplPop'
	Plug 'kien/ctrlp.vim'
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'tpope/vim-fugitive'
	Plug 'Yggdroot/indentLine'
	Plug 'itchyny/vim-gitbranch'
	Plug 'EdenEast/nightfox.nvim'
	Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
	Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
	Plug 'jacoborus/tender.vim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'fatih/vim-go'
	Plug 'moll/vim-node'
	Plug 'pangloss/vim-javascript'
	Plug 'maksimr/vim-jsbeautify'
	Plug 'leafgarland/typescript-vim'
	Plug 'dart-lang/dart-vim-plugin'
	Plug 'natebosch/vim-lsc'
	Plug 'natebosch/vim-lsc-dart'
	Plug 'OmniSharp/omnisharp-vim'
	Plug 'lepture/vim-velocity'
	Plug 'rhysd/vim-clang-format'
	Plug 'averms/black-nvim', {'do': ':UpdateRemotePlugins'}
call plug#end()

function! InitIndentation()
	"Indent Line
	let g:indentLine_enabled = 0
	let g:indentLine_char = '¦'
	let g:indentLine_leadingSpaceEnabled = 0
	"Bullet U+2022
	let g:indentLine_leadingSpaceChar = '•'
endfunc

function! StatusLineFormat()
	let spacePipe = "\ \|"
	let fileEncoding = "\ %{&ff}\ %{&fileencoding?&fileencoding:&encoding}"

	let line = ""
	let line .= "%f%m"
	let line .= spacePipe
	let line .= "\ %l:%c"
	let line .= spacePipe
	let line .= "%="
	let line .= "%{gitbranch#name()}"
	let line .= spacePipe
	let line .= fileEncoding
	let line .= spacePipe
	let line .= "\ %P"

	return line
endfunc

function! InitStatusLine()
	"Always show status line
	set laststatus=2
	set statusline=%!StatusLineFormat()
endfunc

function! InitGeneralSettings()
	filetype plugin indent on

	"For autocomplete
	let g:acp_ignorecaseOption = 0

	set encoding=utf-8
	set autoindent
	set tabstop=8
	set shiftwidth=8
	set noexpandtab
	set number
	set relativenumber
	set wrap
	"Continue comments on new lines
	set formatoptions+=r
	set hlsearch
	set incsearch
	"set ignorecase
	"Completion rules
	set wildmode=longest,list,full
	set switchbuf+=usetab,newtab

	"Red color for trailing whitespaces
	match ErrorMsg '\s\+$'
endfunc

function! InitColorScheme()
	set cursorline
	syntax on
	syntax enable
	set guifont=Fira\ Mono\ Medium\ 10
	set hidden
	set background=dark
	set termguicolors
	call InitStatusLine()
	colorscheme tender
endfunc

function! InitCtrlP()
	let g:ctrlp_map = '<c-p>'
	let g:ctrlp_cmd = 'CtrlP .'
	let g:ctrlp_match_window = 'bottom,order:ttb,min:5,max:25'
	let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)|node_modules|obj|bin|dist$'
endfunc

function! InitFzf()
	nnoremap <leader>a :Buffers<CR>
	nnoremap <leader>z :Files<CR>
	nnoremap <leader>l :Lines<CR>
	nnoremap <leader>L :Ag<CR>
	let $FZF_DEFAULT_COMMAND='find . ! -path */build/* ! -path */Debug/* ! -path */bin/* ! -path */obj/* ! -path */node_modules/* -type f'
endfunc

function! InitShortcuts()
	call InitFzf()

	"Navigate the autocomplete box with <C-j> and <C-k>
	inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "<C-j>"
	inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "<C-k>"

	map <C-n> :split<CR>
	map <C-m> :vsplit<CR>
	map <CR> :vsplit<CR>
	nnoremap <leader>gf :only<CR> gf
	nnoremap <C-d> :q<CR>
	nnoremap <leader>c :noh<CR>
	nnoremap <tab> <C-w>w
	"Find matching bracket
	nnoremap <leader>m %
	"Copy to clipboard
	vnoremap <leader>y "+y
	nnoremap <leader>vim :e $MYVIMRC<CR>
	nnoremap <leader>R :source $MYVIMRC<CR>
endfunc

function! InitDotnet()
	autocmd FileType cs call InitLspFormatter()
lua <<EOF
	local pid = vim.fn.getpid()
	local home = vim.fn.getenv('HOME')

	require('lspconfig').omnisharp.setup({
		on_attach = function(_, bufnr)
			vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
		end,
		cmd = { home .. '/.cache/omnisharp-vim/omnisharp-roslyn/run', "--languageserver" , "--hostPID", tostring(pid)};
	})
EOF
	let g:OmniSharp_highlighting = 0
endfunc

function! InitDart()
	autocmd FileType dart call InitLspFormatter()
lua <<EOF
	require('lspconfig').dartls.setup({})
EOF
	let g:lsc_server_commands = {'dart': 'dart_language_server'}
	let g:lsc_enable_autocomplete = v:false
	let g:lsc_auto_map = v:false
	let g:dartfmt_options = ['--fix', '-l 150']
	let g:dart_format_on_save = 1
endfunc

function! InitCpp()
"lua <<EOF
	"require('lspconfig').clangd.setup{
	"}
"EOF
	let g:clang_format#code_style = 'google'
	let g:clang_format#style_options = {
		\ 'IndentWidth' : 2,
		\ 'ColumnLimit' : 160,
		\ 'DerivePointerAlignment' : 'false',
		\ 'SortIncludes' : 'true',
		\ 'IncludeBlocks' : 'Preserve',
		\ 'SpacesBeforeTrailingComments' : 1,
		\ 'SpaceBeforeCpp11BracedList': 'true',
	\ }
endfunc

function! InitLspFormatter()
	nnoremap <leader>fm :lua vim.lsp.buf.formatting()<CR>
endfunc

function! InitLspDiagnostics()
lua <<EOF
	local function setup_diagnostics()
	  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	    vim.lsp.diagnostic.on_publish_diagnostics,
	    {
	      virtual_text = true,
	      signs = true,
	      update_in_insert = false,
	      underline = true,
	    }
	  )
	end

	setup_diagnostics()
EOF
endfunc

function! InitLspShortcuts()
	nnoremap <leader>fD :lua vim.lsp.buf.declaration()<CR>
	nnoremap <leader>fd :lua vim.lsp.buf.definition()<CR>
	nnoremap <leader>fi :lua vim.lsp.buf.implementation()<CR>
	nnoremap <leader>fr :lua vim.lsp.buf.references()<CR>
	nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
	nnoremap <leader>do :lua vim.diagnostic.open_float()<CR>
	nnoremap <leader>ds :lua vim.diagnostic.show()<CR>
	nnoremap <leader>dh :lua vim.diagnostic.hide()<CR>
endfunc

function! InitLsp()
	call InitDotnet()
	call InitDart()
	call InitGo()
	call InitTypeScript()
	call InitPython()
	call InitCpp()
	call InitFormatters()
	call InitLspFormatter()
	call InitLspDiagnostics()
	call InitLspShortcuts()
endfunc

function! InitFormatters()
	"JS Beautify
	autocmd FileType javascript nnoremap <leader>fm :call JsBeautify()<CR>
	autocmd FileType json nnoremap <leader>fm :call JsonBeautify()<CR>
	autocmd FileType jsx nnoremap <leader>fm :call JsxBeautify()<CR>
	autocmd FileType html nnoremap <leader>fm :call HtmlBeautify()<CR>
	autocmd FileType css nnoremap <leader>fm :call CSSBeautify()<CR>
	autocmd FileType cpp nnoremap <leader>fm :ClangFormat<CR>

	"Velocity (AtlassianSDK)
	au BufRead,BufNewFile *.vm set filetype=velocity
endfunc

function! InitGo()
	autocmd FileType go call InitLspFormatter()
lua <<EOF
	require('lspconfig').gopls.setup{}
EOF
	"Stop scratch window from opening (gocode->neocomplete)
	set completeopt-=preview
	"Run go imports on save
	let g:go_fmt_command = "goimports"
endfunc

function! InitTypeScript()
	let g:typescript_compiler_binary = 'tsc --noEmit'
endfunc

function! InitPython()
	let g:python3_host_prog = '/usr/bin/python3'
	let g:black_use_virtualenv = 0
	autocmd FileType python nnoremap <leader>fm :call Black()<CR>
	let g:black#settings = {
	    \ 'fast': 1,
	    \ 'line_length': 100
	\}
endfunc

call InitGeneralSettings()
call InitIndentation()
call InitColorScheme()
call InitLsp()
call InitShortcuts()
