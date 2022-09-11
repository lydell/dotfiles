eval (/opt/homebrew/bin/brew shellenv)
complete -c e -c pre -w rg
zoxide init fish --cmd c | source

function __nvm_auto --on-variable PWD
  nvm use --silent 2>/dev/null
end
__nvm_auto
