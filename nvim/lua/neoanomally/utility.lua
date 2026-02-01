local M = {}

function M.switch_delete_prev()
  local current_buf_id = vim.api.nvim_get_current_buf();
  vim.cmd("bnext");
  vim.cmd("bd " .. current_buf_id);
end

return M;
