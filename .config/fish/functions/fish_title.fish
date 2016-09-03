function fish_title -a command
  if test -z "$command"
    string replace $HOME '~' $PWD
  else
    echo -s (basename $PWD) ": $command"
  end
end
