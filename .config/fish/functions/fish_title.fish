# Pure
# by Rafael Rinaldi
# https://github.com/rafaelrinaldi/pure
# MIT License
# Modified by Simon Lydell.

# Set title to current folder and shell name
function fish_title
  set -l basename (command basename $PWD)
  set -l current_folder (string replace $HOME "~" $PWD)
  set -l command $argv[1]
  set -l prompt "$basename: $command – $_"

  if test "$command" -eq ""
    set prompt "$current_folder – $_"
  end

  echo $prompt
end
