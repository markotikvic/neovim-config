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

function config_status_line()
  require('lualine').setup {
    options = {
      icons_enabled = false,
      theme = 'auto',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'filename'},
      lualine_c = {'branch'},
      lualine_x = {'encoding', 'fileformat'},
      lualine_y = {},
      lualine_z = {'location', 'progress'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename', 'location'},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  }
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
	vim.o.ignorecase = true
	vim.o.wildmode = "longest,list,full" --Completion rules
	vim.o.switchbuf = vim.o.switchbuf..",usetab,newtab"
	vim.cmd([[ match ErrorMsg '\s\+$' ]]) --Red color for trailing whitespaces
  vim.cmd([[ set mouse= ]])
end

function config_theme()
	vim.o.cursorline = true
	vim.o.hidden = true
	vim.o.background = "dark"
	vim.o.termguicolors = true
	vim.o.syntax = "on"
	vim.o.syntax = "enable"
  --config_kanagawa()
  --config_gruvbox()
  --config_nightfox()
  --config_catppuccin()
  --config_rose_pine()
  --config_moonfly()
  config_monokai()
  require("ibl").setup()
end

function config_monokai()
  require("monokai-pro").setup()
	vim.cmd([[ colorscheme monokai-pro-classic ]])
end

function config_moonfly()
	vim.cmd([[ colorscheme moonfly ]])
end

function config_rose_pine()
  require('rose-pine').setup({
    dark_variant = 'main',
    styles = {
      italic = false,
      bold = false,
    },
  })
	vim.cmd([[ colorscheme rose-pine-moon ]])
end

function config_nightfox()
  require('nightfox').setup({
    options = {
      styles = {
        comments = "italic",
        keywords = "bold",
        conditionals = "bold",
        types = "bold",
      }
    }
  })
  vim.cmd([[ colorscheme nightfox ]])
end

function config_kanagawa()
  require('kanagawa').setup({
    commentStyle = { bold = false, italic = true },
    keywordStyle = { bold = true, italic = false},
    statementStyle = { bold = true, italic = false },
    theme = "dragon",
    background = {
      dark = "dragon",
      light = "lotus"
    },
  })
	vim.cmd([[ colorscheme kanagawa-dragon ]])
end

function config_gruvbox()
  require('gruvbox').setup({
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = false,
      emphasis = false,
      comments = true,
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
  })
	vim.cmd([[ colorscheme gruvbox ]])
end

function config_catppuccin()
  require('catppuccin').setup{
    styles = {
      conditionals = {},
    },
    color_overrides = {
      mocha = {
        base = "#000000",
        mantle = "#000000",
        crust = "#000000",
      },
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
      layout_strategy = 'vertical',
      layout_config = { height = 0.9 },
      file_ignore_patterns = {".git", "node_modules", "build", "Debug", "bin", "obj", "install"},
      mappings = {
        i = {
          ["<C-j>"] = require('telescope.actions').move_selection_next,
          ["<C-k>"] = require('telescope.actions').move_selection_previous,
        },
      },
    },
    pickers = {
      buffers = {
        sort_mru = true,
        --ignore_current_buffer = true,
        --sort_lastused = true,
      },
    },
  }

  local telescope_builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>a', telescope_builtin.buffers, {})
	vim.keymap.set('n', '<leader>z', telescope_builtin.find_files, {})
	vim.keymap.set('n', '<leader>s', telescope_builtin.live_grep, {})
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
	vim.keymap.set('n', '<leader>rl', '<cmd>source $MYVIMRC<cr>')
	vim.keymap.set('n', '<leader>t', '<cmd>ToggleTerm<cr>')
	vim.keymap.set('n', '<leader>Y', 'ggVG"+y') -- select entire buffer
	vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format)
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

	vim.keymap.set('v', '<leader>re', ':s//gc<Left><Left><Left>')
	vim.keymap.set('v', '<leader>ry', ':s/<C-r>"//gc<Left><Left><Left>')

	vim.keymap.set('i', '<C-l>', '<Right>')
	vim.keymap.set('i', '<C-h>', '<Left>')
	vim.keymap.set('i', '<C-k>', '<Up>')
	vim.keymap.set('i', '<C-j>', '<Down>')
end

function config_dotnet()
	local pid = vim.fn.getpid()
	local home = vim.fn.getenv('HOME')

  vim.g.OmniSharp_server_use_mono = 0
	vim.g.OmniSharp_server_use_net6 = 1
	vim.g.OmniSharp_highlighting = 0

	require('lspconfig').omnisharp.setup({
		on_attach = function(client, bufnr)
      client.server_capabilities.semanticTokensProvider = nil
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
  -- call :UpdateRemotePlugins
	require('lspconfig').pyright.setup{}
	vim.cmd([[
    let g:python3_host_prog = $HOME . '/.local/venv/nvim/bin/python'
		let g:black#settings = {
		    \ 'fast': 1,
		    \ 'line_length': 100
		\}
	]])
end

function config_rust()
  vim.g.rustfmt_autosave = 1
  require('lspconfig').rust_analyzer.setup {
    settings = {
      ['rust-analyzer'] = {
        check = {
          command = "clippy";
        },
        diagnostics = {
          enable = true;
        }
      }
    }
  }
end

function config_cpp()
	vim.cmd([[
    nnoremap <leader>fm :ClangFormat<CR>
    let g:clang_format#code_style = "google"
		let g:clang_format#style_options = {
			\ 'IndentWidth': 2,
			\ 'ColumnLimit': 160,
			\ 'DerivePointerAlignment': 'false',
			\ 'SortIncludes': 'true',
			\ 'IncludeBlocks': 'Preserve',
			\ 'SpacesBeforeTrailingComments': 1,
			\ 'SpaceBeforeCpp11BracedList': 'true',
		\ }
	]])
  -- not usable for PASOP
	-- require('lspconfig').clangd.setup{}
end

function config_c()
	vim.cmd([[
    nnoremap <leader>fm :ClangFormat<CR>
    let g:clang_format#code_style = "google"
		let g:clang_format#style_options = {
			\ 'IndentWidth': 4,
			\ 'ColumnLimit': 80,
			\ 'SortIncludes': 'true',
			\ 'IncludeBlocks': 'Preserve',
			\ 'SpacesBeforeTrailingComments': 1,
      \ 'BreakBeforeBraces': 'Linux',
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
  config_rust()
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
		autocmd FileType cpp lua config_cpp()
		autocmd FileType c lua config_c()
		autocmd FileType rs nnoremap <leader>fm :RustFmt<CR>
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
config_theme()
config_status_line()
config_lsp()
-- config_fzf()
config_telescope()
config_shortcuts()
-- config_terminal()
