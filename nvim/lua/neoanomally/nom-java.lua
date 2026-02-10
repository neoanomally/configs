-- =============================================================================
-- 1. LSP CONFIGURATION (Modern Native API)
-- =============================================================================
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Define the lightweight server for Bazel Monorepo
vim.lsp.config('java_language_server', {
    install = {
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/java-language-server" },
    },
    filetypes = { "java" },
    root_marker = { "BUILD.bazel", "WORKSPACE", "WORKSPACE.bazel" },
    capabilities = capabilities,
    handlers = {
        -- Prevents the "bad argument #1 to ipairs" Lua error
        ['client/registerCapability'] = function(err, result, ctx, config)
            local registration = { registrations = result and result.registrations or {} }
            return vim.lsp.handlers['client/registerCapability'](err, registration, ctx, config)
        end
    },
})

-- =============================================================================
-- 2. GLOBAL LSP ATTACH LOGIC (Keybinds & Modules)
-- =============================================================================
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- Apply your custom module logic for both servers
        -- if client.name == "java_language_server" or client.name == "jdtls" then
        --     require('me.lsp.conf').on_attach(client, bufnr, {
        --         server_side_fuzzy_completion = true,
        --     })
        -- end
    end,
})

-- =============================================================================
-- 3. JAVA SWITCHER & JDTLS (Replaces ftplugin/java.lua)
-- =============================================================================
-- To use bazel in jdtls you need to clone https://github.com/salesforce/bazel-eclipse.git 
-- Once clone `mvn package`
-- 
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        vim.treesitter.start();
        -- folds, provided by Neovim
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- indentation, provided by nvim-treesitter
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        local jdtls = require("jdtls")
        -- Detect Roots
        local bazel_root = vim.fs.root(0, { "BUILD.bazel" })
        local standard_root = vim.fs.root(0, { 'gradlew', '.git', 'mvnw' })

        -- CASE A: Bazel Monorepo
        if bazel_root then
          vim.lsp.start({
            name = 'java_language_server',
            -- This ensures the process starts exactly in the directory where BUILD.bazel lives
            root_dir = bazel_root,
          }, {
            -- This tells Neovim to use the config defined in vim.lsp.config('java_language_server', ...)
            bufnr = vim.api.nvim_get_current_buf(),
            reuse_client = function(client, conf)
                return client.name == conf.name and client.root_dir == conf.root_dir
            end
          })
        end

        -- CASE B: Standard JDTLS Setup
        local config = {
            cmd = { '/opt/homebrew/Cellar/jdtls/1.56.0/bin/jdtls' },
            root_dir = standard_root,
            capabilities = capabilities,
            on_attach = function()
                -- JDTLS specific extras
                jdtls.setup_dap({ hotcodereplace = 'auto' })
                jdtls.setup.add_commands()
                -- Custom 'W' command
                -- vim.api.nvim_buf_create_user_command(bufnr, 'W', require('me.lsp.ext').remove_unused_imports, {
                --     nargs = 0,
                -- })
            end,
        }

        jdtls.start_or_attach(config)
    end,
})

-- =============================================================================
-- 4. ADDITIONAL PLUGINS
-- =============================================================================
require("auto-session").setup({
    log_level = "error",
    auto_session_suppress_dirs = { "~/Development/services-pilot" },
})

vim.lsp.set_log_level("DEBUG");

-- local lspconfig = require("lspconfig")
-- local lspconfig_util = require("lspconfig.util")
--
-- -- 1. Setup Capabilities (Standard)
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
--
-- -- 2. Define your attach logic (The modern way uses LspAttach autocommand)
-- vim.lsp.config('java_language_server', {
--   install = {
--     cmd = { vim.fn.stdpath("data") .. "/mason/packages/java-language-server/java-language-server" },
--   },
--   filetypes = { "java" },
--   root_marker = "BUILD.bazel", -- Replaces root_dir/root_pattern logic
--   capabilities = capabilities,
-- })
-- -- Note: this method of setting up lspconfig is deprecated but should still work for some time. Consider migrating to native vim.lsp.config instead (see below).
-- -- lspconfig["java_language_server"].setup({
-- --   cmd = { vim.fn.stdpath("data") .. "/mason/packages/java-language-server/java-language-server" },
-- --   capabilities = capabilities,
-- --   on_attach = on_attach,
-- --   filetypes = { "java" },
-- --   root_dir = lspconfig_util.root_pattern("BUILD.bazel"), -- If you only want to use the java-language-server for the monorepo
-- -- })
-- --
-- -- ftplugin/java.lua
-- local jdtls = require("jdtls")
-- local jdtls_setup = require("jdtls.setup")
-- local bazel_root_dir = jdtls_setup.find_root({ "BUILD.bazel" })
-- if bazel_root_dir ~= nil then
--   -- Don't activate in monorepo
--   return
-- end
--
-- local config = {
--     cmd = {'/opt/homebrew/Cellar/jdtls/1.30.0/bin/jdtls'},
--     root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
--
-- }
--
--
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if not client then
--       return
--     end
--
--     if client.name == "java_language_server" then
--       on_attach(client, vim.api.nvim_get_current_buf())
--     end
--   end,
-- })
--
-- vim.lsp.enable("java_language_server")
--
-- require("auto-session").setup({
--   log_level = "error",
--   auto_session_suppress_dirs = { "~/Development/services-pilot" },
-- })
--
--
-- config.on_attach = function(client, bufnr)
--   require('me.lsp.conf').on_attach(client, bufnr, {
--     server_side_fuzzy_completion = true,
--   })
--
--   jdtls.setup_dap({hotcodereplace = 'auto'})
--   jdtls.setup.add_commands()
--   local opts = { silent = true, buffer = bufnr }
--   local create_command = vim.api.nvim_buf_create_user_command
--   create_command(bufnr, 'W', require('me.lsp.ext').remove_unused_imports, {
--     nargs = 0,
--   })
-- end
--
-- require('jdtls').start_or_attach(config)
-- require('jdtls').start_or_attach(config.on_attach)

