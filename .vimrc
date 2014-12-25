" Some plugins require this to be set before they are loaded.
set nocompatible

""" Plugins
call plug#begin('~/.vim/bundles')

Plug 'ap/vim-you-keep-using-that-word'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-after-object'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-fnr'
Plug 'justinmk/vim-sneak'
Plug 'kchmck/vim-coffee-script'
Plug 'kmalloc/conque'
Plug 'tommcdo/vim-exchange'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'whatyouhide/vim-lengthmatters'

Plug 'kana/vim-textobj-user'
Plug 'thinca/vim-textobj-between'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'beloglazov/vim-textobj-punctuation'
Plug 'Julian/vim-textobj-variable-segment'

call plug#end()


""" Settings
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
set incsearch
set showmatch
set hlsearch
set ttimeoutlen=1000
set textwidth=80
set wildmode=longest:full,full
set completeopt+=longest

set expandtab
set shiftwidth=2


""" Mappings
noremap <cr> o<esc>
noremap <s-cr> O<esc>
noremap <backspace> X
noremap <delete> x
noremap <home> ^
noremap <end> $

noremap Q gq
nnoremap Y y$
noremap , L
noremap ; H
noremap <c-space> <c-f>
noremap <c-s-space> <c-b>
noremap <s-down> <c-e>
noremap <s-up> <c-y>
nnoremap <c-a> ggVG
noremap <c-y> "+y

nnoremap <a-o> <c-i>

map <space> <Leader>

noremap _ -

nnoremap <Leader>w :w<cr>
nnoremap <Leader>q :wq<cr>

nnoremap <c-up> <c-w>k
nnoremap <c-down> <c-w>j
nnoremap <c-left> <c-w>h
nnoremap <c-right> <c-w>l

inoremap <c-v> <c-\><c-o>"+gP
inoremap <up>   <esc>O
inoremap <down> <esc>o
inoremap <c-esc> <c-o>

call after_object#enable('=', ':', '-', '#', ' ')


"""Sneak
map <silent> <expr> <tab> sneak#is_sneaking()
  \ ? (sneak#state().rptreverse ? '<Plug>(SneakStreakBackward)<cr>' : '<Plug>(SneakStreak)<cr>')
  \ : '<Plug>Sneak_s'
map <s-tab> <Plug>Sneak_S

map l <Plug>SneakNext
map L <Plug>SneakPrevious

nmap <c-tab>   <Plug>(SneakStreak)
nmap <c-s-tab> <Plug>(SneakStreakBackward)

let g:sneak#f_reset = 1
let g:sneak#t_reset = 1
let g:sneak#target_labels = "eshitnraoumlwgfcpyd"

map f <Plug>Sneak_f
map F <Plug>Sneak_F

map t <Plug>Sneak_t
map T <Plug>Sneak_T


""" Surround
let g:surround_no_mappings = 1
nmap dh <Plug>Dsurround
nmap ch <Plug>Csurround
nmap h  <Plug>Ysurround
nmap H  <Plug>YSurround
nmap hh <Plug>Yssurround
nmap HH <Plug>YSsurround
xmap h  <Plug>VSurround
xmap H  <Plug>VgSurround
imap <c-h> <Plug>Isurround


""" Various
nmap <Leader>e :ConqueTermTab bash<cr>
let g:ConqueTerm_PromptRegex = '^.\+\n\$ '
let g:lengthmatters_excluded = ['conque_term']

xmap u iu
omap u iu

nmap <Leader>i i<Plug>CapsLockEnable

map <Leader>a <Plug>(EasyAlign)
map <Leader>A{ <Plug>(EasyAlign)i{:

let g:fnr_flags = 'g'
let g:oblique#very_magic = 1


""" Temporary
nnoremap j :tabp<CR>
nnoremap k :tabn<CR>
