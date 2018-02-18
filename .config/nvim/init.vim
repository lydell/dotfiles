colorscheme industry

set clipboard+=unnamedplus
set iskeyword+=$
set mouse=a
set shell=/bin/bash
set showmatch
set undofile
set wildmode=longest:full,full

set formatoptions-=t
set formatoptions+=j

set ignorecase
set smartcase

set list
set listchars=tab:\ \ ,extends:>,precedes:<,nbsp:·

set number
set relativenumber

set splitbelow
set splitright

set expandtab
set shiftwidth=2
set tabstop=2

noremap <cr> o<esc>
noremap <s-cr> O<esc>
noremap <backspace> X
noremap <delete> x
noremap <home> ^
noremap <end> $
noremap <c-space> <c-f>
noremap <c-s-space> <c-b>
noremap <s-down> <c-e>
noremap <s-up> <c-y>
noremap Q @q

nnoremap <c-up> <c-w>k
nnoremap <c-down> <c-w>j
nnoremap <c-left> <c-w>h
nnoremap <c-right> <c-w>l
nnoremap Y y$

vnoremap <end> $h

map <space> <leader>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :wq<cr>

set statusline=
set statusline+=%-4(%m%) "[+]
set statusline+=%f:%l:%c "dir/file.js:12:5
set statusline+=%=%<
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%{&fileformat=='unix'?'':'['.&fileformat.']'}
set statusline+=%{strlen(&fileencoding)==0\|\|&fileencoding=='utf-8'?'':'['.&fileencoding.']'}
set statusline+=%r "[RO]
set statusline+=%y "[javascript]
set statusline+=[%{&expandtab?'spaces:'.&shiftwidth:'tabs:'.&tabstop}]
set statusline+=%4p%% "50%
