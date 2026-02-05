set number
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2
" Maybe we should have text width at 100
set textwidth=90
set autoindent
filetype indent on


call plug#begin('~/.config/nvim/site')

Plug 'nvim-neotest/nvim-nio'
Plug 'scalameta/nvim-metals'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
Plug 'mfussenegger/nvim-jdtls'
Plug 'hrsh7th/nvim-cmp'
Plug 'mrcjkb/rustaceanvim'
" Plug 'simrat39/rust-tools.nvim' " no longer supported
Plug 'gennaro-tedesco/nvim-jqx'
Plug 'folke/tokyonight.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-telescope/telescope.nvim'
Plug 'beauwilliams/statusline.lua'
Plug 'preservim/nerdtree'
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'williamboman/mason.nvim'
Plug 'jay-babu/mason-nvim-dap.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'j-hui/fidget.nvim'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-neotest/nvim-nio'
" Plug 'navarasu/onedark.nvim'
Plug 'jremmen/vim-ripgrep'
Plug 'lervag/wiki.vim'
Plug 'gabrielelana/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'folke/snacks.nvim'
Plug 'shahshlok/vim-coach.nvim'
Plug 'rmagatti/auto-session'

call plug#end()

colorscheme tokyonight-night
" colorscheme onedark
" colorscheme catppuccin 
" Using Lua functions
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
" nnoremap <leader>nt <cmd>NERDTree<cr>
nnoremap <S-Tab> <<
nnoremap ;bn <cmd>bn<cr>
nnoremap ;bw <cmd>bw<cr>
nnoremap ;bw <cmd>bd<cr>
nnoremap ;bp <cmd>bp<cr>
" Below make it so I can open a vertical split and then ;l move between splits
nnoremap ;l <C-W><C-W> 
nnoremap ;vs <cmd>vsplit<cr>
nnoremap ;hs <C-W><C-S>

lua require('metals')
" The Nom-Metals file has all kinds of keymappings and set up for nvim 
" The main file has all kinds of developer settings in general. Both are good. 
lua require('neoanomally/nom-metals') 
lua require('neoanomally/nom-java')
lua require('neoanomally/main') 
" lua require('neoanomally/nom-java')
lua vim.o.hlsearch = false
lua vim.o.mouse = 'a'
let g:java_ignore_markdown = 28

