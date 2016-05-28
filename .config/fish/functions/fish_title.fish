function fish_title
  set -l command $argv[1]
  if test -z "$command"
    string replace $HOME '~' $PWD
  else
    echo -s (basename $PWD) ": $command"
  end
end
