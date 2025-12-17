function config_lazy()
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)

  -- Make sure to setup `mapleader` and `maplocalleader` before
  -- loading lazy.nvim so that mappings are correct.
  -- This is also a good place to setup other settings (vim.opt)
  vim.g.mapleader = ";"
  vim.g.maplocalleader = "\\"

  -- Setup lazy.nvim
  require("lazy").setup({
    spec = {
      -- add your plugins here
      { 'vim-scripts/AutoComplPop' },
      { 'junegunn/fzf' },
      { 'junegunn/fzf.vim' },
      { 'tpope/vim-fugitive' },
      { 'itchyny/vim-gitbranch' },
      { 'neovim/nvim-lspconfig' },
      { 'fatih/vim-go' },
      { 'moll/vim-node' },
      { 'pangloss/vim-javascript' },
      { 'maksimr/vim-jsbeautify' },
      { 'leafgarland/typescript-vim' },
      { 'dart-lang/dart-vim-plugin' },
      { 'natebosch/vim-lsc' },
      { 'natebosch/vim-lsc-dart' },
      { 'OmniSharp/omnisharp-vim' },
      { 'rhysd/vim-clang-format' },
      { 'averms/black-nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install'
      },
      {
        'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
        dependencies = { 'nvim-lua/plenary.nvim' }
      },
      { 'jonarrien/telescope-cmdline.nvim' },
      { 'udalov/kotlin-vim' },
      { "rust-lang/rust.vim" },
      {
        'nvim-lualine/lualine.nvim'
        --dependencies = { 'nvim-tree/nvim-web-devicons' }
      },
      { "ziglang/zig.vim" },
      { "peterhoeg/vim-qml", name = "vim-qml" },
      { "nvim-treesitter/nvim-treesitter", lazy = false, build = ':TSUpdate' },
      { "bluz71/vim-nightfly-colors", name = "nightfly" },
      { "bluz71/vim-moonfly-colors", name = "moonfly" },
      { "nuvic/flexoki-nvim", name = "flexoki" },
      { "savq/melange-nvim" },
      { "wtfox/jellybeans.nvim", name = "jellybeans" },
      { "ellisonleao/gruvbox.nvim" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "gruvbox" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
  })
end

function config_status_line()
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      --section_separators = { left = '', right = '' },
      --component_separators = { left = '', right = '' }
    },
  }
end

function config_vim_o()
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
	vim.o.formatoptions = vim.o.formatoptions.."r" -- Continue comments on new lines
	vim.o.hlsearch = true
	vim.o.incsearch = true
	vim.o.ignorecase = true
	vim.o.wildmode = "longest,list,full" -- Completion rules
	vim.o.switchbuf = vim.o.switchbuf..",usetab,newtab"
	vim.cmd([[match ErrorMsg '\s\+$']]) -- Red color for trailing whitespaces
  vim.cmd([[set mouse=]])
end

function config_theme()
	vim.o.cursorline = true
	vim.o.hidden = true
	vim.o.background = "dark"
	vim.o.termguicolors = true
	vim.o.syntax = "on"
	vim.o.syntax = "enable"
  --vim.o.cc = "81"
  config_theme_gruvbox()
  config_status_line()
end

function config_theme_gruvbox()
  require("gruvbox").setup({
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = false,
    italic = {
      strings = false,
      emphasis = false,
      comments = false,
      operators = false,
      folds = false,
    },
    strikethrough = false,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
  })
  vim.cmd("colorscheme gruvbox")
end

function config_theme_flexoki()
  require("flexoki").setup({
    styles = {
        bold = false,
        italic = false,
    },
  })
  vim.cmd([[colorscheme flexoki]])
end

function config_theme_jellybeans()
  require("jellybeans").setup({
    transparent = false,
    italics = false,
    bold = false,
    flat_ui = false, -- toggles "flat UI" for pickers
    background = {
      dark = "jellybeans", -- default dark palette
      light = "jellybeans", -- default light palette
    },
    plugins = {
      all = false,
      auto = true, -- will read lazy.nvim and apply the colors for plugins that are installed
    },
  })
  vim.cmd([[colorscheme jellybeans]])
end

function config_theme_melange()
  vim.g.melange_enable_font_variants = {
    bold = false,
    italic = false,
    underline = false,
    undercurl = false,
    strikethrough = false,
  }
  vim.cmd([[colorscheme melange]])

  -- Overwrite Delimiter color for better contrast in melange.lua
  -- Delimiter = { fg = "#C1A78E" } (this is a.com color)
  vim.api.nvim_set_hl(0, "Delimiter", { fg = "#C1A78E" })
end

function config_theme_nightfly()
  vim.g.nightflyIntalics = false
  -- vim.g.nightflyNormalFloat = true
  -- vim.o.winborder = "single"
  vim.cmd([[colorscheme nightfly]])
