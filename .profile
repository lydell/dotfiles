# Don’t forget `export` for environment variables!

export PATH="$HOME/bin-before:$PATH:$HOME/bin:$HOME/.python/bin:./.venv/bin:./node_modules/.bin"

export FZF_DEFAULT_COMMAND='lsrc'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export NVM_DIR="/home/lydell/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
