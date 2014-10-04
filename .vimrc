set nocompatible              " be iMproved
filetype off                  " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'
" NOTE: comments after Bundle commands are not allowed.

Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-surround'
Bundle 'justinmk/vim-sneak'
Bundle 'kchmck/vim-coffee-script'
Bundle 'ap/vim-you-keep-using-that-word'

filetype plugin indent on     " required!

set guioptions-=T
set guioptions-=m
colorscheme desert
set cursorline
" Automatically remove trailing whitespace on save.
autocmd BufWritePre * :%s/\s\+$//e
set relativenumber
set modelines=0
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
" set hlsearch
set ttimeoutlen=1000

set expandtab
set shiftwidth=2

nnoremap <cr> o<esc>
vnoremap <cr> o<esc>
nnoremap <s-cr> O<esc>
vnoremap <s-cr> O<esc>
nnoremap <backspace> X
vnoremap <backspace> X
nnoremap <delete> x
vnoremap <delete> x
noremap <home> ^
noremap <end> $

noremap Q gq
nnoremap Y y$
nnoremap , L
vnoremap , L
nnoremap ; H
vnoremap ; H
nnoremap <space> <c-f>
vnoremap <space> <c-f>
nnoremap <s-space> <c-b>
vnoremap <s-space> <c-b>
nnoremap <c-a> ggVG
nnoremap <c-c> "+y
vnoremap <c-c> "+y

inoremap <c-v> <c-\><c-o>"+gP
inoremap <up>   <esc>O
inoremap <down> <esc>o
inoremap <tab> <c-n>
inoremap <s-tab> <c-p>
inoremap <c-esc> <c-o>

nmap <silent> <expr> <tab> sneak#is_sneaking()
  \ ? (sneak#state().rptreverse ? '<Plug>(SneakStreakBackward)<cr>' : '<Plug>(SneakStreak)<cr>')
  \ : '<Plug>Sneak_s'
xmap <silent> <expr> <tab> sneak#is_sneaking()
  \ ? (sneak#state().rptreverse ? '<Plug>(SneakStreakBackward)<cr>' : '<Plug>(SneakStreak)<cr>')
  \ : '<Plug>Sneak_s'
nmap <s-tab> <Plug>Sneak_S
xmap <s-tab> <Plug>Sneak_S
omap <tab>   <Plug>Sneak_s
omap <s-tab> <Plug>Sneak_S

nmap l <Plug>SneakNext
nmap L <Plug>SneakPrevious
xmap l <Plug>SneakNext
xmap L <Plug>SneakPrevious
omap l <Plug>SneakNext
omap L <Plug>SneakPrevious

nmap <c-tab>   <Plug>(SneakStreak)
nmap <c-s-tab> <Plug>(SneakStreakBackward)

let g:sneak#f_reset = 1
let g:sneak#t_reset = 1
let g:sneak#target_labels = "eshitnraoumlwgfcpyd"

nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T

let g:surround_no_mappings = 1
nmap dh <Plug>Dsurround
nmap ch <Plug>Csurround
nmap h  <Plug>Ysurround
nmap H  <Plug>YSurround
nmap hh <Plug>Yssurround
nmap HH <Plug>YSsurround
xmap h  <Plug>VSurround
xmap H  <nop>
xmap gh <Plug>VgSurround
imap <c-h> <Plug>Isurround

nnoremap j :tabp<CR>
nnoremap k :tabn<CR>

nnoremap <c-up> <c-w>k
nnoremap <c-down> <c-w>j
nnoremap <c-left> <c-w>h
nnoremap <c-right> <c-w>l
