-- TODO: Organize this file.
local utility = require("neoanomally.utility");
local telescope_builtin = require("telescope.builtin");

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
require('mason-lspconfig').setup({
  ensure_installed = { "markdown_oxide", "clangd", "rust_analyzer", "pyright", "jdtls" }
})
vim.g.mapleader = ';'
require('telescope').setup({
    defaults = {
        file_ignore_patterns = { "^./.git/", "^node_modules", "target" },
				layout_config = {
					preview_cutoff = 10,
				},
    }
})

require("tokyonight").setup({
  -- "storm" | "moon" | "night" | "day"
  style = "night",

  -- Other config options...
  transparent = true,
  terminal_colors = true,
  day_brightness = 0.2
})

-- Load the colorscheme after the setup
vim.cmd[[colorscheme tokyonight]]
vim.cmd('highlight VertSplit guifg=#FFFFFF')
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#7f7f7f" })
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#7f7f7f', bg = 'none' })

require('nvim-treesitter').setup()
require('nvim-treesitter').install { 'rust', 'javascript', 'python', 'java', 'lua' }


pcall(require('telescope').loadextension, 'fzf')


vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white' })
vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
	telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = true
})
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {desc= '[S]earch [F]iles'})
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, {desc = '[S]earch [H]elp'})
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = '[F]ind [B]uffers' })
vim.keymap.set('n', '<leader>od', vim.diagnostic.open_float, { desc = '[O]pen [D]iagnostics' })
vim.keymap.set('n', '<leader>gd', vim.diagnostic.get, { desc= '[G]et [D]iagnostics' })

vim.keymap.set('n', '<leader>nt', '<cmd>NERDTreeFocus<cr>', {desc = 'Open [N]erd [T]ree.' })

-- These are functions mostly for metals

vim.keymap.set('n', '<leader>ho', vim.lsp.buf.hover,{ desc = 'Signature h[O]ver' } )
vim.keymap.set('n', '<leader>si', vim.lsp.buf.signature_help, { desc = '[SI]gnature help' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,{ desc = '[R]e[n]ame' } )
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {desc = '[C]ode [A]ction' })
vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, {desc = '[C]ode[L]ens Run' })

vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {desc = '[G]oto [D]efinition.'})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {desc = '[G]oto [D]efinition.'})
vim.keymap.set('n', '<leader>gI', vim.lsp.buf.implementation, {desc = '[G]oto [I]mplementation'})

-- vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definitions, { desc = 'Type [D]efinition' })
vim.keymap.set('n', '<leader>gr', telescope_builtin.lsp_references, { desc = '[G]oto [R]eference'})
vim.keymap.set('n', '<leader>ds', telescope_builtin.lsp_document_symbols, {desc = '[D]ocument [S]ymbol'})
vim.keymap.set('n', '<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, {desc = '[W]orkspace [S]ymbol'})
vim.api.nvim_set_keymap(
  'n',
  '<leader>dms',
  ":lua require('telescope.builtin').lsp_document_symbols({ symbols = {'Function', 'Method'} })<CR>",
  { noremap = true, silent = true }
)
vim.keymap.set('n', '<leader>gp', function()
	vim.diagnostic.goto_prev({ wrap = false })
end, { desc = '[G]oto [P]review' })

vim.keymap.set('n', '<leader>gn', function()
	vim.diagnostic.goto_next({ wrap = false })
end, { desc = '[G]oto [N]ext' })

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

vim.keymap.set('n', '<leader>bdn', utility.switch_delete_prev, { desc = '[B]uffer [D]elete [N]ext' })

require('mason').setup()



local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT'
      },
      diagnostics = {
        globals = {
          'vim',
          'require'
        }
      }
    }
  }
})

vim.lsp.config('clangd', {
  root_markers = { '.clang-format', 'compile_commands.json' },
  filetypes = { 'c' },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        }
      }
    }
  }
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust", "lua"},-- Target Rusts
  callback = function()
    vim.cmd("colorscheme jellybeans")
    -- Change the color of the '@keyword' highlight group for Python files
    -- vim.api.nvim_set_hl(0, "@keyword", { fg = "#ff0000", style = "bold" }) -- Example: bold red keywords
    -- Change the color of the 'Comment' group for Python files
    -- vim.api.nvim_set_hl(0, "Comment", { fg = "#00ff00", style = "italic" }) -- Example: green italic comments
  end,
})


local dap = require("dap")
dap.configurations.java = {
  {
    type = "java",
    request = "launch",
    name = "RunOrTest"
  },
}

dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Launch file";
    program = "${file}";
    pythonPath = function()
      return '/usr/bin/python'
    end;
  },
}

require("dap-python").setup("/Users/mesanders/.virtualenvs/debugpy/bin/python3")
require("dap-python").setup("uv")
-- 1. Configure the server (Optional: only if you need to customize settings)
vim.lsp.config('pyright', {
  -- If you have a custom on_attach function, move it to an LspAttach autocmd (see below)
  -- or include it here if supported by your specific Nvim version's config merging
})

-- An example nvim-lspconfig capabilities setting
local markdown_capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.lsp.config('markdown-oxide', {
    -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
    -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
    pattern = { 'md' },
    capabilities = vim.tbl_deep_extend(
        'force',
        markdown_capabilities,
        {
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            },
        }
    ),
    on_attach = function(client, bufnr)
      local function check_codelens_support()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      for _, c in ipairs(clients) do
        if c.server_capabilities.codeLensProvider then
          return true
        end
      end
      return false
      end

      vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'LspAttach', 'BufEnter' }, {
      buffer = bufnr,
      callback = function ()
        if check_codelens_support() then
          vim.lsp.codelens.refresh({bufnr = 0})
        end
      end
      })
      -- trigger codelens refresh
      vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })

    end
})

-- 2. Enable the server
vim.lsp.enable({ 'pyright', 'lua_ls', 'clangd', 'markdown-oxide' })

vim.o.completeopt = 'menuone,noselect'
require'cmp'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;

  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
  };

}

require('fidget').setup()
require('vim-coach').setup()


