# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# ** glob support.
shopt -s globstar

# ?*+@!() glob support.
shopt -s extglob

# Make `less` more friendly for non-text input files, see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support of `ls` and also add handy aliases.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Git prompt.
#GIT_PROMPT_FETCH_REMOTE_STATUS=0
#source ~/bash-git-prompt/gitprompt.sh
path='\w'
stashed='$(n=$(git stash list 2>/dev/null | wc -l); [[ $n != "0" ]] && echo "($n stashed) ")'
status='$(git status -sb 2>/dev/null | tr "\n" " " | sed "s/\ \+/\ /g" | sed "s/no\ branch/$(h=$(git rev-parse HEAD 2>/dev/null); echo ${h:0:7})/")'
export PS1="$path $stashed$status\n$ "
lastPS1='$ '
function PS1toggle {
  tmp=$lastPS1
  lastPS1=$PS1
  export PS1=$tmp
}

# Environment variables.
export TWORLDDIR="$HOME/.tworld"
export TWORLDSAVEDIR="$HOME/.tworld/save"
