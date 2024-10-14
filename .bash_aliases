# ls alias
if command -v exa &> /dev/null
  then
    alias ll='exa -la'
  else
    alias ll='ls -la'
fi

# Alias sudo for completion
alias sudo='sudo '

# Attaches tmux to the last session; creates a new session if none exists.
alias t='tmux attach || tmux new-session'
# Attaches tmux to a session (example: ta portal)
alias ta='tmux attach -t'
# Creates a new session
alias tn='tmux new-session'
# Lists all ongoing sessions
alias tl='tmux list-sessions'

# Docker aliases
alias dc='sudo docker compose'
alias dcup='sudo docker compose up --force-recreate -d'
alias dcdown='sudo docker compose down'
alias dcrestart='sudo docker compose restart'
alias docker-clean=' \
  sudo docker container prune -f; \
  sudo docker image prune -af; \
  sudo docker network prune -f; \
  sudo docker volume prune -af '

# Apt for Nala
if command -v nala &> /dev/null
  then
    alias apt='nala'
fi

# Alias for bat if installed
if command -v bat &> /dev/null
  then
    alias cat='bat -pp'
    alias less='bat -p'
elif command -v batcat &> /dev/null
  then
    alias cat='batcat -pp'
    alias less='batcat -p'
fi

alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias mkdir='mkdir -p'

if command -v apt > /dev/null; then
    sudo apt update && sudo apt upgrade
elif command -v dnf > /dev/null; then
    sudo dnf upgrade
else
    echo "Neither apt-get nor dnf is installed."
fi
