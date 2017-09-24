function setup
  fish_vi_key_bindings

  abbr dc 'docker-compose'
  abbr c 'xclip -selection clipboard'
  abbr r './run'

  abbr s 'git status'
  abbr d 'git diff'
  abbr g 'git'
  abbr ga 'git add'
  abbr gamd 'git commit -a --amend --no-edit'
  abbr gbr 'git branch'
  abbr gci 'git commit'
  abbr gco 'git checkout'
  abbr gd 'git diff'
  abbr gl 'git log'
  abbr glol 'git log --all --graph --decorate --oneline'
  abbr glols 'git log --all --graph --decorate --oneline --simplify-by-decoration'
  abbr glp 'git log -p'
  abbr gm 'git merge'
  abbr gp 'git pull'
  abbr gr 'git rebase'
  abbr gs 'git show'
  abbr gst 'git status'
  abbr gu 'git push'
end
