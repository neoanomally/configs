require('lualine').setup {
	options = {
		icons_enabled = false,
		theme = 'onedark',
		component_separators = '|',
		section_separators = '',
	},
}

require('Comment').setup()
require('mason').setup()
vim.g.mapleader = ';'

print("Hi")
pcall(require('telescope').loadextension, 'fzf')

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false
})
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, {desc= '[S]earch [F]iles'})
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, {desc = '[S]earch [H]elp'})
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })


vim.keymap.set('n', '<leader>nt', '<cmd>NERDTreeFocus<cr>', {desc = 'Open [N]erd [T]ree.' })


-- These are functions mostly for metals
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,{ desc = '[R]e[n]ame' } )
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {desc = '[C]ode [A]ction' })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {desc = '[G]oto [D]efinition.'})
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eference'})
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, {desc = '[G]oto [I]mplementation'})
-- vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definitions, { desc = 'Type [D]efinition' })
vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, {desc = '[D]ocument [S]ymbol'})
vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, {desc = '[W]orkspace [S]ymbol'})


require('mason').setup()

local servers = { 'clangd', 'rust_analyzer', 'luau_lsp', 'jdtls' }

require('mason-lspconfig').setup {
	ensure_installed = servers,
}

for _, lsp in ipairs(servers) do
	require('lspconfig')[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities
	}
end

require('fidget').setup()

