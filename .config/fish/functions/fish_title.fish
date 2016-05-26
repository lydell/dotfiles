function fish_title
  set -l command $argv[1]
  if test -z "$command"
    set -l dir (string replace $HOME '~' $PWD)
    echo "$dir – $_"
  else
    set -l basename (basename $PWD)
    echo "$basename: $command – $_"
  end
end
