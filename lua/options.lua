vim.g.mapleader = " "
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50

vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.java",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

vim.keymap.set("n", "<Leader>ds", vim.diagnostic.open_float, { desc = "Show diagnostic" })

vim.opt.exrc = true        -- enable project-local config
vim.opt.secure = true     -- restrict unsafe commands
