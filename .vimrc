" Some plugins require this to be set before they are loaded.
set nocompatible

""" Plugins
call plug#begin('~/.vim/bundles')

Plug 'ap/vim-you-keep-using-that-word'
Plug 'bkad/CamelCaseMotion'
Plug 'mileszs/ack.vim'
Plug 'myint/indent-finder'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-fnr'
Plug 'junegunn/seoul256.vim'
Plug 'justinmk/vim-sneak'
Plug 'tommcdo/vim-exchange'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'wellle/targets.vim'
Plug 'whatyouhide/vim-lengthmatters'

Plug 'kchmck/vim-coffee-script'

call plug#end()


""" Settings
" UI
set guioptions-=T
set guioptions-=m
set cursorline
set relativenumber
let g:seoul256_background = 234
colorscheme seoul256

" IO
set autoread
set directory-=.
set undofile
set undodir=~/.tmp

" Search
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

" Indent
set expandtab
set shiftwidth=2
set tabstop=4
set autoindent
filetype indent off

" Misc
set backspace=indent,eol,start
set completeopt+=longest
set display=lastline
set formatoptions+=j
set nojoinspaces
set nostartofline
set nrformats-=octal
set showcmd
set textwidth=80
set wildmenu
set wildmode=longest:full,full

" Turn off /* vim: set foo=bar: */
set modelines=0

" Trailing whitespace (and tabs).
set list
set listchars=tab:▸\ ,trail:¬,extends:>,precedes:<,nbsp:·
nmap <leader>l :set list!<cr>
nmap <leader>s :%s/\s\+$//e<cr>


""" Mappings
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
nnoremap <c-up> <c-w>k
nnoremap <c-down> <c-w>j
nnoremap <c-left> <c-w>h
nnoremap <c-right> <c-w>l

" Y like C and D
nnoremap Y y$
" qq to record, Q to replay
nnoremap Q @q
" vim-vinegar takes `-`
noremap _ -

" Ctrl-{a,c,v} stand-in
nnoremap <c-a> ggVG
noremap <a-y> "+y
noremap <a-s-y> "+y$
inoremap <a-v> <c-r>+

" Better undo
inoremap <C-U> <C-G>u<C-U>
inoremap <CR> <C-G>u<CR>

" Insert mode
inoremap <c-esc> <c-o>

" <Leader>
map <space> <Leader>
nnoremap <Leader>w :w<cr>
nnoremap <Leader>q :wq<cr>

" See Sneak and Surround below
noremap , L
noremap ; H


"""Sneak
map <silent> <expr> <tab> sneak#is_sneaking()
  \ ? (sneak#state().rptreverse ? '<Plug>(SneakStreakBackward)<cr>' : '<Plug>(SneakStreak)<cr>')
  \ : '<Plug>Sneak_s'
map <s-tab> <Plug>Sneak_S

map l <Plug>SneakNext
map L <Plug>SneakPrevious

nmap <c-tab>   <Plug>(SneakStreak)
nmap <c-s-tab> <Plug>(SneakStreakBackward)

" Mapping <tab> unfortunately kills <c-i>.
nnoremap <a-o> <c-i>

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


""" CameCaseMotion
map <silent> <a-w> <Plug>CamelCaseMotion_w
map <silent> <a-b> <Plug>CamelCaseMotion_b
map <silent> <a-e> <Plug>CamelCaseMotion_e
omap <silent> i<a-w> <Plug>CamelCaseMotion_iw
vmap <silent> i<a-w> <Plug>CamelCaseMotion_iw
omap <silent> i<a-b> <Plug>CamelCaseMotion_ib
vmap <silent> i<a-b> <Plug>CamelCaseMotion_ib
omap <silent> i<a-e> <Plug>CamelCaseMotion_ie
vmap <silent> i<a-e> <Plug>CamelCaseMotion_ie


""" Various
imap <a-c> <Plug>CapsLockToggle

map <Leader>a :Ack
map <Leader>n :FZF<cr>
map <Leader>i <Plug>(EasyAlign)

let g:fnr_flags = 'g'
let g:fzf_launcher = 'xterm -bg "\#252525" -fg "\#d9d9d9" -fa Monospace -fs 10 -geometry 100x50 -e bash -ic %s'


""" Status line
set laststatus=2
set statusline=
set statusline+=%-4(%m%) "[+]
set statusline+=%f:%l:%c "dir/file.js:12:5
set statusline+=%=%<
set statusline+=%{CapsLockStatusline()}
set statusline+=%{&fileformat=='unix'?'':'['.&fileformat.']'}
set statusline+=%{strlen(&fileencoding)==0\|\|&fileencoding=='utf-8'?'':'['.&fileencoding.']'}
set statusline+=%r "[RO]
set statusline+=%y "[javascript]
set statusline+=[%{&expandtab?'spaces:'.&shiftwidth:'tabs:'.&tabstop}]
