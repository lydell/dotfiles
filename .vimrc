set nocompatible

call plug#begin('~/.vim/bundles')

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'kchmck/vim-coffee-script'
Plug 'ap/vim-you-keep-using-that-word'
Plug 'kmalloc/conque'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-after-object'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-fnr'
Plug 'whatyouhide/vim-lengthmatters'
Plug 'tpope/vim-capslock'

Plug 'kana/vim-textobj-user'
Plug 'thinca/vim-textobj-between'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'beloglazov/vim-textobj-punctuation'
Plug 'Julian/vim-textobj-variable-segment'

call plug#end()

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
set hlsearch
set ttimeoutlen=1000
set textwidth=80

set expandtab
set shiftwidth=2

let mapleader = "h"

autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ')

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
nmap d<Leader>s <Plug>Dsurround
nmap c<Leader>s <Plug>Csurround
nmap <Leader>s  <Plug>Ysurround
nmap <Leader>S  <Plug>YSurround
nmap <Leader>ss <Plug>Yssurround
nmap <Leader>SS <Plug>YSsurround
xmap <Leader>s  <Plug>VSurround
xmap <Leader>S  <nop>
xmap g<Leader>s <Plug>VgSurround
imap <c-s> <Plug>Isurround

nmap <Leader>e :ConqueTermTab bash<cr>

xmap u iu
omap u iu

nmap <Leader>i i<Plug>CapsLockEnable

nmap <Leader>a <Plug>(EasyAlign)
vmap <Leader>a <Plug>(EasyAlign)

let g:fnr_flags = 'g'

nnoremap j :tabp<CR>
nnoremap k :tabn<CR>

nnoremap <c-up> <c-w>k
nnoremap <c-down> <c-w>j
nnoremap <c-left> <c-w>h
nnoremap <c-right> <c-w>l
