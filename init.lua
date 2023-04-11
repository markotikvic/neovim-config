require("plugins")

vim.g.mapleader = ";"

function initPython()
	vim.cmd([[
		let g:python3_host_prog = $HOME . '/.local/venv/nvim/bin/python'
		let g:black#settings = {
		    \ 'fast': 1,
		    \ 'line_length': 100
		\}
	]])
end

function initIndentation()
	vim.cmd([[
		let g:indentLine_enabled = 0
		let g:indentLine_char = '¦'
		let g:indentLine_leadingSpaceEnabled = 0
		"Bullet U+2022
		let g:indentLine_leadingSpaceChar = '•'
	]])
end

function getLongModeName()
	local modes = {}

	modes['n'] = 'NORMAL'
	modes['v'] = 'VISUAL'
	modes['V'] = 'V·LINE'
	modes['s'] = 'SELECT'
	modes['S'] = 'S·LINE'
	modes['i'] = 'INSERT'
	modes['R'] = 'REPLACE'
	modes['Rv'] = 'V·REPLACE'
	modes['c'] = 'COMMAND'
	modes['t'] = 'TERMINAL'

	local m = vim.fn.mode()

	for k,v in pairs(modes) do
		if k == m then
			return v
		end
	end

	return m
end

function getStatusLineFormat()
	local spacePipe = " | "

	local line = " "..getLongModeName()
	line = line..spacePipe
	line = line.."%f%m"
	line = line.."%="
	line = line..">> "..vim.call("gitbranch#name").." <<"
	line = line..spacePipe
	line = line..vim.opt.ff:get().." "..vim.opt.encoding:get()
	line = line..spacePipe
	line = line.."%l:%c"
	line = line..spacePipe
	line = line.."%P "

	return line
end

function initStatusLine()
	vim.o.laststatus=2
	vim.o.statusline=getStatusLineFormat()
end

function initGeneralSettings()
	vim.cmd([[
		filetype plugin indent on
		let g:acp_ignorecaseOption = 0
	]])
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
end

function initColorScheme()
	vim.o.cursorline = true
	vim.o.guifont = "Fira Mono Medium 10"
	vim.o.hidden = true
	vim.o.background = "dark"
	vim.o.termguicolors = true
	vim.o.syntax = "on"
	vim.o.syntax = "enable"
	vim.cmd([[
		let g:gruvbox_contrast_dark = "hard"
		colorscheme gruvbox
	]])
	initStatusLine()
end

function initCtrlP()
	vim.cmd([[
		let g:ctrlp_map = '<c-p>'
		let g:ctrlp_cmd = 'CtrlP .'
		let g:ctrlp_match_window = 'bottom,order:ttb,min:5,max:25'
		let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)|node_modules|obj|bin|dist$'
	]])
end

function initFzf()
	vim.keymap.set('n', '<leader>a', '<cmd>Buffers<cr>')--nnoremap <leader>a :Buffers<CR>
	vim.keymap.set('n', '<leader>z', '<cmd>Files<cr>')--nnoremap <leader>z :Files<CR>
	vim.keymap.set('n', '<leader>s', '<cmd>Lines<cr>')--nnoremap <leader>l :Lines<CR>
	vim.keymap.set('n', '<leader>F', '<cmd>Ag<cr>')--nnoremap <leader>L :Ag<CR>
	vim.cmd([[
		let g:fzf_preview_window = []
		let $FZF_DEFAULT_COMMAND='find . ! -path */build/* ! -path */Debug/* ! -path */bin/* ! -path */obj/* ! -path */node_modules/* -type f'
	]])
end

