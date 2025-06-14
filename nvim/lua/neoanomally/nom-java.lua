local config = {
    cmd = {'/opt/homebrew/Cellar/jdtls/1.30.0/bin/jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),

}

config.on_attach = function(client, bufnr)
  require('me.lsp.conf').on_attach(client, bufnr, {
    server_side_fuzzy_completion = true,
  })

  jdtls.setup_dap({hotcodereplace = 'auto'})
  jdtls.setup.add_commands()
  local opts = { silent = true, buffer = bufnr }
  local create_command = vim.api.nvim_buf_create_user_command
  create_command(bufnr, 'W', require('me.lsp.ext').remove_unused_imports, {
    nargs = 0,
  })
end

require('jdtls').start_or_attach(config)
require('jdtls').start_or_attach(config.on_attach)
