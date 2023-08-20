fish_hybrid_key_bindings
eval (/opt/homebrew/bin/brew shellenv)
complete -c e -c pre -w rg
zoxide init fish --cmd c | source
fzf_configure_bindings --directory=\ct --git_log=\cg --git_status=\cs --processes=\co
set fzf_preview_dir_cmd exa --all --color=always
set fzf_history_time_format %Y-%m-%d
set tide_git_truncation_length 48

function __nvm_auto --on-variable PWD
  nvm use --silent 2>/dev/null
end
__nvm_auto

if test (uname) = Linux
  abbr pbcopy 'xclip -selection clipboard'
  abbr pbpaste 'xclip -selection clipboard -o'
end
abbr pbqr 'pbpaste | qrencode -o - -t UTF8'

abbr do docker
abbr dc 'docker compose'
abbr l exa
abbr la 'exa -lah'
abbr R 'less -R'

set g ''
if test (uname) = Darwin
  set g g
end
abbr rm $g'rm -Id'
abbr cp $g'cp -r'
abbr mv $g'mv -i'
abbr mkdir $g'mkdir -p'

abbr gri 'git rebase -i'
abbr grc 'git rebase --continue'
abbr s 'git status'
abbr d 'git diff'
abbr ds 'git diff --staged'
abbr g git
abbr ga 'git add'
abbr gamd 'git commit -a --amend --no-edit'
abbr gb 'git blame'
abbr gbr 'git branch'
abbr gci 'git commit'
abbr gcl 'git clone'
abbr gl 'git log'
abbr glp 'git log -p'
abbr gm 'git merge'
abbr gp 'git pull'
abbr gr 'git restore'
abbr grs 'git restore --staged'
abbr gs 'git show'
abbr gst 'git stash'
abbr gu 'git push'
abbr gw 'git switch'
