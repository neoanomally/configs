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

" Plug 'navarasu/onedark.nvim'
" Plug 'simrat39/rust-tools.nvim' " no longer supported
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'beauwilliams/statusline.lua'
Plug 'christoomey/vim-tmux-navigator'
Plug 'folke/snacks.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'gabrielelana/vim-markdown'
Plug 'gennaro-tedesco/nvim-jqx'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'j-hui/fidget.nvim'
Plug 'jay-babu/mason-nvim-dap.nvim'
Plug 'jremmen/vim-ripgrep'
Plug 'lervag/wiki.vim'
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'mfussenegger/nvim-jdtls'
Plug 'mrcjkb/rustaceanvim'
Plug 'neovim/nvim-lspconfig'
Plug 'numToStr/Comment.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-neotest/nvim-nio'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'preservim/nerdtree'
Plug 'ray-x/lsp_signature.nvim'
Plug 'rcarriga/nvim-dap-ui'
Plug 'rmagatti/auto-session'
Plug 'scalameta/nvim-metals'
Plug 'shahshlok/vim-coach.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'williamboman/mason.nvim'

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
set clipboard+=unnamedplus
