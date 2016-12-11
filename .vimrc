" Some plugins require this to be set before they are loaded.
set nocompatible

""" Plugins
call plug#begin('~/.vim/bundles')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/undoquit.vim'
Plug 'ap/vim-css-color'
Plug 'ap/vim-you-keep-using-that-word'
Plug 'bkad/CamelCaseMotion'
Plug 'henrik/vim-indexed-search'
Plug 'elmcast/elm-vim'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'jamessan/vim-gnupg'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-fnr'
Plug 'junegunn/seoul256.vim'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/syntastic'
Plug 'sheerun/vim-polyglot'
Plug 'tommcdo/vim-exchange'
Plug 'unblevable/quick-scope'
Plug 'Valloric/YouCompleteMe', { 'do': 'python3 install.py --tern-completer' }
Plug 'wellle/targets.vim'
Plug 'whatyouhide/vim-lengthmatters'

call plug#end()


""" Settings
" UI
set guifont=monospace\ 11
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=L
set cursorline
set relativenumber
set number
let g:seoul256_background = 234
colorscheme seoul256

" IO
set autoread
set backupcopy=yes
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
set tabstop=2
set autoindent
set indentkeys=
filetype indent off

" Misc
set backspace=indent,eol,start
set completeopt+=longest
set display=lastline
set formatoptions-=t
set formatoptions+=j
set iskeyword+=$
set lazyredraw
set list
set listchars=tab:▸\ ,extends:>,precedes:<,nbsp:·
set mousemodel=popup_setpos
set nojoinspaces
set nostartofline
set nrformats-=octal
set shell=/bin/bash
set showcmd
set splitbelow
set splitright
set textwidth=80
set wildmenu
set wildmode=longest:full,full


