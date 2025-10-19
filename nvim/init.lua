-- Accurate colors
vim.opt.termguicolors = true

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw (vim native file navigator) to avoid conflicts
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Basic options
vim.opt.number = true        -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.shiftwidth = 4       -- Number of spaces for indentation
vim.opt.tabstop = 4          -- Number of spaces per tab

-- Disable line wrapping globally
-- This is particulary useful when you have a tree and the lines get wrapped
vim.opt.wrap = false
vim.opt.linebreak = false
vim.opt.breakindent = false

-- Make horizontal scrolling smoother
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 8

-- Colorscheme
vim.o.background = "light"
vim.cmd('colorscheme tatami')

-- 80 columns
vim.opt.colorcolumn = "80"

-- lazy.nvim configuration
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "tpope/vim-fugitive",
    },
    lazy = false,
    config = function()
      require("neo-tree").setup({
        window = { width = 28,},
        close_if_last_window = true,
        source_selector = {
            winbar = false,
            statusline = false,
        },
        filesystem = { follow_current_file = { enabled = true } },
      })
      -- Keymaps (use your <Space> leader)

      -- (leader + e) opens tree without stealing focus
      -- This is the due to the :Neotree show command
      vim.keymap.set("n", "<leader>e", function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "neo-tree" then
                vim.cmd("Neotree close")
                return
            end
        end
        vim.cmd("Neotree show") 
      end, { silent = true, desc = "Toggle Neo-tree without focus" })
    end,
  },
  {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
        globalstatus = true,
        disabled_filetypes = { "neo-tree" }, -- hides statusline in Neo-tree
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
  },
})