end

function config_theme_moonfly()
  vim.g.moonflyIntalics = false
  -- vim.g.moonflyNormalFloat = true
  -- vim.o.winborder = "single"
  vim.cmd([[colorscheme moonfly]])
end

function config_telescope()
  require('telescope').setup{
    defaults = {
      layout_strategy = 'vertical',
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
        mappings = {
          i = {
            ["<c-d>"] = "delete_buffer",
          }
        }
      },
    },
    extensions = {
      cmdline = {
        -- Adjust telescope picker size and layout
        picker = {
          layout_config = {
            width  = 120,
            height = 25,
          }
        },
        -- Adjust your mappings
        mappings    = {
          complete      = '<Tab>',
          run_selection = '<C-CR>',
          run_input     = '<CR>',
        },
        -- Triggers any shell command using overseer.nvim (`:!`)
        overseer    = {
          enabled = false,
        },
      },
    }
  }
  require("telescope").load_extension('cmdline')

  local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>a', builtin.buffers, {})
	vim.keymap.set('n', '<leader>z', builtin.find_files, {})
	vim.keymap.set('n', '<leader>s', builtin.live_grep, {})
end

function config_treesitter()
  require'nvim-treesitter'.install { "c", "cpp", "lua", "rust", "go", "vim", "vimdoc", "query", "markdown", "markdown_inline" }

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'lua', 'rs', 'go', 'py', 'cs', 'md', 'js', 'ts' },
    callback = function() vim.treesitter.start() end,
  })
end

function config_key_mappings()
	-- Navigate the autocomplete box with <C-j> and <C-k>
	vim.keymap.set('i', '<c-j>', function()
		if vim.fn.pumvisible() == 1 then return '<c-n>' end
		return '<c-j>'
	end, { expr = true, noremap = true })

	vim.keymap.set('i', '<c-k>', function()
		if vim.fn.pumvisible() == 1 then return '<c-p>' end
		return '<c-k>'
	end, { expr = true, noremap = true })

  -- normal mode
	vim.keymap.set('n', 'D', '"_D')
	vim.keymap.set('n', 'dd', '"_dd')
	vim.keymap.set('n', '<c-n>', '<cmd>split<cr>')
	vim.keymap.set('n', '<c-m>', '<cmd>vsplit<cr>')
	vim.keymap.set('n', '<cr>', '<cmd>vsplit<cr>') -- mandatory in order for c-m to work in neovim
	vim.keymap.set('n', '<leader>gf', '<cmd>only<cr> gf')
	vim.keymap.set('n', '<c-d>', '<cmd>q<cr>')
	vim.keymap.set('n', '<leader>c', '<cmd>noh<cr>')
	vim.keymap.set('n', '<leader>vim', '<cmd>e $MYVIMRC<cr>')
	vim.keymap.set('n', '<leader>Y', 'ggVG"+y') -- select entire buffer
	vim.keymap.set('n', '<leader>re', ':%s/<C-r><C-w>\\C//gc<Left><Left><Left>')
	vim.keymap.set('n', '<leader>ry', ':%s/<C-r>"\\C//gc<Left><Left><Left>')
	vim.keymap.set('n', '<leader>R', ':%s//gc<Left><Left><Left>')
	vim.keymap.set('n', 'E', ':Explore<cr>')
  -- normal mode: LSP
	vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format)
	vim.keymap.set('n', '<leader>fD', vim.lsp.buf.declaration)
	vim.keymap.set('n', '<leader>fd', vim.lsp.buf.definition)
	vim.keymap.set('n', '<leader>fi', vim.lsp.buf.implementation)
	vim.keymap.set('n', '<leader>fr', vim.lsp.buf.references)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
  -- normal mode: diagnostics
	vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
	vim.keymap.set('n', '<leader>ds', vim.diagnostic.show)
	vim.keymap.set('n', '<leader>dh', vim.diagnostic.hide)

  -- visual mode
	vim.keymap.set('v', 'd', '"_d')
	vim.keymap.set('v', '<leader>y', '"+y') -- copy to clipboard
	vim.keymap.set('v', '<leader>re', ':s//gc<Left><Left><Left>') -- rename
	vim.keymap.set('v', '<leader>ry', 'y:s/<C-r>"//gc<Left><Left><Left>') -- rename from clipboard

  -- insert mode
	vim.keymap.set('i', '<c-l>', '<Right>')
  vim.keymap.set('i', '<c-h>', '<Left>')
	vim.keymap.set('i', '<c-k>', '<Up>')
	vim.keymap.set('i', '<c-j>', '<Down>')
end

