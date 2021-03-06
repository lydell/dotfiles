function setup
  fish_hybrid_key_bindings

  abbr pbcopy 'xclip -selection clipboard'
  abbr pbpaste 'xclip -selection clipboard -o'

  abbr dc 'docker-compose'
  abbr do 'docker'
  abbr l 'exa'
  abbr la 'exa -lah'
  abbr R 'less -R'
  abbr q 'jq -C . | less -R'

  abbr rm 'rm -Id'
  abbr cp 'cp -r'
  abbr mkdir 'mkdir -p'

  abbr s 'git status'
  abbr d 'git diff'
  abbr g 'git'
  abbr ga 'git add'
  abbr gamd 'git commit -a --amend --no-edit'
  abbr gb 'git blame'
  abbr gbr 'git branch'
  abbr gci 'git commit'
  abbr gcl 'git clone'
  abbr gco 'git checkout'
  abbr gl 'git log'
  abbr glp 'git log -p'
  abbr gm 'git merge'
  abbr gp 'git pull'
  abbr gr 'git rebase'
  abbr gs 'git show'
  abbr gst 'git stash'
  abbr gu 'git push'
end
