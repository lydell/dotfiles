set -g __prompt_green green
set -g __prompt_red red
set -g __prompt_yellow yellow
set -g __prompt_cyan brcyan
set -g __prompt_grey 93A1A1

set -g ___fish_git_prompt_color_branch (set_color $__prompt_green)
set -g ___fish_git_prompt_color_branch_detached (set_color $__prompt_red)
set -g ___fish_git_prompt_color_merging (set_color $__prompt_yellow)
set -g ___fish_git_prompt_color_stagedstate (set_color $__prompt_green)
set -g ___fish_git_prompt_color_dirtystate (set_color $__prompt_red)
set -g ___fish_git_prompt_color_untrackedfiles (set_color $__prompt_yellow)
set -g ___fish_git_prompt_color_stashstate (set_color $__prompt_cyan)
set -g ___fish_git_prompt_color_upstream (set_color $__prompt_cyan)

set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showupstream 1
set -g __fish_git_prompt_describe_style contains

set -g ___fish_git_prompt_char_upstream_ahead ⇡
set -g ___fish_git_prompt_char_upstream_behind ⇣
set -g ___fish_git_prompt_char_upstream_diverged ⇡⇣
set -g ___fish_git_prompt_char_upstream_equal ''
set -g __fish_git_prompt_char_upstream_prefix ' '

set __prompt_min_duration 6000 # ms

set -g __prompt_excludes (string join '|' \
  man less more \
  'git (blame|commit|diff|log|show)' \
  'git .*(-i|--interactive|-p|--patch)'
)

set -g __prompt_newline 0


function fish_prompt
  set -l exit_code $status
  set -l cmd "$history[1]"

  set -l failed 0
  if test "$exit_code" -ne 0; and not __prompt_excluded $cmd
    set failed 1
  end

  set -l mode insert
  if test -n "$fish_bind_mode"
    set mode $fish_bind_mode
  end

  set -l newline ''
  if test "$__prompt_newline" -ne 0
    set newline '\n'
  else
    set __prompt_newline 1
  end

  set -l dir (string replace $HOME '~' $PWD)

  set -l duration ''
  if test "$CMD_DURATION" -gt "$__prompt_min_duration"; and not __prompt_excluded $cmd
    set duration (__prompt_format_time $CMD_DURATION)
  end

  set -l git (string replace --all --regex '^\s|[()]' '' (__fish_git_prompt))

  set -l char (__prompt_char $mode $failed)

  set -l prompt \
    $newline \
    (__prompt_part $dir $__prompt_grey) \
    (__prompt_part $duration $__prompt_yellow) \
    (__prompt_part $git) \
    "\n$char "

  echo -e -s $prompt
end


function __prompt_char
  set -l mode $argv[1]
  set -l failed $argv[2]
  set -l char ''
  set -l color normal
  switch $mode
    case insert
      set char ❯
      if test "$failed" -ne 0
        set color $__prompt_red
      else
        set color $__prompt_green
      end
    case default
      set char N
      set color --bold --background $__prompt_red white
    case replace-one
      set char R
      set color --bold --background $__prompt_yellow white
    case visual
      set char V
      set color --bold --background $__prompt_cyan white
  end
  echo -s (set_color $color) $char (set_color normal)
end


function __prompt_format_time
  set -l milliseconds $argv[1]
  set -l seconds (math "$milliseconds / 1000")
  set -l formatted (date --utc --date @$seconds "+%-kh %-Mm %-Ss")
  string replace --regex '^[0\D\s]+' '' $formatted
end


function __prompt_excluded
  set -l cmd $argv[1]
  string match --quiet --regex "^($__prompt_excludes)\b" $cmd
end


function __prompt_part
  if test -n $argv[1]
    set -l color
    if test (count $argv) -gt 1
      set color (set_color $argv[2..-1])
    end
    echo -s $color $argv[1] ' '
  end
end
