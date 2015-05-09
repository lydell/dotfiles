" Some plugins require this to be set before they are loaded.
set nocompatible

""" Plugins
call plug#begin('~/.vim/bundles')

Plug 'AndrewRadev/inline_edit.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/undoquit.vim'
Plug 'ap/vim-css-color'
Plug 'ap/vim-you-keep-using-that-word'
Plug 'bkad/CamelCaseMotion'
Plug 'jamessan/vim-gnupg'
Plug 'mileszs/ack.vim'
Plug 'myint/indent-finder'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
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
Plug 'ntpeters/vim-better-whitespace'
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
set guioptions-=r
set guioptions-=L
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
set formatoptions-=t
set formatoptions+=j
set list
set listchars=tab:▸\ ,extends:>,precedes:<,nbsp:·
set nojoinspaces
set nostartofline
set nrformats-=octal
set showcmd
set splitbelow
set splitright
set textwidth=80
set wildmenu
set wildmode=longest:full,full


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
noremap Q @q
" vim-vinegar takes `-`
noremap _ -

" Ctrl-{a,c,v} stand-in
nnoremap <c-y> gg"+yG
noremap <a-y> "+y
noremap <a-s-y> "+y$
inoremap <a-v> <c-o>:set paste<cr><c-r>+<c-o>:set nopaste<cr>

" Better undo
inoremap <c-u> <c-g>u<c-u>
inoremap <cr> <c-g>u<cr>

" Insert mode
inoremap <c-esc> <c-o>
inoremap <a-p> <c-r>.<space>=<space><c-r>"
inoremap <up> <c-o>O
inoremap <down> <c-o>o

" Visual mode
vnoremap <end> $h

" <leader>
map <space> <leader>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :wq<cr>

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
nmap cH <Plug>CSurround
nmap h  <Plug>Ysurround
nmap H  <Plug>YSurround
nmap hh <Plug>Yssurround
nmap HH <Plug>YSsurround
xmap h  <Plug>VSurround
xmap H  <Plug>VgSurround
imap <c-h> <Plug>Isurround
imap <a-h> <Plug>ISurround
imap <a-q> <Plug>Isurround<
imap <a-'> <Plug>Isurround'<Plug>Isurround<space><space><Plug>Isurround+<Plug>Isurround<space><space>
imap <a-"> <Plug>Isurround"<Plug>Isurround<space><space><Plug>Isurround+<Plug>Isurround<space><space>
inoremap <a-u> {}<left><cr><cr><up><tab>
inoremap <a-c> {<esc>jo}<esc>k>>
inoremap <c-cr> <cr><c-o>O<tab>


""" CamelCaseMotion
map <silent> <a-w> <Plug>CamelCaseMotion_w
map <silent> <a-b> <Plug>CamelCaseMotion_b
vmap <silent> <a-b> <Plug>CamelCaseMotion_b<right>
map <silent> <a-e> <Plug>CamelCaseMotion_e
omap <silent> i<a-w> <Plug>CamelCaseMotion_iw
vmap <silent> i<a-w> <Plug>CamelCaseMotion_iw
omap <silent> i<a-b> <Plug>CamelCaseMotion_ib
vmap <silent> i<a-b> <Plug>CamelCaseMotion_ib
omap <silent> i<a-e> <Plug>CamelCaseMotion_ie
vmap <silent> i<a-e> <Plug>CamelCaseMotion_ie


""" Commentary
map  j  <Plug>Commentary
nmap jj <Plug>CommentaryLine
nmap cj <Plug>ChangeCommentary
nmap ju <Plug>Commentary<Plug>Commentary


""" SplitJoin
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''

noremap x :SplitjoinSplit<cr>
noremap X :SplitjoinJoin<cr>


""" fzf
map <leader>n :FZF<cr>
map <leader>N :FZF<space>

function! FZF()
  return printf('xterm -T fzf'
      \ .' -bg "\%s" -fg "\%s"'
      \ .' -fa "%s" -fs %d'
      \ .' -geometry %dx%d+%d+%d -e bash -ic %%s',
      \ synIDattr(hlID("Normal"), "bg"), synIDattr(hlID("Normal"), "fg"),
      \ 'Monospace', getfontname()[-2:],
      \ &columns, &lines/2, getwinposx(), getwinposy())
endfunction
let g:Fzf_launcher = function('FZF')


""" YCM
let g:ycm_filetype_blacklist = {}
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_list_select_completion = ['<tab>']
let g:ycm_key_list_previous_completion = ['<s-tab>']
let g:ycm_key_invoke_completion = '<c-tab>'
let g:ycm_key_detailed_diagnostics = ''
let g:ycm_autoclose_preview_window_after_insertion = 1
nnoremap <leader>g :YcmCompleter GoTo<cr>


""" Various
imap <a-r> <Plug>CapsLockToggle

map <leader>a :Ack<space>
map <leader>i <Plug>(EasyAlign)

let g:fnr_flags = 'g'

highlight! link ExtraWhitespace Error

map <leader>e :InlineEdit<cr>

let g:GPGUsePipes = 1


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
set statusline+=%4p%% "50%


""" Autocommands
augroup vimrc
autocmd!
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
augroup END
