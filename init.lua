require("plugins")

vim.g.mapleader = ";"

function vim_mode()
	local modes = {}

	modes['n'] = '[N]'
	modes['v'] = '[V]'
	modes['V'] = '[V·L]'
	modes['s'] = '[S]'
	modes['S'] = '[S·L]'
	modes['i'] = '[I]'
	modes['R'] = '[R]'
	modes['Rv'] = '[R-V]'
	modes['c'] = '[C]'
	modes['t'] = '[T]'

	local m = vim.fn.mode()

	for k,v in pairs(modes) do
		if k == m then
			return v
		end
	end

	return "["..m.."?]"
end

function git_branch()
  local branch = vim.call("gitbranch#name")
  if branch ~= "" then
    return "("..branch..")"
  end
  return ""
end

function active_status_line_format()
  local mode = vim_mode()
  local branch = git_branch()
	local line = mode.." %t%m L%l:%c %P "..branch
	line = line.."%=" -- align to right
	line = line..vim.opt.ff:get().." "..vim.opt.encoding:get()

	return line
end

function inactive_status_line_format()
  local line = "%t"
	line = line.."%=" -- align to right
	line = line..vim.opt.ff:get().." "..vim.opt.encoding:get()
  return line
end

function config_status_line()
	vim.o.laststatus = 2
  vim.api.nvim_exec([[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.active_status_line_format()
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.inactive_status_line_format()
    augroup END
  ]], false)
end

function config_general_settings()
	vim.cmd([[ filetype plugin indent on ]])
  vim.g.acp_ignorecaseOption = 0
  vim.g.acp_enableAtStartup = 0
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
	vim.o.hidden = true
	vim.o.background = "dark"
	vim.o.termguicolors = true
	vim.o.syntax = "on"
	vim.o.syntax = "enable"
  --vim.g.gruvbox_contrast_dark = "hard"
	--vim.cmd([[ colorscheme gruvbox ]])
  require('catppuccin').setup{
    styles = {
      conditionals = {},
      comments = {}
    },
    integrations = {
      treesitter = false,
      semantic_tokens = false
    }
  }
	vim.cmd([[ colorscheme catppuccin-mocha ]])
end

function config_fzf()
	vim.keymap.set('n', '<leader>a', '<cmd>Buffers<cr>')--nnoremap <leader>a :Buffers<CR>
	vim.keymap.set('n', '<leader>z', '<cmd>Files<cr>')--nnoremap <leader>z :Files<CR>
	vim.keymap.set('n', '<leader>s', '<cmd>Lines<cr>')--nnoremap <leader>l :Lines<CR>
	vim.keymap.set('n', '<leader>F', '<cmd>Ag<cr>')--nnoremap <leader>L :Ag<CR>
	vim.cmd([[
    let g:fzf_preview_window = ['right,40%']
		let $FZF_DEFAULT_COMMAND='find . ! -path "*/.git/*" ! -path "*/install/*" ! -path "*/build/*" ! -path "*/Debug/*" ! -path "*/bin/*" ! -path "*/obj/*" ! -path "*/node_modules/*" -type f'
	]])
end

function config_telescope()
  require('telescope').setup{
    defaults = {
      file_ignore_patterns = {".git", "node_modules", "build", "Debug", "bin", "obj", "install"},
      mappings = {
        i = {
          ["<C-j>"] = require('telescope.actions').move_selection_next,
          ["<C-k>"] = require('telescope.actions').move_selection_previous,
        },
      },
    }
  }

  local builtin = require('telescope.builtin')
  --builtin.buffers({ sort_mru = true })
  --builtin.buffers({ sort_lastused = true, ignore_current_buffer = true })
	vim.keymap.set('n', '<leader>a', builtin.buffers, {})
	vim.keymap.set('n', '<leader>z', builtin.find_files, {})
	vim.keymap.set('n', '<leader>s', builtin.live_grep, {})
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

	vim.keymap.set('n', '<c-n>', '<cmd>split<cr>')
	vim.keymap.set('n', '<c-m>', '<cmd>vsplit<cr>')
	vim.keymap.set('n', '<cr>', '<cmd>vsplit<cr>') --mandatory in order for c-m to work in neovim
	vim.keymap.set('n', '<leader>gf', '<cmd>only<cr> gf')
	vim.keymap.set('n', '<c-d>', '<cmd>q<cr>')
	vim.keymap.set('n', '<leader>c', '<cmd>noh<cr>')
	vim.keymap.set('n', '<tab>', '<c-w>w')
	vim.keymap.set('n', '<leader>m', '%')
	vim.keymap.set('v', '<leader>y', '"+y') -- copy to clipboard
	vim.keymap.set('n', '<leader>vim', '<cmd>e $MYVIMRC<cr>')
	vim.keymap.set('n', '<leader>re', '<cmd>source $MYVIMRC<cr>')
	vim.keymap.set('n', '<leader>t', '<cmd>ToggleTerm<cr>')
	vim.keymap.set('n', '<leader>Y', 'ggVG"+y') -- select entire buffer
	vim.keymap.set('n', '<leader>fm', vim.lsp.buf.formatting)
	vim.keymap.set('n', '<leader>fD', vim.lsp.buf.declaration)
	vim.keymap.set('n', '<leader>fd', vim.lsp.buf.definition)
	vim.keymap.set('n', '<leader>fi', vim.lsp.buf.implementation)
	vim.keymap.set('n', '<leader>fr', vim.lsp.buf.references)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
	vim.keymap.set('n', '<leader>re', ':%s/<C-r><C-w>//gc<Left><Left><Left>')
	vim.keymap.set('n', '<leader>ry', ':%s/<C-r>"//gc<Left><Left><Left>')
	vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
	vim.keymap.set('n', '<leader>ds', vim.diagnostic.show)
	vim.keymap.set('n', '<leader>dh', vim.diagnostic.hide)
end

function config_dotnet()
	local pid = vim.fn.getpid()
	local home = vim.fn.getenv('HOME')

  vim.g.OmniSharp_server_use_mono = 0
	vim.g.OmniSharp_server_use_net6 = 1
	vim.g.OmniSharp_highlighting = 0

	require('lspconfig').omnisharp.setup({
		on_attach = function(_, bufnr)
			vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
		end,
		cmd = { home .. '/.cache/omnisharp-vim/omnisharp-roslyn/OmniSharp', "--languageserver" , "--hostPID", tostring(pid)};
	})
end

function config_dart()
	require('lspconfig').dartls.setup({})
  vim.g.lsc_server_commands = {dart = "dart_language_server"}
  vim.g.lsc_enable_autocomplete = false
  vim.g.lsc_auto_map = false
  vim.g.dartfmt_options = {"--fix", "-l 150"}
  vim.g.dart_format_on_save = 1
end

function config_python()
	vim.cmd([[
    let g:python3_host_prog = $HOME . '/.local/venv/nvim/bin/python'
		let g:black#settings = {
		    \ 'fast': 1,
		    \ 'line_length': 100
		\}
	]])
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
		autocmd FileType c nnoremap <leader>fm :ClangFormat<CR>
		autocmd FileType python nnoremap <leader>fm :call Black()<CR>
		au BufRead,BufNewFile *.vm set filetype=velocity
		au BufRead,BufNewFile *.lox set filetype=lua
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
config_status_line()
config_lsp()
config_fzf()
config_shortcuts()
config_terminal()