function config_dotnet()
	local pid = vim.fn.getpid()
	local home = vim.fn.getenv('HOME')

  vim.g.OmniSharp_server_use_mono = 0
	vim.g.OmniSharp_server_use_net6 = 1
	vim.g.OmniSharp_highlighting = 0

	vim.lsp.config('omnisharp', {
    on_attach = function(client, bufnr)
      client.server_capabilities.semanticTokensProvider = nil
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    end,
    cmd = {home..'/.cache/omnisharp-vim/omnisharp-roslyn/OmniSharp', "--languageserver", "--hostPID", tostring(pid)};
	})
	vim.lsp.enable('omnisharp')
end

function config_dart()
	vim.lsp.config('dartls', {})
	vim.lsp.enable('dartls')
  vim.g.lsc_server_commands = {dart = "dart_language_server"}
  vim.g.lsc_enable_autocomplete = false
  vim.g.lsc_auto_map = false
  vim.g.dartfmt_options = {"--fix", "-l 150"}
  vim.g.dart_format_on_save = 1
end

function config_python()
  -- call :UpdateRemotePlugins
  vim.lsp.config('pyright', {})
  vim.lsp.enable('pyright')
  vim.cmd([[
    let g:python3_host_prog = $HOME . '/.local/venv/nvim/bin/python'
    let g:black#settings = {
        \ 'fast': 1,
        \ 'line_length': 120
    \}
  ]])
end

function config_rust()
  vim.g.rustfmt_autosave = 1
  vim.lsp.config('rust_analyzer', {
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
  vim.lsp.enable('rust_analyzer')
end

function config_zig()
  -- don't show parse errors in a separate window
  vim.g.zig_fmt_parse_errors = 0
  -- disable format-on-save from `ziglang/zig.vim`
  vim.g.zig_fmt_autosave = 0
  -- enable  format-on-save from nvim-lspconfig + ZLS
  --
  -- Formatting with ZLS matches `zig fmt`.
  -- The Zig FAQ answers some questions about `zig fmt`:
  -- https://github.com/ziglang/zig/wiki/FAQ
  vim.api.nvim_create_autocmd('BufWritePre',{
    pattern = {"*.zig", "*.zon"},
    callback = function(ev)
      vim.lsp.buf.format()
    end
  })

  vim.lsp.config('zls', {
    -- Server-specific settings. See `:help lspconfig-setup`

    -- omit the following line if `zls` is in your PATH
    cmd = { '/home/markotikvic/dev/zig/zls/zig-out/bin/zls' },
    -- There are two ways to set config options:
    --   - edit your `zls.json` that applies to any editor that uses ZLS
    --   - set in-editor config options with the `settings` field below.
    --
    -- Further information on how to configure ZLS:
    -- https://zigtools.org/zls/configure/
    settings = {
      zls = {
        -- Whether to enable build-on-save diagnostics
        --
        -- Further information about build-on save:
        -- https://zigtools.org/zls/guides/build-on-save/
        -- enable_build_on_save = true,

        -- Neovim already provides basic syntax highlighting
        semantic_tokens = "partial",

        -- omit the following line if `zig` is in your PATH
        --zig_exe_path = '/home/markotikvic/dev/zig/zig-x86-linux-0.14.1/zig'
        zig_exe_path = '/home/markotikvic/dev/zig/zig-x86_64-linux-0.16.0-dev.205+4c0127566/zig'
      }
    }
  })
  vim.lsp.enable('zls')
end

function config_clang_common()
	vim.cmd([[
    nnoremap <leader>fm :ClangFormat<CR>
    let g:clang_format#code_style = "google"
  ]])
	vim.lsp.config('clangd', {})
end

function config_cpp()
	vim.cmd([[
		let g:clang_format#style_options = {
			\ 'IndentWidth': 4,
			\ 'ColumnLimit': 160,
			\ 'DerivePointerAlignment': 'false',
			\ 'SortIncludes': 'true',
			\ 'IncludeBlocks': 'Preserve',
			\ 'SpacesBeforeTrailingComments': 1,
			\ 'SpaceBeforeCpp11BracedList': 'false',
		\ }
	]])
end

function config_c()
	vim.cmd([[
		let g:clang_format#style_options = {
			\ 'IndentWidth': 4,
			\ 'ColumnLimit': 120,
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

function config_languages()
  config_clang_common()
	config_dotnet()
	config_dart()
	config_go()
	config_typescript()
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
	vim.lsp.config('gopls', {})
	vim.lsp.enable('gopls')
  --Stop scratch window from opening(gocode->neocomplete)
  vim.cmd([[set completeopt-=preview]])
  vim.g.go_fmt_command = "goimports"
end

function config_typescript()
  vim.g.typescript_compiler_binary = "tsc --noEmit"
end

function config_neovim()
  config_lazy()
  config_vim_o()
  config_key_mappings()
  config_theme()
  config_telescope()
  config_treesitter()
  config_languages()
end

config_neovim()