""" Helper functions
function! ChompedSystem(...)
  return substitute(call('system', a:000), '\n\+$', '', '')
endfunction

function! IsAroundCursor(regex)
  let currentLine = getline('.')
  let pos = col('.') - 1
  let start = match(currentLine, a:regex)
  let end = matchend(currentLine, a:regex)
  return start >= 0 && end >= 0 && start <= pos && end > pos
endfunction


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
noremap k `]
noremap K `[
nnoremap <silent> p :call Paste(1)<cr>
nnoremap <silent> P :call Paste(0)<cr>
nnoremap zp p
nnoremap zP P

function! Paste(forward)
  let lineNum = line('.')
  let numLines = line('$')
  let empty = getline(lineNum) == ''
  if empty
    let referenceLineNum = a:forward ? prevnonblank(lineNum) : nextnonblank(lineNum)
    let whitespace = matchstr(getline(referenceLineNum), '^\s*')
    call setline(lineNum, whitespace)
    normal! $
  endif

  let pasteChar = a:forward ? 'p' : 'P'
  execute 'normal! "' . v:register . ']' . pasteChar

  if empty
    let newNumLines = line('$')
    let newLineNum = line('.')
    let whitespaceLen = strlen(whitespace)
    if newLineNum == lineNum && newNumLines == numLines
      if !a:forward && whitespaceLen > 0
        let result = getline(lineNum)
        let pasted = strpart(result, whitespaceLen - 1, strlen(result) - whitespaceLen)
        call setline(lineNum, whitespace . pasted)
        normal! $
      endif
    else
      let lineNumToClear = a:forward ? lineNum : newNumLines - numLines + lineNum
      let lineToClear = getline(lineNumToClear)
      if lineToClear == whitespace
        call setline(lineNumToClear, '')
      else
        let currentLine = getline(newLineNum)
        let indent = matchstr(currentLine, '^\s*')
        if indent == strpart(whitespace, 0, whitespaceLen - 1)
          call setline(newLineNum, ' ' . currentLine)
          call setline(lineNumToClear, strpart(lineToClear, 0, strlen(lineToClear) - 1))
          normal! l
        endif
      endif
    endif
  endif
endfunction

" Y like C and D
nnoremap Y y$
" qq to record, Q to replay
noremap Q @q
" vim-dirvish takes `-`
noremap _ -

" Let i and a pick up indentation from previous/next line if on empty line.
nnoremap <silent><expr> i getline('.') == '' ? ':call EmptyLineInsert(0)<cr>' : 'i'
nnoremap <silent><expr> a getline('.') == '' ? ':call EmptyLineInsert(1)<cr>' : 'a'

function! EmptyLineInsert(forward)
  let lineNum = line('.')
  let referenceLineNum = a:forward ? nextnonblank(lineNum) : prevnonblank(lineNum)
  let whitespace = matchstr(getline(referenceLineNum), '^\s*')
  call setline(lineNum, whitespace)
  startinsert!
endfunction

" Ctrl-{a,c,v} stand-in
nnoremap <a-y> :let @*=@"\|let @+=@"<cr>
" Recursive in order to trigger the above mapping.
vmap <a-y> y<a-y>
nmap <c-y> ggyG<a-y>
inoremap <silent> <a-r> a<bs><c-\><c-o>:call InsertPaste()<cr>

function! InsertPaste()
  let lineNum = line('.')
  let colNum = col('.')
  let currentLine = getline(lineNum)
  let before = strpart(currentLine, 0, colNum - 1)
  let after = strpart(currentLine, colNum - 1)
  let clipboard = split(getreg('+'), '\n')
  let clipboardLen = len(clipboard)
  if clipboardLen == 0
    return
  elseif clipboardLen == 1
    let result = before . clipboard[0] . after
    call setline(lineNum, result)
    call setpos('.', [0, lineNum, strlen(before . clipboard[0]) + 1, 0])
  else
    let first = clipboard[0]
    let last = clipboard[-1]
    let middle = clipboard[1:-2]
    call setline(lineNum, before . first)
    call append(lineNum, middle + [last . after])
    call setpos('.', [0, lineNum + clipboardLen - 1, strlen(last) + 1, 0])
  endif
endfunction

" % in normal mode to jump between start and end tags.
let tagTemplate = '<\@1<=%s\a[a-zA-Z-]*'
nnoremap <expr> % IsAroundCursor(printf(tagTemplate, ''))
  \ ? 'vat<esc>h'
  \ : IsAroundCursor(printf(tagTemplate, '/'))
  \ ? 'vato<esc>l'
  \ : IsAroundCursor('<')
  \ ? 'f>'
  \ : IsAroundCursor('>')
  \ ? 'F<'
  \ : '%'

" Better undo
inoremap <c-u> <c-g>u<c-u>
inoremap <cr> <c-g>u<cr>

" Insert mode
inoremap <c-esc> <c-o>
inoremap <a-p> <c-r>.<space>=<space><c-r><c-o>"
inoremap <up> <c-o>O
inoremap <down> <c-o>o
inoremap <silent> <c-space> a<bs><c-\><c-o>:call SpaceTo()<cr>

function! SpaceTo()
  let wasAtEOL = (col('.') == col('$'))
  let char = nr2char(getchar())
  let previousLine = getline(prevnonblank(line('.') - 1))
  let currentIndex = col('.') - 1
  let previousIndex = stridx(previousLine, char, currentIndex + 1)
  if previousIndex > currentIndex
    let diff = previousIndex - currentIndex
    let cmd = wasAtEOL ? 'a' : 'i'
    execute 'normal! ' . (diff + 1) . cmd . " \<esc>l"
  endif
  let bang = wasAtEOL ? '!' : ''
  execute 'startinsert' . bang
endfunction

" Visual mode
vnoremap <end> $h

" <leader>
map <space> <leader>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :wq<cr>
nnoremap <leader>S :setlocal spell!<cr>
nnoremap <leader>s i<c-x>s
nnoremap <leader>c ]s
nnoremap <leader>C [s

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
let g:surround_indent = 0
nmap dh <Plug>Dsurround
nnoremap <silent> dH :call DSurround()<cr>
nmap ch <Plug>Csurround
nmap cH <Plug>CSurround
nmap h  <Plug>Ysurround
nmap H  <Plug>YSurround
nmap hh <Plug>Yssurround
nmap HH <Plug>YSsurround
xmap h  <Plug>VSurround
xmap H  <Plug>VgSurround
imap <a-h> <Plug>Isurround
imap <c-h> <Plug>ISurround
imap <a-q> <Plug>Isurround<
imap <c-q> <Plug>ISurround<
inoremap <a-u> {}<left><cr><cr><up><tab>
inoremap <a-c> {<esc>jo}<esc>k>>
inoremap <c-cr> <cr><c-o>O<tab>

function! DSurround()
  let startLine = line("'[")
  let endLine = line("']")
  normal! `[<`]
  execute endLine . 'delete _'
  execute startLine . 'delete _'
endfunction


""" CamelCaseMotion
map <silent> <a-w> <Plug>CamelCaseMotion_w
map <silent> <a-b> <Plug>CamelCaseMotion_b
vmap <silent> <a-b> <Plug>CamelCaseMotion_b<right>
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


