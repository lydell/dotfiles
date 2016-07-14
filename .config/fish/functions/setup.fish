function setup
  fish_vi_key_bindings

  abbr dc 'docker-compose'
  abbr c 'xclip -selection clipboard'
  abbr r './run'

  abbr s 'git status'
  set -l diff 'diff-so-fancy | less --tabs=4 -RFX --pattern=\'^(Date|added|deleted|modified): \''
  abbr d "git diff --color | $diff"
  abbr D $diff
  abbr gco 'git commit'
  abbr gbr 'git branch'
  abbr gci 'git commit'
  abbr gco 'git checkout'
  abbr gst 'git status'
  abbr glol 'git log --all --graph --decorate --oneline'
  abbr glols 'git log --all --graph --decorate --oneline --simplify-by-decoration'
  abbr gamd 'git commit -a --amend --no-edit'
end
