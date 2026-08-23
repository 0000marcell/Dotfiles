vim.fn.matchadd("TicketBlock", "```ticket\\_.*```")
vim.fn.matchadd("PromptBlock", "```prompt\\_.*```")
vim.api.nvim_set_hl(0, "TicketBlock", { fg = "#a855f7" })
vim.api.nvim_set_hl(0, "PromptBlock", { fg = "#f97316" })

-- Ensure virtual lines are always visible
vim.wo.conceallevel = 0

local ns = vim.api.nvim_create_namespace("markdown_labels")

local function add_labels()
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, line in ipairs(lines) do
    if line:match("^```ticket") then
      vim.api.nvim_buf_set_extmark(0, ns, i - 1, 0, {
        virt_lines_above = true,
        virt_lines = { { { " 🎫 TICKET ", "TicketBlock" } } },
        priority = 1000,
      })
    elseif line:match("^```prompt") then
      vim.api.nvim_buf_set_extmark(0, ns, i - 1, 0, {
        virt_lines_above = true,
        virt_lines = { { { " 💬 PROMPT ", "PromptBlock" } } },
        priority = 1000,
      })
    end
  end
end

-- Run on all relevant events
vim.api.nvim_create_autocmd({ "BufRead", "BufEnter", "InsertLeave", "InsertEnter", "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI" }, {
  buffer = 0,
  callback = add_labels,
})

-- Also run immediately
vim.defer_fn(add_labels, 10)
