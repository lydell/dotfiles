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
-- First unmap space, so it never moves forward after a delay.
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable CamelCaseMotion using <leader>.
vim.g.camelcasemotion_key = "<leader>"

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

-- Go back and forward with backspace.
vim.keymap.set("n", "<bs>", "<c-o>")
vim.keymap.set("n", "<s-bs>", "<c-i>")

-- Highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
})

-- Reset iskeyword every time a buffer is entered or filetype is set.
-- This prevents for example `w` from behaving differently in .fish files.
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  callback = function()
    vim.opt_local.iskeyword = "@,48-57,_,192-255"
  end,
})

-- VSCode specific.
if vim.g.vscode then
  local vscode = require("vscode")

  -- Avoid the Output panel opening when using Sneak.
  vim.opt.cmdheight = 4

  -- Go to next and previous error in the current file.
  -- https://github.com/lydell/vscode-go-to-diagnostic
  vim.keymap.set({ "n", "x" }, "j", function ()
    vscode.action("goToDiagnostic.nextDiagnosticWithoutPopup")
  end)
  vim.keymap.set({ "n", "x" }, "k", function ()
    vscode.action("goToDiagnostic.previousDiagnosticWithoutPopup")
  end)

  -- Rename.
  vim.keymap.set({ "n", "x" }, "gR", function ()
    vscode.action("editor.action.rename")
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
      branch = "master",
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

    -- Camel case motions: <leader> w/b/e/ge
    "bkad/CamelCaseMotion",
  },
})

----- Yank and paste with indent handling -----

local function get_smallest_indent(lines)
  local smallest_indent = nil
  for _, line in ipairs(lines) do
    local match = line:match("^%s*%S")
    if match then
      local indent = match:sub(1, -2)
      if smallest_indent then
        if #indent < #smallest_indent then
          smallest_indent = indent
        end
      else
        smallest_indent = indent
      end
    end
  end
  return smallest_indent
end


-- Adjust characterwise multiline yanking so that the indentation of each line makes sense:
-- Remove the shortest indent from each line.
local function text_yank_post()
  -- Only modify characterwise yanks.
  local regtype = vim.fn.getregtype()
  if regtype ~= "v" then
    return
  end

  -- Get the start and end of the motion range.
  local start_pos = vim.api.nvim_buf_get_mark(0, "[")
  local end_pos = vim.api.nvim_buf_get_mark(0, "]")

  -- Retrieve the full lines of the selected range.
  -- The first and last lines might not be fully selected, but we still read the full lines.
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)

  -- Don’t change indentation in any way if the yanked text is just one line.
  if #lines <= 1 then
    return
  end

  local indent = get_smallest_indent(lines)
  if not indent then
    return
  end

  for i, line in ipairs(lines) do
    if i == 1 then
      -- Cut the first line to the start of characterwise selection.
      lines[i] = line:sub(start_pos[2] + 1)
    elseif i == #lines then
      -- Remove indentation and cut the last line to the end of characterwise selection.
      lines[i] = line:sub(#indent + 1, end_pos[2] + 1)
    else
      -- Remove indentation.
      lines[i] = line:sub(#indent + 1)
    end
  end

  -- Overwrite the register we just yanked into (this runs after all yanks – also deletes).
  vim.fn.setreg(vim.v.register, lines, regtype)
end

local function find_first_nonblank_indent(buf, start_line, direction)
  local line_count = vim.api.nvim_buf_line_count(buf)
  local i = start_line

  while i >= 1 and i <= line_count do
    local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
    local match = line:match("^%s*%S")
    if match then
      return match:sub(1, -2)
    end
    i = i + direction
  end

  return ""
end

local function get_indent_unit()
  if vim.bo.expandtab then
    return string.rep(" ", vim.bo.shiftwidth)
  else
    return "\t"
  end
end

local function reindent_last_paste(look_forward)
  local start_col = vim.fn.col("'[") - 1 -- 0-based
  local start_row = vim.fn.line("'[")
  local end_row = vim.fn.line("']")

  if start_row == 0 or end_row == 0 then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, start_row - 1, end_row, false)
  if #lines == 0 then
    return
  end

  local smallest_indent = get_smallest_indent(lines)
  if not smallest_indent then
    return
  end

  local target_indent
  if look_forward then
    -- Find the first nonblank indent forward.
    target_indent = find_first_nonblank_indent(buf, end_row + 1, 1)
  else
    -- Find the first nonblank indent backward.
    target_indent = find_first_nonblank_indent(buf, start_row - 1, -1)
  end

  if start_col > 0 then
    -- When pasted in the middle of a line, `target_indent` is the indent of the start line.
    target_indent = lines[1]:match("^%s*") or ""
    if #target_indent > #smallest_indent then
      -- When the first line is indented more than the rest, don’t replace any indentation
      -- in the other lines, just add to them.
      smallest_indent = ""
    end
  end

  local changed = false
  for i, line in ipairs(lines) do
    -- Leave blank or whitespace-only lines as-is.
    if not line:match("^%s*$") then
      -- Do not reindent the first line when pasted in the middle of a line and the other lines are less indented.
      if not (i == 1 and smallest_indent == "") then
        -- Replace smallest indent with target indent.
        local new_line = line:gsub("^" .. smallest_indent, target_indent, 1)
        if new_line ~= line then
          lines[i] = new_line
          changed = true
        end
      end
    end
  end

  if not changed then
    -- Indent all the rows once if unchanged.
    local indent_unit = get_indent_unit()
    for i, line in ipairs(lines) do
      lines[i] = indent_unit .. lines[i]
    end
  end

  vim.api.nvim_buf_set_lines(buf, start_row - 1, end_row, false, lines)
end

-- Adjust characterwise multiline yanking so that the indentation of each line makes sense.
vim.api.nvim_create_autocmd('TextYankPost', { callback = text_yank_post })

-- Swap p and P in visual mode: Retain register for p, and take the overpasted text on P.
-- I want to keep the register by default, and take the overpasted text only intentionally.
vim.keymap.set("v", "p", "P")
vim.keymap.set("v", "P", "p")

-- Re-indent last paste to match the first non-blank line before or after the last paste.
vim.keymap.set("n", "<leader>P", function() reindent_last_paste(false) end)
vim.keymap.set("n", "<leader>p", function() reindent_last_paste(true) end)

-- Yank without losing selection:
vim.keymap.set("v", "<leader>y", "ygv")

