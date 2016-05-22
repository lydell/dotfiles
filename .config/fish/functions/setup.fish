function setup
  fish_vi_key_bindings

  abbr c 'xclip -selection clipboard'
  abbr r './run'

  abbr s 'git status'
  abbr d 'git diff'
  abbr gco 'git commit'
  abbr gbr 'git branch'
  abbr gci 'git commit'
  abbr gco 'git checkout'
  abbr gst 'git status'
end
