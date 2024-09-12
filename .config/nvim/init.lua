-- Copied from: https://lazy.folke.io/installation (Single File Setup)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Change <leader> from backslash to space.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Default indentation settings.
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Enable line numbers.
vim.opt.number = true

-- Use system clipboard by default.
-- Setting it this weird way is apparently faster: https://github.com/LazyVim/LazyVim/discussions/4112
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Indent soft-wrapped lines.
vim.opt.breakindent = true

-- Case-insensitive searching unless \C or one or more capital letters in the search term.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Put new splits to the right and below the current.
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Show whitespace.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Clear search highlight.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Use ctrl+<hjkl> to switch between splits.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

-- Show file explorer by pressing `-`. Put the original `-` on `_` instead.
if not vim.g.vscode then
  vim.keymap.set("n", "-", "<CMD>Oil<CR>")
end
vim.keymap.set("n", "_", "-")

-- Highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
})

-- VSCode specific.
if vim.g.vscode then
  local vscode = require("vscode")

  -- Go to next and previous error in the current file.
  vim.keymap.set({ "n", "x" }, "j", function ()
    vscode.action("editor.action.marker.next")
  end)
  vim.keymap.set({ "n", "x" }, "k", function ()
    vscode.action("editor.action.marker.prev")
  end)

  -- Multiple cursors only really works in Insert Mode unfortunately.
  -- This makes cmd+d usable from Normal mode (but you can only use insert mode).
  -- https://github.com/vscode-neovim/vscode-neovim#vscodewith_insertcallback
  vim.keymap.set({ "n", "x", "i" }, "<M-d>", function()
    vscode.with_insert(function()
      vscode.action("editor.action.addSelectionToNextFindMatch")
    end)
  end)
end

-- The lazy.nvim docs recommend configuring stuff before loading the plugins where possible.
require("lazy").setup({
  spec = {
    {
      -- Colorscheme loaded as described in https://lazy.folke.io/spec/examples
      "Mofiqul/vscode.nvim",
      lazy = false,
      priority = 1000,
      cond = not vim.g.vscode,
      config = function()
        vim.cmd([[colorscheme vscode]])
      end,
    },

    -- Using this for its expand/shrink selection commands.
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function ()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
          ensure_installed = { "bash", "css", "csv", "diff", "dockerfile", "elm", "fish", "gleam", "haskell", "html", "javascript", "jsdoc", "json", "lua", "luadoc", "make", "markdown", "markdown_inline", "python", "regex", "sql", "tsv", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml" },
          highlight = {
            enable = not vim.g.vscode,
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "h",
              node_incremental = "h", -- higher
              node_decremental = "l", -- lower
            },
          },
        })
      end,
    },

    -- Motions for “falling down or up”. Like W and B, but vertically.
    -- Originally from Vim Mode Plus for Atom.
    {
      "pchampio/vim-edgemotion",
      config = function()
        vim.keymap.set("n", "ö", "<Plug>(edgemotion-j)")
        vim.keymap.set("n", "Ö", "<Plug>(edgemotion-k)")
      end,
    },

    -- Don’t move the cursor after yanking.
    {
      "svban/YankAssassin.nvim",
      opts = {
        auto_normal = true,
        auto_visual = true,
      },
    },

    -- File explorer.
    {
      "stevearc/oil.nvim",
      opts = {
        view_options = {
          show_hidden = true,
        },
      },
      cond = not vim.g.vscode,
    },

    -- Add (ys), remove (ds) and change (cs) parentheses and similar around things.
    -- In visual mode: S.
    { "kylechui/nvim-surround", opts = {} },

    -- Changes s to a two-letter f.
    "justinmk/vim-sneak",

    -- Swap two pieces of text, with cx.
    -- In visual mode: X.
    "tommcdo/vim-exchange",

    -- Makes { and } work even if a blank line contains spaces.
    "dbakker/vim-paragraph-motion",

    -- Makes ga print unicode info about the character under the cursor.
    "tpope/vim-characterize",

    -- Guesses indentation settings.
    "tpope/vim-sleuth",
  },
})
