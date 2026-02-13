export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="devcontainers"

plugins=(git)

source $ZSH/oh-my-zsh.sh

zstyle ':omz:update' mode disabled

setopt AUTO_CD

alias cpcli='copilot --allow-all-tools -p "$@"'
alias dstopall='docker stop $(docker ps -a -q)'
alias dremoveall='docker rm $(docker ps -a -q)'
alias drmiall='docker rmi $(docker images -a -q)'
alias dreset="dstopall; dremoveall; drmiall -f; docker system prune"
alias dcu="docker compose up"
alias dcd="docker compose down"
