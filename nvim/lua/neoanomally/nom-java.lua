-- =============================================================================
-- 1. LSP CONFIGURATION & CAPABILITIES
-- =============================================================================
local capabilities = require("cmp_nvim_lsp").default_capabilities()


-- =============================================================================
-- 2. DYNAMIC BAZEL TARGET HELPER
-- =============================================================================
local function get_dynamic_bazel_target()
    local full_path = vim.fn.expand('%:p:h')
    local repo_name = "services-pilot"
    local _, match_end = string.find(full_path, repo_name .. "/")
    
    if match_end then
        local relative_path = string.sub(full_path, match_end + 1)
        return relative_path .. ":*"
    end
    return ":*"
end

-- =============================================================================
-- 3. JAVA SWITCHER (Bazel vs JDTLS)
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        -- Treesitter Setup
        vim.treesitter.start()
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        local sdk_java_path = os.getenv("HOME") .. "/.sdkman/candidates/java/current"

        -- Detect Roots
        -- GUIDE SAYS: Use BUILD.bazel as the marker for the monorepo
        local bazel_root = vim.fs.root(0, { "BUILD.bazel", "WORKSPACE" })
        local standard_root = vim.fs.root(0, { 'gradlew', '.git', 'mvnw' })

        local jdtls = require("jdtls")
        local jdtls_config = {
            cmd = { '/opt/homebrew/bin/jdtls' }, -- Ensure this path is correct
            root_dir = standard_root,
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                jdtls.setup_dap({ hotcodereplace = 'auto' })
                jdtls.setup.add_commands()
            end,
        }

        if bazel_root then
            -- CASE A: java-language-server for Bazel
            local dynamic_target = get_dynamic_bazel_target()

            local jls_config = {
                name = "java_language_server",
                -- Guide path fix: mason/packages/... vs mason/bin/...
                cmd = { vim.fn.stdpath("data") .. "/mason/bin/java-language-server" },
                root_dir = bazel_root,
                capabilities = capabilities,
                cmd_env = {
                    JAVA_HOME = sdk_java_path,
                    PATH = sdk_java_path .. "/bin:" .. os.getenv("PATH")
                },
                settings = {
                    java = {
                        -- Narrowing scope to stop the //... query crash
                        bazelTargets = { dynamic_target }
                    }
                },
                -- Fix for the "bad argument #1 to ipairs" defect mentioned in your guide
                handlers = {
                    ['client/registerCapability'] = function(err, result, ctx, config)
                        local registration = { registrations = result and result.registrations or {} }
                        return vim.lsp.handlers['client/registerCapability'](err, registration, ctx, config)
                    end
                }
            }

            vim.lsp.start(jls_config, {
                bufnr = vim.api.nvim_get_current_buf(),
                reuse_client = function(client, conf)
                    return client.name == conf.name and client.root_dir == conf.root_dir
                end
            })
        else
          print("STARTING JDTLS: ")
            -- CASE B: Standard JDTLS Setup
            jdtls.start_or_attach(jdtls_config)
        end
    end,
})

-- =============================================================================
-- 4. ADDITIONAL SETTINGS
-- =============================================================================
require("auto-session").setup({
    log_level = "error",
    auto_session_suppress_dirs = { "~/Development/services-pilot" },
})

vim.lsp.set_log_level("DEBUG")


