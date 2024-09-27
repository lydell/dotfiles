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

-- VSCode specific.
if vim.g.vscode then
  local vscode = require("vscode")

  -- Avoid the Output panel opening when using Sneak.
  vim.opt.cmdheight = 4

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

    -- Camel case motions: <leader> w/b/e/ge
    "bkad/CamelCaseMotion",
  },
})

----- Yank and paste with indent handling -----

local function get_smallest_indent(lines)
  smallest_indent = nil
  for _, line in ipairs(lines) do
    match = line:match("^%s*%S")
    if match then
      indent = match:sub(1, -2)
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

local function get_indent_for_cursor_column(cursor_indentation)
  -- The indent char to use once the cursor indentation runs out:
  -- The last char of the indentation, or a space or tab depending on options.
  local last_indentation_char = cursor_indentation:sub(-1)
  if last_indentation_char == "" then
    if vim.opt.expandtab then
      last_indentation_char = " "
    else
      last_indentation_char = "\t"
    end
  end

  local tabstop = vim.o.tabstop

  -- By default, `virtcol` returns the virtual column at the _end_ of tabs.
  -- By passing the second argument, it returns both the start and end.
  -- We’re interested in the start.
  local cursor = vim.fn.virtcol(".", 1)[1] - 1

  local indentation_index = 1
  local indent_length = 0
  local indent = ""

  while indent_length < cursor do
    -- If we’re still in the cursor indentation, take the next char from there.
    local char = last_indentation_char
    if indentation_index <= #cursor_indentation then
      char = cursor_indentation:sub(indentation_index, indentation_index)
      indentation_index = indentation_index + 1
    end

    if char == "\t" then
      -- If a tab fits, use it.
      if indent_length + tabstop <= cursor then
        indent = indent .. char
        indent_length = indent_length + tabstop
      else
        -- Otherwise fill the rest with spaces.
        indent = indent .. string.rep(" ", cursor - indent_length)
        indent_length = indent_length + cursor - indent_length
      end
    else
      -- All other whitespace is assumed to be of length 1.
      indent = indent .. char
      indent_length = indent_length + 1
    end
  end

  return indent
end

-- Yank and remove the shortest indent from each line.
local function yank()
  -- Get the start and end of the motion range.
  local start_pos = vim.api.nvim_buf_get_mark(0, "[")
  local end_pos = vim.api.nvim_buf_get_mark(0, "]")

  -- Retrieve the text in the selected range.
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)

  local regtype = vim.fn.getregtype()

  -- Don’t change indentation in any way if the text is characterwise and just one line.
  if #lines <= 1 and regtype == "v" then
    return
  end

  local indent = get_smallest_indent(lines)
  if not indent then
    return
  end

  for i, line in ipairs(lines) do
    if regtype == "v" and i == 1 then
      lines[i] = line:sub(start_pos[2] + 1)
    elseif regtype == "v" and i == #lines then
      lines[i] = line:sub(#indent + 1, end_pos[2] + 1)
    else
      lines[i] = line:sub(#indent + 1)
    end
  end

  -- Overwrite the register we just yanked into (this runs after all yanks – also deletes).
  vim.fn.setreg(vim.v.register, lines, regtype)
end

-- Paste and re-indent each line.
local function paste(command, linewise_at_column)
  local pasted = vim.fn.getreg(vim.v.register, 1, 1)

  local regtype = ""
  if linewise_at_column then
    regtype = "V"
  else
    regtype = vim.fn.getregtype()
  end

  -- Don’t change indentation in any way if the text is characterwise and just one line.
  if #pasted <= 1 and regtype == "v" then
    vim.cmd('normal! "' .. vim.v.register .. command)
    return
  end

  -- These correspond to the first or last line depending on whether you selected up or down.
  local v_start = vim.fn.getpos("v")[2]
  local v_end = vim.fn.getpos(".")[2]
  local selection = vim.api.nvim_buf_get_lines(0, math.min(v_start, v_end) - 1, math.max(v_start, v_end), true)

  local selection_indent = ""
  if linewise_at_column and vim.api.nvim_get_mode().mode == "n" then
    selection_indent = get_indent_for_cursor_column(selection[1]:match("^%s*"))
  else
    selection_indent = get_smallest_indent(selection) or selection[1]:match("^%s*") or ""
  end

  local pasted_indent = get_smallest_indent(pasted) or ""

  local new_pasted = {}
  for i, line in ipairs(pasted) do
    if line == "" then
      new_pasted[i] = line
    elseif i == 1 and regtype == "v" then
      new_pasted[i] = line:sub(#pasted_indent + 1)
    else
      new_pasted[i] = selection_indent .. line:sub(#pasted_indent + 1)
    end
  end

  -- Temporarily set the register with the re-indented text and execute the command.
  vim.fn.setreg(vim.v.register, new_pasted, regtype)
  vim.cmd('normal! "' .. vim.v.register .. command)
  vim.fn.setreg(vim.v.register, pasted, regtype)
  -- Note: Since we always reset the register after the command, we change the
  -- default behavior of `p`, which otherwise replaces the default register with
  -- the text that was pasted over.
end

vim.api.nvim_create_autocmd('TextYankPost', { callback = yank })
vim.keymap.set({"n", "v"}, "p", function () paste("p") end)
vim.keymap.set({"n", "v"}, "gp", function () paste("gp") end)
vim.keymap.set({"n", "v"}, "P", function () paste("P") end)
vim.keymap.set({"n", "v"}, "gP", function () paste("gP") end)
-- Paste anything as linewise, at the cursor column if in Normal mode:
vim.keymap.set("n", "<leader>p", function () paste("p", true) end)
vim.keymap.set("n", "<leader>P", function () paste("P", true) end)
-- Yank without losing selection:
vim.keymap.set("v", "<leader>y", "ygv")
