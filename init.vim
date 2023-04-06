let mapleader = ";"

call plug#begin()
	Plug 'vim-scripts/AutoComplPop'
	Plug 'kien/ctrlp.vim'
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'tpope/vim-fugitive'
	Plug 'Yggdroot/indentLine'
	Plug 'itchyny/vim-gitbranch'
	Plug 'jacoborus/tender.vim'
	Plug 'morhetz/gruvbox'
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
	let g:indentLine_enabled = 0
	let g:indentLine_char = '¦'
	let g:indentLine_leadingSpaceEnabled = 0
	"Bullet U+2022
	let g:indentLine_leadingSpaceChar = '•'
endfunc

function! LongModeName()
	let modes = {
	\ 'n': 'NORMAL',
	\ 'v': 'VISUAL',
	\ 'V': 'V·LINE',
	\ 's': 'SELECT',
	\ 'S': 'S·LINE',
	\ 'i': 'INSERT',
	\ 'R': 'REPLACE',
        \ 'Rv': 'V·REPLACE',
	\ 'c': 'COMMAND',
	\ 't': 'TERMINAL',
	\}

	let m = mode()
	if has_key(modes, m)
		return modes[m]
	endif

	return m
endfunc

function! StatusLineFormat()
	let spacePipe = "\ \|\ "
	let fileEncoding = "%{&ff}\ %{&fileencoding?&fileencoding:&encoding}"

	let line = " %{LongModeName()}"
	let line .= spacePipe
	let line .= "%f%m"
	let line .= "%="
	let line .= "%{gitbranch#name()}"
	let line .= spacePipe
	let line .= fileEncoding
	let line .= spacePipe
	let line .= "%l:%c"
	let line .= spacePipe
	let line .= "%P "

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
lua <<EOF
	vim.o.encoding = "utf-8"
	vim.o.autoindent = true
	vim.o.tabstop = 8
	vim.o.shiftwidth = 8
	vim.o.expandtab = false
	vim.o.number = true
	vim.o.relativenumber = true
	vim.o.wrap = true
	--Continue comments on new lines
	vim.o.formatoptions = vim.o.formatoptions.."r"
	vim.o.hlsearch = true
	vim.o.incsearch = true
	--vim.o.ignorecase = true
	--Completion rules
	vim.o.wildmode = "longest,list,full"
	vim.o.switchbuf = vim.o.switchbuf..",usetab,newtab"
	--Red color for trailing whitespaces
	vim.cmd([[ match ErrorMsg '\s\+$' ]])
EOF
endfunc

function! InitColorScheme()
lua <<EOF
	vim.o.cursorline = true
	vim.o.guifont = "Fira Mono Medium 10"
	vim.o.hidden = true
	vim.o.background = "dark"
	vim.o.termguicolors = true
	vim.cmd([[
		syntax on
		syntax enable
		let g:gruvbox_contrast_dark = "hard"
		colorscheme gruvbox
	]])
EOF
	call InitStatusLine()
endfunc

function! InitCtrlP()
	let g:ctrlp_map = '<c-p>'
	let g:ctrlp_cmd = 'CtrlP .'
	let g:ctrlp_match_window = 'bottom,order:ttb,min:5,max:25'
	let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)|node_modules|obj|bin|dist$'
endfunc

function! InitFzf()
lua <<EOF
	vim.keymap.set('n', '<leader>a', '<cmd>Buffers<cr>')--nnoremap <leader>a :Buffers<CR>
	vim.keymap.set('n', '<leader>z', '<cmd>Files<cr>')--nnoremap <leader>z :Files<CR>
	vim.keymap.set('n', '<leader>l', '<cmd>Lines<cr>')--nnoremap <leader>l :Lines<CR>
	vim.keymap.set('n', '<leader>L', '<cmd>Ag<cr>')--nnoremap <leader>L :Ag<CR>
EOF
	let g:fzf_preview_window = []
	let $FZF_DEFAULT_COMMAND='find . ! -path */build/* ! -path */Debug/* ! -path */bin/* ! -path */obj/* ! -path */node_modules/* -type f'
endfunc

function! InitShortcuts()
lua <<EOF
	--Navigate the autocomplete box with <C-j> and <C-k>
	vim.keymap.set('i', '<c-j>', function()
		if vim.fn.pumvisible() == 1 then return '<c-n>' end
		return '<c-j>'
	end, { expr = true, noremap = true })

	vim.keymap.set('i', '<c-k>', function()
		if vim.fn.pumvisible() == 1 then return '<c-p>' end
		return '<c-k>'
	end, { expr = true, noremap = true })

	vim.keymap.set('n', '<c-n>', '<cmd>split<cr>') --map <C-n> :split<CR>
	vim.keymap.set('n', '<c-m>', '<cmd>vsplit<cr>') --map <C-m> :vsplit<CR>
	vim.keymap.set('n', '<cr>', '<cmd>vsplit<cr>') --mandatory in order for c-m to work in neovim
	vim.keymap.set('n', '<leader>gf', '<cmd>only<cr> gf') --nnoremap <leader>gf :only<CR> gf
	vim.keymap.set('n', '<c-d>', '<cmd>q<cr>') --nnoremap <C-d> :q<CR>
	vim.keymap.set('n', '<leader>c', '<cmd>noh<cr>') --nnoremap <leader>c :noh<CR>
	vim.keymap.set('n', '<tab>', '<c-w>w') --nnoremap <tab> <C-w>w
	vim.keymap.set('n', '<leader>m', '%') --nnoremap <leader>m %
	vim.keymap.set('n', '<leader>y', '"+y') --vnoremap <leader>y "+y -- copy to clipboard
	vim.keymap.set('n', '<leader>vim', '<cmd>e $MYVIMRC<cr>') --nnoremap <leader>vim :e $MYVIMRC<CR>
	vim.keymap.set('n', '<leader>re', '<cmd>source $MYVIMRC<cr>') --nnoremap <leader>R :source $MYVIMRC<CR>
EOF
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
	"nnoremap <leader>fm :lua vim.lsp.buf.formatting()<CR>
lua <<EOF
	vim.keymap.set('n', '<leader>fm', vim.lsp.buf.formatting)
EOF
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
lua <<EOF
	vim.keymap.set('n', '<leader>fD', vim.lsp.buf.declaration)
	vim.keymap.set('n', '<leader>fd', vim.lsp.buf.definition)
	vim.keymap.set('n', '<leader>fi', vim.lsp.buf.implementation)
	vim.keymap.set('n', '<leader>fr', vim.lsp.buf.references)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
	vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
	vim.keymap.set('n', '<leader>ds', vim.diagnostic.show)
	vim.keymap.set('n', '<leader>dh', vim.diagnostic.hide)
EOF
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
call InitFzf()
call InitShortcuts()
