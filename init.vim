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
	"Plug 'averms/black-nvim', {'do': ':UpdateRemotePlugins'}
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

hi StatusLineBaseStyle guibg=#494949 guifg=#61C8C6
hi StatusLineBoldStyle guibg=#494949 guifg=#61C8C6 gui=bold
hi StatusLineInactiveStyle guibg=#000000 guifg=#FFFFFF

function! ActiveStatusLine()
	let line = ""
	let line .= "%#StatusLineBoldStyle#"
	let line .= "%f%m"
	let line .= "%#StatusLineBaseStyle#"
	let line .= "\ \|"
	let line .= "\ %l:%c"
	let line .= "\ \|"
	let line .= "%="
	let line .= "%#StatusLineBoldStyle#"
	let line .= "%{GetGitBranch()}"
	let line .= "%#StatusLineBaseStyle#"
	let line .= "\ \|"
	let line .= "\ %{&ff}"
	let line .= "\ \|"
	let line .= "\ %P"
	return line
endfunc

function! InactiveStatusLine()
	return "%#StatusLineInactiveStyle#%f%m"
endfunc

function! InitStatusLine()
	"Always show status line
	set laststatus=2

	augroup Statusline
		autocmd!
		autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveStatusLine()
		autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveStatusLine()
	augroup END
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
	set wrap
	"Continue comments on new lines
	set formatoptions+=r
	set hlsearch
	set incsearch
	set ignorecase
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
	"colorscheme nightfox
	colorscheme catppuccin-mocha
	call InitStatusLine()
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

function! InitShortcuts()
	"Horizontal split
	map <C-n> :split<CR>
	"Vertical split
	map <C-m> :vsplit<CR>
	map <CR> :vsplit<CR>
	"Previous tab
	map <C-h> :tabprevious<CR>
	"Free <C-l> in Netrw
	nmap <leader><leader><leader><leader><leader><leader>l <Plug>NetrwRefresh
	"Next tab
	map <C-l> :tabnext<CR>
	"Open file under cursor
	nnoremap <leader>gf :only<CR> gf
	"Close current buffer
	nnoremap <C-d> :q<CR>
	"Clear highlight
	nnoremap <leader>c :noh<CR>
	"Switch to next buffer in current tab
	nnoremap <tab> <C-w>w
	"Navigate the autocomplete box with <C-j> and <C-k>
	inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "<C-j>"
	inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "<C-k>"
	"Find matching bracket
	nnoremap <leader>m %
	"Copy to clipboard
	vnoremap <leader>y "+y
endfunc

function! InitCSharp()
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
	"require('lspconfig').clangd.setup{}
"EOF
	let g:clang_format#style_options =  {"IndentWidth" : 2, "ColumnLimit" : 120}
endfunc

function! InitLspFormatter()
	nnoremap <leader>fm :lua vim.lsp.buf.formatting()<CR>
endfunc

function! InitLSP()
	call InitCSharp()
	call InitDart()
	call InitGo()
	call InitTypeScript()
	call InitFormatters()
	call InitCpp()
	call InitLspFormatter()

	nnoremap <leader>fD :lua vim.lsp.buf.declaration()<CR>
	nnoremap <leader>fd :lua vim.lsp.buf.definition()<CR>
	nnoremap <leader>fi :lua vim.lsp.buf.implementation()<CR>
	nnoremap <leader>fr :lua vim.lsp.buf.references()<CR>
	nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
	nnoremap <leader>do :lua vim.diagnostic.open_float()<CR>
	nnoremap <leader>ds :lua vim.diagnostic.show()<CR>
	nnoremap <leader>dh :lua vim.diagnostic.hide()<CR>

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
	autocmd FileType py nnoremap <leader>fm :call Black()<CR>
	let g:black#settings = {
	    \ 'fast': 1,
	    \ 'line_length': 100
	\}
endfunc

call InitGeneralOptions()
call InitIndentation()
call InitColorScheme()
call InitLSP()
"call InitCtrlP()
call InitFzf()
call InitShortcuts()
call InitPython()
