# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
if command -v exa &> /dev/null
  then
    alias ll='exa -la'
  else
    alias ll='ls -la'
#alias la='ls -A'
#alias l='ls -CF'
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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Disable tab autocomplete bell
bind 'set bell-style none'

# tmux on login
if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
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

if [ ! -f "$HOME/.vimrc" ]; then
  cat <<EOL > "$HOME/.vimrc"
set nocompatible
set backspace=indent,eol,start
syntax on
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set number
set visualbell
set mouse+=a
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("\$") | execute "normal! g\`\"" | endif
endif
EOL
fi

# Create or update .tmux.conf
tmux_conf_content='set -g mouse on
set -g default-terminal "screen-256color"'

if [ -f "$HOME/.tmux.conf" ]; then
  current_tmux_conf=$(cat "$HOME/.tmux.conf")
  if [ "$current_tmux_conf" != "$tmux_conf_content" ]; then
    echo "$tmux_conf_content" > "$HOME/.tmux.conf"
  fi
else
  echo "$tmux_conf_content" > "$HOME/.tmux.conf"
fi
