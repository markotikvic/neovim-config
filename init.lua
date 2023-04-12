require("plugins")

vim.g.mapleader = ";"

function config_python()
	vim.cmd([[
    let g:python3_host_prog = $HOME . '/.local/venv/nvim/bin/python'
		let g:black#settings = {
		    \ 'fast': 1,
		    \ 'line_length': 100
		\}
	]])
end

function get_long_mode_name()
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

function get_status_line_format()
	local spacePipe = " | "
  local branch = vim.call("gitbranch#name")

	local line = " "..get_long_mode_name()
	line = line..spacePipe
	line = line.."%t%m" -- line = line.."%f%m"
	line = line.."%="

  if branch ~= "" then
    line = line..spacePipe
    line = line..">> "..branch
  end

	line = line..spacePipe
	line = line..vim.opt.ff:get().." "..vim.opt.encoding:get()
	line = line..spacePipe
	line = line.."%l:%c"
	line = line..spacePipe
	line = line.."%P "

	return line
end

function configStatusLine()
	vim.o.laststatus=2
	vim.o.statusline=get_status_line_format()
end

function config_general_settings()
	vim.cmd([[ filetype plugin indent on ]])
  vim.g.acp_ignorecaseOption = 0
	vim.o.encoding = "utf-8"
	vim.o.autoindent = true
	vim.o.tabstop = 8
	vim.o.shiftwidth = 8
	vim.o.expandtab = false
	vim.o.number = true
	vim.o.relativenumber = true
	vim.o.wrap = true
	vim.o.formatoptions = vim.o.formatoptions.."r" --Continue comments on new lines
	vim.o.hlsearch = true
	vim.o.incsearch = true
	--vim.o.ignorecase = true
	vim.o.wildmode = "longest,list,full" --Completion rules
	vim.o.switchbuf = vim.o.switchbuf..",usetab,newtab"
	vim.cmd([[ match ErrorMsg '\s\+$' ]]) --Red color for trailing whitespaces
end

function config_color_scheme()
	vim.o.cursorline = true
	vim.o.guifont = "Fira Mono Medium 10"
	vim.o.hidden = true
	vim.o.background = "dark"
	vim.o.termguicolors = true
	vim.o.syntax = "on"
	vim.o.syntax = "enable"
  vim.g.gruvbox_contrast_dark = "hard"
	vim.cmd([[ colorscheme gruvbox ]])
	configStatusLine()
end

function config_fzf()
	vim.keymap.set('n', '<leader>a', '<cmd>Buffers<cr>')--nnoremap <leader>a :Buffers<CR>
	vim.keymap.set('n', '<leader>z', '<cmd>Files<cr>')--nnoremap <leader>z :Files<CR>
	vim.keymap.set('n', '<leader>s', '<cmd>Lines<cr>')--nnoremap <leader>l :Lines<CR>
	vim.keymap.set('n', '<leader>F', '<cmd>Ag<cr>')--nnoremap <leader>L :Ag<CR>
	vim.cmd([[
    let g:fzf_preview_window = []
		let $FZF_DEFAULT_COMMAND='find . ! -path */.git/* ! -path */install/* ! -path */build/* ! -path */Debug/* ! -path */bin/* ! -path */obj/* ! -path */node_modules/* -type f'
	]])
end

function config_shortcuts()
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
	vim.keymap.set('n', '<leader>fm', vim.lsp.buf.formatting)
	vim.keymap.set('n', '<leader>fD', vim.lsp.buf.declaration)
	vim.keymap.set('n', '<leader>fd', vim.lsp.buf.definition)
	vim.keymap.set('n', '<leader>fi', vim.lsp.buf.implementation)
	vim.keymap.set('n', '<leader>fr', vim.lsp.buf.references)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
	vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
	vim.keymap.set('n', '<leader>ds', vim.diagnostic.show)
	vim.keymap.set('n', '<leader>dh', vim.diagnostic.hide)
end

function config_dotnet()
	local pid = vim.fn.getpid()
	local home = vim.fn.getenv('HOME')

	require('lspconfig').omnisharp.setup({
		on_attach = function(_, bufnr)
			vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
		end,
		cmd = { home .. '/.cache/omnisharp-vim/omnisharp-roslyn/run', "--languageserver" , "--hostPID", tostring(pid)};
	})
	vim.g.OmniSharp_highlighting = 0
end

function config_dart()
	require('lspconfig').dartls.setup({})
  vim.g.lsc_server_commands = {dart = "dart_language_server"}
  vim.g.lsc_enable_autocomplete = false
  vim.g.lsc_auto_map = false
  vim.g.dartfmt_options = {"--fix", "-l 150"}
  vim.g.dart_format_on_save = 1
end

function config_cpp()
	-- require('lspconfig').clangd.setup{ }
	vim.cmd([[
    let g:clang_format#code_style = "google"
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

function config_lsp_diagnostics()
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

function config_lsp()
	config_dotnet()
	config_dart()
	config_go()
	config_type_script()
	config_cpp()
	config_python()
	config_formatters()
	config_lsp_diagnostics()
end

function config_formatters()
	vim.cmd([[
		autocmd FileType cs lua config_shortcuts()
		autocmd FileType go lua config_shortcuts()
		autocmd FileType dart lua config_shortcuts()
		autocmd FileType javascript nnoremap <leader>fm :call JsBeautify()<CR>
		autocmd FileType json nnoremap <leader>fm :call JsonBeautify()<CR>
		autocmd FileType jsx nnoremap <leader>fm :call JsxBeautify()<CR>
		autocmd FileType html nnoremap <leader>fm :call HtmlBeautify()<CR>
		autocmd FileType css nnoremap <leader>fm :call CSSBeautify()<CR>
		autocmd FileType cpp nnoremap <leader>fm :ClangFormat<CR>
		autocmd FileType python nnoremap <leader>fm :call Black()<CR>
	]])
end

function config_go()
	require('lspconfig').gopls.setup{}
	vim.cmd([[ set completeopt-=preview ]]) -- Stop scratch window from opening (gocode->neocomplete)
  vim.g.go_fmt_command = "goimports" -- Run go imports on save
end

function config_type_script()
	vim.g.typescript_compiler_binary = "tsc --noEmit"
end

function config_terminal()
	require("toggleterm").setup{
		direction = 'float'
	}
	vim.cmd([[ set mouse=a ]])
end

config_general_settings()
config_color_scheme()
config_lsp()
config_fzf()
config_shortcuts()
config_terminal()