""" Elm
let g:elm_setup_keybindings = 0
let g:elm_syntastic_show_warnings = 1


""" fzf
map <leader>n :FZF<cr>
map <leader>? :FZF<space>
map <silent> <leader>l :execute 'FZF' ChompedSystem('repo-root . ' . shellescape(expand('%')))<cr>

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
" fzf occasionally hangs if `$SHELL` is `/usr/bin/fish`.
let $SHELL = '/bin/bash'


""" YCM
let g:ycm_path_to_python_interpreter = '/usr/bin/python3'
let g:ycm_filetype_blacklist = {}
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_list_select_completion = ['<tab>']
let g:ycm_key_list_previous_completion = ['<s-tab>']
let g:ycm_key_invoke_completion = '<c-tab>'
let g:ycm_key_detailed_diagnostics = ''
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_semantic_triggers = {
  \   'elm' : ['.'],
  \ }
nnoremap <silent> <leader>g :YcmCompleter GoTo<cr>


""" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_scss_checkers = ['sass', 'stylelint']


""" Various
imap <a-/> <Plug>CapsLockToggle

map <leader>i <Plug>(EasyAlign)

let g:fnr_flags = 'g'

highlight! link ExtraWhitespace Error

let g:GPGUsePipes = 1

let g:polyglot_disabled = ['elm']

let g:indexed_search_mappings = 0

let g:lengthmatters_highlight_one_column = 1

" Prevent vim-sleuth from running `filetype indent on`. NOTE: This must be done
" _after_ `filetype indent off`, since Vim sets/unsets this global variable
" whenever `filetype indent` is changed.
let g:did_indent_on = 0

cnoremap <silent><expr> <c-cr> &filetype == 'dirvish' ? '<cr>:call DirvishReload()<cr>' : '<cr>'

function! DirvishReload()
  let currentLine = line('.')
  execute 'Dirvish' '%'
  call cursor(currentLine, 0)
endfunction


""" Status line
set laststatus=2
set statusline=
set statusline+=%-4(%m%) "[+]
set statusline+=%f:%l:%c "dir/file.js:12:5
set statusline+=%=%<
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%{CapsLockStatusline()}
set statusline+=%{&fileformat=='unix'?'':'['.&fileformat.']'}
set statusline+=%{strlen(&fileencoding)==0\|\|&fileencoding=='utf-8'?'':'['.&fileencoding.']'}
set statusline+=%r "[RO]
set statusline+=%y "[javascript]
set statusline+=[%{&expandtab?'spaces:'.&shiftwidth:'tabs:'.&tabstop}]
set statusline+=%4p%% "50%


""" Commands
command! -nargs=? FontSize :set guifont=monospace\ <args>


""" Autocommands
augroup vimrc
autocmd!
autocmd BufNewFile,BufFilePre,BufRead *.md setlocal filetype=markdown
" autocmd BufNewFile,BufFilePre,BufRead *.html setlocal filetype=htmldjango
autocmd BufNewFile,BufFilePre,BufRead *.jsm,*.es6 setlocal filetype=javascript
autocmd FileType help setlocal number relativenumber
autocmd FileType jinja setlocal commentstring={#\ %s\ #}
autocmd FileType dirvish nnoremap <buffer><silent> R :call DirvishReload()<cr>
autocmd FileType dirvish nnoremap <buffer> s :<space><c-r><c-a><home>!
autocmd FileType elm nnoremap <leader>f :ElmFormat<cr>
autocmd GUIEnter * set visualbell t_vb=
augroup END

autocmd! User Oblique
autocmd! User ObliqueStar
autocmd! User ObliqueRepeat
autocmd User Oblique       ShowSearchIndex
autocmd User ObliqueStar   ShowSearchIndex
autocmd User ObliqueRepeat ShowSearchIndex
