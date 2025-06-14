
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "scala", "sbt", "java" },
	callback = function()
		require("metals").initialize_or_attach({})
	end,
	group = nvim_metals_group,
})

metals_config = require("metals").bare_config()
  metals_config.settings = {
    showImplicitArguments = true,
    excludedPackages = {
      "akka.actor.typed.javadsl",
      "com.github.swagger.akka.javadsl"
	}
}

metals_config.init_options.statusBarProvider = "on"

metals_config.on_attach = function(client, bufnr)
	require("metals").setup_dap()


	-- all workspace diagnostics
	-- map("n", "<leader>aa", vim.diagnostic.setqflist)

	-- all workspace errors
	
	vim.keymap.set("n", "<leader>ae", function()
		vim.diagnostic.setqflist({ severity = "E" })
	end)

	-- all workspace warnings
vim.keymap.set("n", "<leader>aw", function()
		vim.diagnostic.setqflist({ severity = "W" })
	end)

	-- buffer diagnostics only
	vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist)


	vim.keymap.set('n', '[c', function()
		vim.diagnostic.goto_prev({ wrap = false })
	end)

	vim.keymap.set('n', ']c', function()
		vim.diagnostic.goto_next({ wrap = false })
	end)

	
	vim.keymap.set('n', '<leader>dc', function()
		require('dap').continue()
	end)

	vim.keymap.set('n', '<leader>dK', function()
		require('dap').hover()
	end)

	vim.keymap.set('n', '<leader>dt', function()
		require('dap').toggle_breakpoint()
	end)

	vim.keymap.set('n', '<leader>dso', function()
		require('dap').step_over()
	end)
	
	vim.keymap.set('n', '<leader>dsi', function()
		require('dap').step_into()
	end)
	
	-- Example mappings for usage with nvim-dap. If you don't use that, you can
	-- skip these
	vim.keymap.set("n", "<leader>dr", function()
		require("dap").repl.toggle()
	end)

	vim.keymap.set("n", "<leader>dl", function()
		require("dap").run_last()
	end)
end


-- completion related settings
-- This is similiar to what I use
local cmp = require("cmp")
cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
  },
  snippet = {
    expand = function(args)
      -- Comes from vsnip
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    -- None of this made sense to me when first looking into this since there
    -- is no vim docs, but you can't have select = true here _unless_ you are
    -- also using the snippet stuff. So keep in mind that if you remove
    -- snippets you need to remove this select
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- I use tabs... some say you should stick to ins-completion but this is just here as an example
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  }),
})

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Debug settings if you're using nvim-dap
local dap = require("dap")

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
	{
		type = "scala",
		request = "launch",
		name = "Test File",
		console = "integratedTerminal",
		metals = {
			runType = "testFile",
		},
	},
}


metals_config.settings = {
	testUserInterface = "Test Explorer",
}


-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})


-- TODO: Write configuration for debug adapter protocol so that I can run and
-- execute tests
-- TODO: Do two things 1) A Debug Adapter && 2) DAP Configuration (how to
-- attach)
-- local nmap = function(keys, func, desc)
-- 	if desc then
-- 		desc = 'LSP: ' .. doc
-- 	end
-- 
-- 	vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
-- end
-- 
-- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
-- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

-- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
-- nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
-- nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')	
-- nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
-- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbol')
-- nmap('<leaders>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")

vim.keymap.set('n', '<leader><C-d>', function()
	dapui.toggle()
end, { desc = "Toggle [D]apui" })

-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close()
-- end

