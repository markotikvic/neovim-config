let mapleader = ";"

call plug#begin()
	Plug 'vim-scripts/AutoComplPop'
	Plug 'kien/ctrlp.vim'
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'tpope/vim-fugitive'
	Plug 'Yggdroot/indentLine'
	Plug 'itchyny/vim-gitbranch'
	Plug 'vv9k/vim-github-dark'
	Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
	Plug 'nanotech/jellybeans.vim'
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
call plug#end()

function! GetVimModeName()
	let s:ShortMode = mode()

	if s:ShortMode == 'n'
		return '[Normal]'
	elseif s:ShortMode == 'i'
		return '[Insert]'
	elseif s:ShortMode == 'v'
		return '[Visual]'
	elseif s:ShortMode == 'V'
		return '[Visual-Block]'
	endif

	return '['.s:ShortMode.']'
endfunc

function! GetGitBranch()
	let s:BranchName = gitbranch#name()

	if s:BranchName != ''
		return '@'.s:BranchName
	endif

	return s:BranchName
endfunc

function! InitIndentation()
	"Indent Line
	let g:indentLine_enabled = 0
	let g:indentLine_char = '¦'
	let g:indentLine_leadingSpaceEnabled = 0
	"Bullet U+2022
	let g:indentLine_leadingSpaceChar = '•'
endfunc

function! InitGeneralOptions()
	filetype plugin indent on

	"For autocomplete
	let g:acp_ignorecaseOption = 0

	"Encoding + General
	set encoding=utf-8
	set autoindent
	set tabstop=8
	set shiftwidth=8
	set noexpandtab
	set number
	set relativenumber
	set nowrap
	"Continue comments on new lines
	set formatoptions+=r
	set nohlsearch
	set incsearch
	"Completion rules
	set wildmode=longest,list,full
	"Status Line
	set cursorline
	"Show only filename (not full path) in status line
	set laststatus=2
	set statusline=%{GetGitBranch()}\ %f%m\ %=\(%{&ff}\)\ %P\ %l/%L\ :%c

	syntax on
	syntax enable
	set guifont=Fira\ Mono\ Regular\ 10

	set hidden

	"Red color for trailing whitespaces
	match ErrorMsg '\s\+$'
endfunc

function! InitTheme()
	set background=dark
	set termguicolors
	"Disable Background Color Erase (BCE) so that color schemes render properly when inside 256-color tmux and GNU screen.
	if &term =~ '256color'
		set t_ut =
	endif
	"colorscheme jellybeans
	colorscheme ghdark
endfunc


function! InitCtrlP()
	let g:ctrlp_map = '<c-p>'
	let g:ctrlp_cmd = 'CtrlP .'
	let g:ctrlp_match_window = 'bottom,order:ttb,min:5,max:25'
	let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)|node_modules|obj|bin|dist$'
endfunc

function! InitFzf()
	" fzf
	nnoremap <leader>a :Buffers<CR>
	nnoremap <leader>z :Files<CR>
endfunc

function! InitGeneralShortcuts()
	"Horizontal split
	map <C-n> :split<CR>
	"Vertical split
	map <C-m> :vsplit<CR>
	map <CR> :vsplit<CR>
	"Previous tab
	map <C-h> :tabprevious<CR>
	"Next tab
	"Freed <C-l> in Netrw
	nmap <leader><leader><leader><leader><leader><leader>l <Plug>NetrwRefresh
	map <C-l> :tabnext<CR>
	"Open file under cursor
	nnoremap <leader>gf <C-w>gf
	"Close current buffer
	nnoremap <C-d> :q<CR>
	"Switch to next buffer in current tab
	nnoremap <tab> <C-w>w

	"Navigate the autocomplete box with <C-j> and <C-k>
	inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "<C-j>"
	inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "<C-k>"
endfunc

function! InitCSharp()
lua <<EOF
	local pid = vim.fn.getpid()
	require('lspconfig').omnisharp.setup({
		on_attach = function(_, bufnr)
			vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
		end,
		cmd = { '/home/markotikvic/.cache/omnisharp-vim/omnisharp-roslyn/run', "--languageserver" , "--hostPID", tostring(pid)};
	})
EOF
	let g:OmniSharp_highlighting = 0
endfunc

function! InitDart()
lua <<EOF
	require('lspconfig').dartls.setup({})
EOF
	let g:lsc_server_commands = {'dart': 'dart_language_server'}
	let g:lsc_enable_autocomplete = v:false
	let g:lsc_auto_map = v:false
	let g:dartfmt_options = ['--fix', '-l 150']
	let g:dart_format_on_save = 1
endfunc

function! InitLSP()
	call InitCSharp()
	call InitDart()
	call InitGo()
	call InitTypeScript()
	call InitWebFormatters()

	nnoremap <leader>fD :lua vim.lsp.buf.declaration()<CR>
	nnoremap <leader>fd :lua vim.lsp.buf.definition()<CR>
	nnoremap <leader>fi :lua vim.lsp.buf.implementation()<CR>
	nnoremap <leader>fr :lua vim.lsp.buf.references()<CR>
	nnoremap <leader>fm :lua vim.lsp.buf.formatting()<CR>
	nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
endfunc

function! InitWebFormatters()
	"JS Beautify
	autocmd FileType javascript command! Fmt :call JsBeautify()
	autocmd FileType json command! Fmt :call JsonBeautify()
	autocmd FileType jsx command! Fmt :call JsxBeautify()
	autocmd FileType html command! Fmt :call HtmlBeautify()
	autocmd FileType css command! Fmt :call CSSBeautify()

	"Velocity (AtlassianSDK)
	au BufRead,BufNewFile *.vm set filetype=velocity
endfunc

function! InitGo()
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

call InitGeneralOptions()
call InitIndentation()
call InitTheme()
call InitLSP()
"call InitCtrlP()
call InitFzf()
call InitGeneralShortcuts()
