local metals = require("metals")
local metals_config = metals.bare_config()

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  -- Add java to pattern if java
	pattern = { "scala", "sbt"},
	callback = function()
		require("metals").initialize_or_attach({})
	end,
	group = nvim_metals_group,
})

metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl"
  }
}

metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

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

