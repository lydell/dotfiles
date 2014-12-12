alias pro="firefox -new-instance -P"
alias build_vimfx="make && wget --post-file=VimFx.xpi http://localhost:8888/"
alias tworld="tworld -pq &"
alias c="xclip -selection clipboard"
alias s="git status"
alias noeolateof="perl -i -pe 'chomp if eof'"
alias gem="gem2.1"

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


FROM=/home/lydell/.mozilla/abrowser/Simon/extensions/keefox@chris.tomlinson/deps/KeePassRPC.plgx
TO=/usr/lib/keepass2/plugins/
alias upgrade_keefox="sudo mkdir -p $TO && sudo cp $FROM $TO"
