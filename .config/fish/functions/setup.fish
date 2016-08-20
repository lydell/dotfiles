function setup
  fish_vi_key_bindings

  abbr dc 'docker-compose'
  abbr c 'xclip -selection clipboard'
  abbr r './run'

  abbr s 'git status'
  abbr d 'git diff'
  abbr gbr 'git branch'
  abbr gci 'git commit'
  abbr gco 'git checkout'
  abbr gs 'git show'
  abbr gst 'git status'
  abbr glol 'git log --all --graph --decorate --oneline'
  abbr glols 'git log --all --graph --decorate --oneline --simplify-by-decoration'
  abbr gamd 'git commit -a --amend --no-edit'
end
