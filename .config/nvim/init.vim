call plug#begin('~/.local/share/nvim/plugged')
Plug 'bkad/CamelCaseMotion'
Plug 'henrik/vim-indexed-search'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
call plug#end()

set termguicolors
set cursorline
let g:one_allow_italics = 1
colorscheme one
set background=dark

set clipboard+=unnamedplus
set inccommand=nosplit
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

let g:dirvish_mode = ':sort ,^.*[\/],'
let g:deoplete#enable_at_startup = 1

let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'css': ['stylelint'],
\   'scss': ['stylelint'],
\}
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '●'
let g:ale_sign_warning = '!'

noremap <cr> o<esc>
noremap g<cr> O<esc>
noremap <backspace> X
noremap <delete> x
noremap <home> ^
noremap <end> $
noremap <c-space> <c-f>
noremap <c-s-space> <c-b>
noremap <s-down> <c-e>
noremap <s-up> <c-y>
noremap Q @q
noremap _ -

nnoremap <c-up> <c-w>k
nnoremap <c-down> <c-w>j
nnoremap <c-left> <c-w>h
nnoremap <c-right> <c-w>l
nnoremap Y y$
nnoremap <silent> <esc> :noh<cr><esc>

inoremap <c-u> <c-g>u<c-u>
inoremap <cr> <c-g>u<cr>
inoremap <expr> <tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

vnoremap <end> $h

map <space> <leader>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :wq<cr>
nmap <silent> <leader>; <Plug>(ale_previous_wrap)
nmap <silent> <leader>, <Plug>(ale_next_wrap)
nmap <silent> <leader>g <Plug>(ale_go_to_definition)
nmap <silent> <leader>f :call Prettier()<cr>

function! Prettier()
  let b:ale_fixers = ['prettier']
  execute 'ALEFix'
  unlet b:ale_fixers
endfunction

map  j  <Plug>Commentary
nmap jj <Plug>CommentaryLine
nmap cj <Plug>ChangeCommentary
nmap ju <Plug>Commentary<Plug>Commentary

nmap dh <Plug>Dsurround
nmap ch <Plug>Csurround
nmap h  <Plug>Ysurround
nmap hh <Plug>Yssurround
xmap h  <Plug>VSurround
imap <a-h> <Plug>Isurround
imap <c-h> <Plug>ISurround
imap <a-q> <Plug>Isurround<
imap <c-q> <Plug>ISurround<

let g:sneak#f_reset = 1
let g:sneak#t_reset = 1
let g:sneak#target_labels = "eshitnraoumlwgfcpyd"
let g:sneak#label = 1
map l <Plug>Sneak_s
map gl <Plug>Sneak_S
map , <Plug>Sneak_;
map ; <Plug>Sneak_,
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

map <silent> <a-w> <Plug>CamelCaseMotion_w
map <silent> <a-b> <Plug>CamelCaseMotion_b
vmap <silent> <a-b> <Plug>CamelCaseMotion_b
map <silent> <a-e> <Plug>CamelCaseMotion_e
map <silent> <a-g> <Plug>CamelCaseMotion_ge
omap <silent> i<a-w> <Plug>CamelCaseMotion_iw
vmap <silent> i<a-w> <Plug>CamelCaseMotion_iw
omap <silent> i<a-b> <Plug>CamelCaseMotion_ib
vmap <silent> i<a-b> <Plug>CamelCaseMotion_ib
omap <silent> i<a-e> <Plug>CamelCaseMotion_ie
vmap <silent> i<a-e> <Plug>CamelCaseMotion_ie
omap <silent> i<a-g> <Plug>CamelCaseMotion_ige
vmap <silent> i<a-g> <Plug>CamelCaseMotion_ige

function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? '✔' : printf(
  \   '%d%s %d%s',
  \   all_errors,
  \   g:ale_sign_error,
  \   all_non_errors,
  \   g:ale_sign_warning
  \)
endfunction

set statusline=
set statusline+=%-4(%m%) "[+]
set statusline+=%f:%l:%c "dir/file.js:12:5
set statusline+=%=%<
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%{&fileformat=='unix'?'':'['.&fileformat.']'}
set statusline+=[%{LinterStatus()}]
set statusline+=%{strlen(&fileencoding)==0\|\|&fileencoding=='utf-8'?'':'['.&fileencoding.']'}
set statusline+=%r "[RO]
set statusline+=%y "[javascript]
set statusline+=[%{&expandtab?'spaces:'.&shiftwidth:'tabs:'.&tabstop}]
set statusline+=%4p%% "50%
