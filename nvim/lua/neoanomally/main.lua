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

pcall(require('telescope').loadextension, 'fzf')
require('telescope').setup({
    defaults = {
        file_ignore_patterns = { "^./.git/", "^node_modules", "target" },
				layout_config = {
					preview_cutoff = 10,
				},
    }
})

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false
})
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, {desc= '[S]earch [F]iles'})
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, {desc = '[S]earch [H]elp'})
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>nt', '<cmd>NERDTreeFocus<cr>', {desc = 'Open [N]erd [T]ree.' })

-- These are functions mostly for metals

vim.keymap.set('n', '<leader>ho', vim.lsp.buf.hover,{ desc = 'Signature h[O]ver' } )
vim.keymap.set('n', '<leader>si', vim.lsp.buf.signature_help, { desc = '[SI]gnature help' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,{ desc = '[R]e[n]ame' } )
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {desc = '[C]ode [A]ction' })
vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, {desc = '[C]ode[L]ens Run' })
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {desc = '[G]oto [D]efinition.'})
vim.keymap.set('n', '<leader>gI', vim.lsp.buf.implementation, {desc = '[G]oto [I]mplementation'})
-- vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definitions, { desc = 'Type [D]efinition' })
vim.keymap.set('n', '<leader>gr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eference'})
vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, {desc = '[D]ocument [S]ymbol'})
vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, {desc = '[W]orkspace [S]ymbol'})

vim.keymap.set('n', '[c', function()
	vim.diagnostic.goto_prev({ wrap = false })
end, { desc = 'Goto Preview' })

vim.keymap.set('n', ']c', function()
	vim.diagnostic.goto_next({ wrap = false })
end, { desc = 'Goto Next' })

vim.keymap.set('n', '<Leader>df', function()
	local widgets = require('dap.ui.widgets')
	widgets.centered_float(widgets.frames)
end, { desc = '[D]ap [F]rames widgets' } )

vim.keymap.set('n', '<Leader>ds', function()
	local widgets = require('dap.ui.widgets')
	widgets.centered_float(widgets.scopes)
end, { desc = '[D]ap Widgets [S]cope' })

vim.keymap.set('n', '<leader>dc', function()
	require('dap').continue()
end, { desc = '[D]ap [C]ontinue' } )

vim.keymap.set('n', '<leader>dr', function()
	require('dap').repl.toggle()
end, { desc = '[D]ap Open [R]epl' } )

vim.keymap.set('n', '<leader>dK', function()
	require('dap').hover()
end, { desc = '[D]ap Hover' })

vim.keymap.set('n', '<leader>dt', function()
	require('dap').toggle_breakpoint()
end, { desc = '[D]ap Breakpoint [T]oggle' })

vim.keymap.set('n', '<leader>dso', function()
	require('dap').step_over()
end, { desc = '[D]ap [S]tep[O]ver' } )

vim.keymap.set('n', '<leader>dsi', function()
	require('dap').step_into()
end, { desc = '[D]ap [S]tep [I]nto' })

vim.keymap.set('n', '<Leader>dsb', function() 
	require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
	{ desc = '[D]ap [S]et [B]reakpoint' }
)

vim.keymap.set('n', '<leader>mt', function() 
	require("telescope").extensions.metals.commands() 
end, { desc = "[M]etals [T]elescope" }
)


require('mason').setup()

local servers = { 'clangd', 'rust_analyzer', 'luau_lsp', 'jdtls' }


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
	require('lspconfig')[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities
	}
end

require('mason-lspconfig').setup {
	ensure_installed = servers,
}

require("mason-nvim-dap").setup ({
	ensured_installed = servers,
	automatic_installation = true,
})
local dap = require("dap")
dap.configurations.java = {
  {
    type = "java",
    request = "launch",
    name = "RunOrTest"
  },
}

dap.adapters.java = {

}


require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})
require('fidget').setup()

