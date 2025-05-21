require("plugins")

vim.g.mapleader = ";"

function config_status_line()
  require('lualine').setup {
    options = {
      icons_enabled = false,
      theme = 'auto',
    },
  }
end

function config_general_settings()
	vim.cmd([[filetype plugin indent on]])
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
	vim.cmd([[match ErrorMsg '\s\+$']]) --Red color for trailing whitespaces
  vim.cmd([[set mouse=]])
end

function config_theme()
	vim.o.cursorline = true
	vim.o.hidden = true
	vim.o.background = "dark"
	vim.o.termguicolors = true
	vim.o.syntax = "on"
	vim.o.syntax = "enable"
  config_theme_catppuccin()
end

function config_theme_github()
  vim.cmd([[colorscheme github_dark]])
end

function config_theme_solarized()
  vim.cmd([[colorscheme solarized]])
end

function config_theme_iceberg()
  vim.cmd([[colorscheme iceberg]])
end

function config_theme_kanagawa()
  vim.cmd([[colorscheme kanagawa]])
end

function config_theme_catppuccin()
  require("catppuccin").setup({
    no_italic = true,
    term_colors = true,
    transparent_background = false,
    integrations = {
      telescope = {
        enabled = true,
      },
    },
  })
  vim.cmd([[colorscheme catppuccin-mocha]])
end

function config_theme_rasmus()
  vim.cmd([[colorscheme rasmus]])
end

function config_theme_zenbones()
  vim.cmd([[colorscheme zenbones]])
end

function config_theme_ash()
  vim.cmd([[colorscheme ash]])
end

function config_theme_jellybeans()
  vim.cmd([[colorscheme jellybeans-nvim]])
end

function config_theme_nord()
  vim.cmd[[colorscheme nord]]
end

function config_theme_nightfox()
  vim.cmd([[colorscheme carbonfox]])
end

function config_theme_monokai_pro()
  require("monokai-pro").setup({
    styles = {
      comment = { italic = true },
      keyword = { italic = false, bold = true }, -- any other keyword
      type = { italic = false, bold = true }, -- (preferred) int, long, char, etc
      storageclass = { italic = false, bold = true }, -- static, register, volatile, etc
      structure = { italic = false, bold = true }, -- struct, union, enum, etc
      parameter = { italic = false }, -- parameter pass in function
      annotation = { italic = false, bold = true },
      tag_attribute = { italic = false }, -- attribute of tag in reactjs
    },
  })
	vim.cmd([[colorscheme monokai-pro-octagon]])
end

function config_theme_moonfly()
	vim.cmd([[colorscheme moonfly]])
end

function config_theme_gruvbox()
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
	vim.cmd([[colorscheme gruvbox]])
end

current_theme = 0
themes = {
  config_theme_jellybeans,
  config_theme_moonfly,
  config_theme_gruvbox,
  config_theme_ash,
  config_theme_catppuccin,
  config_theme_monokai_pro,
  config_theme_nightfox,
  config_theme_rasmus,
  config_theme_iceberg,
  config_theme_solarized,
  config_theme_nord,
  config_theme_github,
  config_theme_kanagawa,
}

function next_theme()
  themes_count = #themes
  current_theme = current_theme + 1
  if current_theme > themes_count then
    current_theme = 1
  end
  themes[current_theme]()
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

function config_treesitter()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
    highlight = {
      enable = true,
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }
end

function config_key_mappings()
	--Navigate the autocomplete box with <C-j> and <C-k>
	vim.keymap.set('i', '<c-j>', function()
		if vim.fn.pumvisible() == 1 then return '<c-n>' end
		return '<c-j>'
	end, { expr = true, noremap = true })

	vim.keymap.set('i', '<c-k>', function()
		if vim.fn.pumvisible() == 1 then return '<c-p>' end
		return '<c-k>'
	end, { expr = true, noremap = true })

	vim.keymap.set('n', 'D', '"_D')
	vim.keymap.set('n', 'dd', '"_dd')
	vim.keymap.set('n', '<c-n>', '<cmd>split<cr>')
	vim.keymap.set('n', '<c-m>', '<cmd>vsplit<cr>')
	vim.keymap.set('n', '<cr>', '<cmd>vsplit<cr>') --mandatory in order for c-m to work in neovim
	vim.keymap.set('n', '<leader>gf', '<cmd>only<cr> gf')
	vim.keymap.set('n', '<c-d>', '<cmd>q<cr>')
	vim.keymap.set('n', '<leader>c', '<cmd>noh<cr>')
	--vim.keymap.set('n', '<tab>', '<c-w>w')
	vim.keymap.set('n', '<leader>m', '%')
	vim.keymap.set('n', '<leader>vim', '<cmd>e $MYVIMRC<cr>')
	vim.keymap.set('n', '<leader>rl', '<cmd>source $MYVIMRC<cr>')
	vim.keymap.set('n', '<leader>Y', 'ggVG"+y') -- select entire buffer
	vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format)
	vim.keymap.set('n', '<leader>fD', vim.lsp.buf.declaration)
	vim.keymap.set('n', '<leader>fd', vim.lsp.buf.definition)
	vim.keymap.set('n', '<leader>fi', vim.lsp.buf.implementation)
	vim.keymap.set('n', '<leader>fr', vim.lsp.buf.references)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
	vim.keymap.set('n', '<leader>re', ':%s/<C-r><C-w>//gc<Left><Left><Left>')
	vim.keymap.set('n', '<leader>ry', ':%s/<C-r>"//gc<Left><Left><Left>')
	vim.keymap.set('n', '<leader>R', ':%s//gc<Left><Left><Left>')
	vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
	vim.keymap.set('n', '<leader>ds', vim.diagnostic.show)
	vim.keymap.set('n', '<leader>dh', vim.diagnostic.hide)
	vim.keymap.set('n', '<leader>tt', next_theme)
	vim.keymap.set('n', 'E', ':Explore<cr>')

	vim.keymap.set('v', 'd', '"_d')
	vim.keymap.set('v', '<leader>y', '"+y') -- copy to clipboard
	vim.keymap.set('v', '<leader>re', ':s//gc<Left><Left><Left>') -- rename
	vim.keymap.set('v', '<leader>ry', ':s/<C-r>"//gc<Left><Left><Left>') -- rename from clipboard

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
  require('lspconfig').rust_analyzer.setup({
		on_attach = function(client, bufnr)
      client.server_capabilities.semanticTokensProvider = nil
		end,
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
  })
end

function config_zig()
  require 'lspconfig'.zls.setup{}
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
			\ 'SpaceBeforeCpp11BracedList': 'false',
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
			\ 'DerivePointerAlignment': 'false',
      \ 'PointerAlignment': 'Right',
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
	config_python()
  config_rust()
  config_zig()
	config_formatters()
	config_lsp_diagnostics()
end

function config_formatters()
	vim.cmd([[
		autocmd FileType cs lua config_key_mappings()
		autocmd FileType go lua config_key_mappings()
		autocmd FileType dart lua config_key_mappings()
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
	vim.cmd([[set completeopt-=preview]]) -- Stop scratch window from opening (gocode->neocomplete)
  vim.g.go_fmt_command = "goimports" -- Run go imports on save
end

function config_type_script()
	vim.g.typescript_compiler_binary = "tsc --noEmit"
end

config_general_settings()
config_theme()
config_treesitter()
config_status_line()
config_lsp()
config_telescope()
config_key_mappings()