function initShortcuts()
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
	vim.keymap.set('v', '<leader>y', '"+y') --vnoremap <leader>y "+y -- copy to clipboard
	vim.keymap.set('n', '<leader>vim', '<cmd>e $MYVIMRC<cr>') --nnoremap <leader>vim :e $MYVIMRC<CR>
	vim.keymap.set('n', '<leader>re', '<cmd>source $MYVIMRC<cr>') --nnoremap <leader>R :source $MYVIMRC<CR>
	vim.keymap.set('n', '<leader>re', '<cmd>source $MYVIMRC<cr>') --nnoremap <leader>R :source $MYVIMRC<CR>
	vim.keymap.set('n', '<leader>t', '<cmd>ToggleTerm<cr>') --nnoremap <leader>R :source $MYVIMRC<CR>
end

function initDotnet()
	local pid = vim.fn.getpid()
	local home = vim.fn.getenv('HOME')

	require('lspconfig').omnisharp.setup({
		on_attach = function(_, bufnr)
			vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
		end,
		cmd = { home .. '/.cache/omnisharp-vim/omnisharp-roslyn/run', "--languageserver" , "--hostPID", tostring(pid)};
	})
	vim.cmd([[ let g:OmniSharp_highlighting = 0 ]])
end

function initDart()
	require('lspconfig').dartls.setup({})
	vim.cmd([[
		let g:lsc_server_commands = {'dart': 'dart_language_server'}
		let g:lsc_enable_autocomplete = v:false
		let g:lsc_auto_map = v:false
		let g:dartfmt_options = ['--fix', '-l 150']
		let g:dart_format_on_save = 1
	]])
end

function initCpp()
	-- require('lspconfig').clangd.setup{ }
	vim.cmd([[
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
	]])
end

function initLspDiagnostics()
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
end

function initLspFormatShortcut()
	vim.keymap.set('n', '<leader>fm', vim.lsp.buf.formatting)
end

function initLspShortcuts()
	initLspFormatShortcut()
	vim.keymap.set('n', '<leader>fD', vim.lsp.buf.declaration)
	vim.keymap.set('n', '<leader>fd', vim.lsp.buf.definition)
	vim.keymap.set('n', '<leader>fi', vim.lsp.buf.implementation)
	vim.keymap.set('n', '<leader>fr', vim.lsp.buf.references)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
	vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
	vim.keymap.set('n', '<leader>ds', vim.diagnostic.show)
	vim.keymap.set('n', '<leader>dh', vim.diagnostic.hide)
end

function initLsp()
	initDotnet()
	initDart()
	initGo()
	initTypeScript()
	initCpp()
	initPython()
	initFormatters()
	initLspDiagnostics()
	initLspShortcuts()
end

function initFormatters()
	vim.cmd([[
		autocmd FileType cs call initLspFormatShortcut()
		autocmd FileType go call initLspFormatShortcut()
		autocmd FileType dart call initLspFormatShortcut()
		autocmd FileType javascript nnoremap <leader>fm :call JsBeautify()<CR>
		autocmd FileType json nnoremap <leader>fm :call JsonBeautify()<CR>
		autocmd FileType jsx nnoremap <leader>fm :call JsxBeautify()<CR>
		autocmd FileType html nnoremap <leader>fm :call HtmlBeautify()<CR>
		autocmd FileType css nnoremap <leader>fm :call CSSBeautify()<CR>
		autocmd FileType cpp nnoremap <leader>fm :ClangFormat<CR>
		autocmd FileType python nnoremap <leader>fm :call Black()<CR>

		au BufRead,BufNewFile *.vm set filetype=velocity
	]])
end

function initGo()
	require('lspconfig').gopls.setup{}
	-- Stop scratch window from opening (gocode->neocomplete)
	-- Run go imports on save
	vim.cmd([[
		set completeopt-=preview
		let g:go_fmt_command = "goimports"
	]])
end

function initTypeScript()
	vim.cmd([[ let g:typescript_compiler_binary = 'tsc --noEmit' ]])
end

function initTerminalPlugin()
	require("toggleterm").setup{
		direction = 'float'
	}
	vim.cmd([[ set mouse=a ]])
end

initGeneralSettings()
initIndentation()
initColorScheme()
initLsp()
initFzf()
initShortcuts()
initTerminalPlugin()
