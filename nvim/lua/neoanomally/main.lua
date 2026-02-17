-- =============================================================================
--  1. GLOBALS & OPTIONS
-- =============================================================================
vim.g.mapleader = ';'
local utility = require("neoanomally.utility")
local telescope_builtin = require("telescope.builtin")

-- Visual Options
vim.cmd('highlight VertSplit guifg=#FFFFFF')
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#7f7f7f" })
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#7f7f7f', bg = 'none' })
vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white' })

-- =============================================================================
--  2. UI & THEMES
-- =============================================================================
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
    },
}

require("tokyonight").setup({
    style = "night",
    transparent = true,
    terminal_colors = true,
    day_brightness = 0.2
})
vim.cmd[[colorscheme tokyonight]]

-- =============================================================================
--  3. GENERAL PLUGINS (Treesitter, Telescope, etc.)
-- =============================================================================
require('Comment').setup()
require('fidget').setup()
require('vim-coach').setup()

require('nvim-treesitter').setup()
require('nvim-treesitter').install { 'rust', 'javascript', 'python', 'java', 'lua' }

require('telescope').setup({
    defaults = {
        file_ignore_patterns = { "^./.git/", "^node_modules", "target" },
        layout_config = { preview_cutoff = 10 },
    }
})
pcall(require('telescope').loadextension, 'fzf')

-- =============================================================================
--  4. MASON & LSP CONFIGURATION
-- =============================================================================
require('mason').setup()

-- Note: Ensure you do NOT have a default handler here for rust_analyzer if using rustaceanvim
require('mason-lspconfig').setup({
    ensure_installed = { "markdown_oxide", "clangd", "pyright", "rust_analyzer" },
    automatic_enable = {
      exclude = { "rust_analyzer", "jdtls", "java_language_server" }
    },
})

-- Capabilities Setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


-- HOVER configuration for LSP. 
-- Decorating the window
local _default_buf_hover = vim.lsp.buf.hover;
vim.lsp.buf.hover = function(opts)
  opts = opts or { }
  opts.border = "rounded"
  return _default_buf_hover(opts)
end

-- This is configuration for the boarder when doing [O]pen [D]iagnostics
vim.diagnostic.config ({
  float = {
    border = {
      {"╔", "FloatBorder"},
      {"═", "FloatBorder"},
      {"╗", "FloatBorder"},
      {"║", "FloatBorder"},
      {"╝", "FloatBorder"},
      {"═", "FloatBorder"},
      {"╚", "FloatBorder"},
      {"║", "FloatBorder"}
    },
  }
})


-- Server Configs
-- NOTE: I am assuming 'vim.lsp.config' is a custom wrapper you use. 
-- Standard Neovim uses require('lspconfig').server.setup({})
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim', 'require' } }
        }
    }
})

vim.lsp.config('clangd', {
    root_markers = { '.clang-format', 'compile_commands.json' },
    filetypes = { 'c' },
    capabilities = {
        textDocument = {
            completion = { completionItem = { snippetSupport = true } }
        }
    },
})

vim.lsp.config('pyright', {})

local markdown_capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
vim.lsp.config('markdown-oxide', {
    pattern = { 'md' },
    capabilities = vim.tbl_deep_extend('force', markdown_capabilities, {
        workspace = { didChangeWatchedFiles = { dynamicRegistration = true } }
    }),
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'LspAttach', 'BufEnter' }, {
            buffer = bufnr,
            callback = function ()
                -- Simple check for CodeLens support
                if client.server_capabilities.codeLensProvider then
                    vim.lsp.codelens.refresh({bufnr = 0})
                end
            end
        })
        vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
    end
})

-- Enable Servers (Note: rust_analyzer is deliberately missing here if handled by rustaceanvim)
vim.lsp.enable({ 'pyright', 'lua_ls', 'clangd', 'markdown-oxide' })

-- Completion Setup
vim.o.completeopt = 'menuone,noselect'
require'cmp'.setup {
    enabled = true,
    autocomplete = true,
    source = {
        path = true,
        buffer = true,
        nvim_lsp = true,
    },
    -- ... your other cmp options ...
}

-- =============================================================================
--  5. DAP (DEBUGGING)
-- =============================================================================
local dap = require("dap")

-- Python DAP
require("dap-python").setup("/Users/mesanders/.virtualenvs/debugpy/bin/python3")
-- require("dap-python").setup("uv") -- Duplicate setup? Choose one.

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = "Launch file",
        program = "${file}",
        pythonPath = function() return '/usr/bin/python' end,
    },
}

