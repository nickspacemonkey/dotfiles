# ls alias
if command -v eza &> /dev/null
then
    alias ll='eza -la'
  else
    alias ll='ls -la'
fi

# Alias sudo for completion
alias sudo='sudo '

# Attaches tmux to the last session; creates a new session if none exists.
alias t='tmux attach || tmux new-session'
# Attaches tmux to a named session. Without a name, prefers ssh_tmux, then the first session.
ta() {
  local session_name="${1:-}"

  if [[ -z "$session_name" ]]; then
    if tmux has-session -t '=ssh_tmux' 2>/dev/null; then
      session_name="ssh_tmux"
    else
      session_name="$(tmux list-sessions -F '#S' 2>/dev/null | head -n1)"
    fi
  fi

  if [[ -z "$session_name" ]]; then
    echo "No tmux sessions are available."
    return 1
  fi

  tmux attach-session -t "$session_name"
}
# Creates a new session, optionally with the supplied name.
tn() {
  if (( $# > 1 )); then
    echo "Usage: tn [session-name]"
    return 2
  fi

  if (( $# == 1 )); then
    tmux new-session -s "$1"
  else
    tmux new-session
  fi
}
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

#Alias for helix if installed
if command -v hx &> /dev/null
  then
    alias vi='hx'
    alias vim='hx'
fi

alias grep='grep --color=auto'
alias df='df -hT'
alias du='du -h'
alias mkdir='mkdir -p'
alias myip='curl ifconfig.io'

if command -v update > /dev/null; then
    :
elif command -v nala > /dev/null; then
    alias update='sudo nala update && sudo nala upgrade -y'
elif command -v apt > /dev/null; then
    alias update='sudo apt update && sudo apt upgrade -y'
elif command -v dnf > /dev/null; then
    alias update='sudo dnf upgrade -y'
else
    alias update='echo "Neither apt nor dnf is installed."'
fi
