# vim: set ft=sh:

# Pure
# by Rafael Rinaldi
# https://github.com/rafaelrinaldi/pure
# MIT License
# Modified by Simon Lydell:
# - Use __fish_git_prompt
# - Different colors
# - Custom vi mode indicator

# Whether or not is a fresh session
set -g fresh_session 1

# Git prompt
set -g __fish_git_prompt_showdirtystate 1     # *, + (unstaged, staged)
set -g __fish_git_prompt_showstashstate 1     # $
set -g __fish_git_prompt_showuntrackedfiles 1 # %
set -g __fish_git_prompt_describe_style 1     # v1.6.3.2~35
set -g __fish_git_prompt_showcolorhints 1

function fish_prompt
  # Save previous exit code
  set -l exit_code $status

  set -l exclude '^(man|less|more|git (log|commit|diff|blame|show))\b'

  # Symbols
  set -l symbol_prompt "❯"
  set -l symbol_prompt_default "N"
  set -l symbol_prompt_insert $symbol_prompt
  set -l symbol_prompt_replace_one "R"
  set -l symbol_prompt_visual "V"
  set -l symbol_git_down_arrow "⇣"
  set -l symbol_git_up_arrow "⇡"
  set -l symbol_git_dirty "*"

  # Colors
  set -l color_red (set_color red)
  set -l color_green (set_color green)
  set -l color_yellow (set_color yellow)
  set -l color_cyan (set_color cyan)
  set -l color_gray (set_color 93A1A1)
  set -l color_normal (set_color normal)

  # Set default color symbol to green meaning it's all good!
  set -l color_symbol $color_green

  # Template

  set -l current_folder (string replace $HOME "~" $PWD)
  set -l git_arrows ""
  set -l command_duration ""
  set -l prompt_char $symbol_prompt
  set -l prompt ""

  # Do not add a line break to a brand new session
  if test $fresh_session -eq 0
    set prompt "\n"
  end

  # Format current folder on prompt output
  set prompt "$prompt$color_gray$current_folder$color_normal "

  set excluded (string match --regex $exclude $history[1])
  if test -z "$excluded"
    # Handle previous failed command
    if test $exit_code -ne 0
      # Symbol color is red when previous command fails
      set color_symbol $color_red
    end

    set command_duration (__format_time $CMD_DURATION)
    set prompt "$prompt$color_yellow$command_duration$color_normal"
  end

  # Exit with code 1 if git is not available
  if not which git >/dev/null
    return 1
  end

  # Check if is on a Git repository
  set -l is_git_repository (command git rev-parse --is-inside-work-tree ^/dev/null)

  if test -n "$is_git_repository"
    # Check if there is an upstream configured
    command git rev-parse --abbrev-ref '@{upstream}' >/dev/null ^&1; and set -l has_upstream
    if set -q has_upstream
      set -l git_status (command git rev-list --left-right --count 'HEAD...@{upstream}' | sed "s/[[:blank:]]/ /" ^/dev/null)

      # Resolve Git arrows by treating `git_status` as an array
      set -l git_arrow_left (command echo $git_status | cut -c 1 ^/dev/null)
      set -l git_arrow_right (command echo $git_status | cut -c 3 ^/dev/null)

      # If arrow is not "0", it means it's dirty
      if test $git_arrow_left -ne "0"
        set git_arrows $symbol_git_up_arrow
      end

      if test $git_arrow_right -ne "0"
        set git_arrows $git_arrows$symbol_git_down_arrow
      end
    end

    # Format Git prompt output
    set -l git_prompt (string trim --chars ' ()' (__fish_git_prompt))
    set prompt "$prompt$git_prompt $color_cyan$git_arrows$color_normal"
  end

  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    switch $fish_bind_mode
      case default
        set color_symbol (set_color --bold --background red white)
        set prompt_char $symbol_prompt_default
      case insert
        set prompt_char $symbol_prompt_insert
      case replace-one
        set color_symbol (set_color --bold --background green white)
        set prompt_char $symbol_prompt_replace_one
      case visual
        set color_symbol (set_color --bold --background magenta white)
        set prompt_char $symbol_prompt_visual
    end
  end

  set prompt $prompt "\n$color_symbol$prompt_char$color_normal "

  echo -e -s $prompt

  set fresh_session 0
end