-- Java DAP
dap.configurations.java = {
    {
        type = "java",
        request = "launch",
        name = "RunOrTest"
    },
}

-- =============================================================================
--  6. AUTOCMDS
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "rust", "lua" },
    callback = function()
        vim.cmd("colorscheme jellybeans")
        -- Example: vim.api.nvim_set_hl(0, "@keyword", { fg = "#ff0000", style = "bold" })
    end,
})

-- =============================================================================
--  7. KEYMAPS
-- =============================================================================

-- -- Telescope
vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', function()
    telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = true
    })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {desc= '[S]earch [F]iles'})
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, {desc = '[S]earch [H]elp'})
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = '[F]ind [B]uffers' })

-- -- LSP & Diagnostics
vim.keymap.set('n', '<leader>od', vim.diagnostic.open_float, { desc = '[O]pen [D]iagnostics' })
vim.keymap.set('n', '<leader>gd', vim.diagnostic.get, { desc= '[G]et [D]iagnostics' }) -- Note: 'gd' is usually Goto Definition
vim.keymap.set('n', '<leader>gp', function() vim.diagnostic.goto_prev({ wrap = false }) end, { desc = '[G]oto [P]review' })
vim.keymap.set('n', '<leader>gn', function() vim.diagnostic.goto_next({ wrap = false }) end, { desc = '[G]oto [N]ext' })

vim.keymap.set('n', '<leader>ho', vim.lsp.buf.hover,{ desc = 'Signature h[O]ver' } )
vim.keymap.set('n', '<leader>si', vim.lsp.buf.signature_help, { desc = '[SI]gnature help' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,{ desc = '[R]e[n]ame' } )
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {desc = '[C]ode [A]ction' })
vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, {desc = '[C]ode[L]ens Run' })

-- -- GoTo Navigation
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {desc = '[G]oto [D]efinition.'}) -- Warning: Overwrites previous <leader>gd
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {desc = '[G]oto [D]efinition.'})
vim.keymap.set('n', '<leader>gI', vim.lsp.buf.implementation, {desc = '[G]oto [I]mplementation'})
vim.keymap.set('n', '<leader>gr', telescope_builtin.lsp_references, { desc = '[G]oto [R]eference'})
vim.keymap.set('n', '<leader>ds', telescope_builtin.lsp_document_symbols, {desc = '[D]ocument [S]ymbol'})
vim.keymap.set('n', '<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, {desc = '[W]orkspace [S]ymbol'})
vim.keymap.set('n', '<leader>dms', ":lua require('telescope.builtin').lsp_document_symbols({ symbols = {'Function', 'Method'} })<CR>", { noremap = true, silent = true })

-- -- Utility & Misc
vim.keymap.set('n', '<leader>nt', '<cmd>NERDTreeFocus<cr>', {desc = 'Open [N]erd [T]ree.' })
vim.keymap.set('n', '<leader>bdn', utility.switch_delete_prev, { desc = '[B]uffer [D]elete [N]ext' })
vim.keymap.set('n', '<leader>mt', function() require("telescope").extensions.metals.commands() end, { desc = "[M]etals [T]elescope" })

-- -- DAP Keymaps
vim.keymap.set('n', '<Leader>df', function() require('dap.ui.widgets').centered_float(require('dap.ui.widgets').frames) end, { desc = '[D]ap [F]rames' } )
vim.keymap.set('n', '<Leader>dSc', function() require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes) end, { desc = '[D]ap [S]copes' }) -- Renamed to avoid clash with Document Symbol
vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = '[D]ap [C]ontinue' } )
vim.keymap.set('n', '<leader>dr', function() require('dap').repl.toggle() end, { desc = '[D]ap Open [R]epl' } )
vim.keymap.set('n', '<leader>dK', function() require('dap').hover() end, { desc = '[D]ap Hover' })
vim.keymap.set('n', '<leader>dt', function() require('dap').toggle_breakpoint() end, { desc = '[D]ap Breakpoint [T]oggle' })
vim.keymap.set('n', '<leader>dso', function() require('dap').step_over() end, { desc = '[D]ap [S]tep[O]ver' } )
vim.keymap.set('n', '<leader>dsi', function() require('dap').step_into() end, { desc = '[D]ap [S]tep [I]nto' })
vim.keymap.set('n', '<Leader>dsb', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = '[D]ap [S]et [B]reakpoint' })
