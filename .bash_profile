#Load .bashrc
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

#Create or update .vimrc
vimrc_content=$(cat <<EOL
set nocompatible
set backspace=indent,eol,start
syntax on
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set number
set visualbell
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("\$") | execute "normal! g\\"" | endif
endif
EOL
)

if [ ! -f "$HOME/.vimrc" ] || ! diff <(echo "$vimrc_content") "$HOME/.vimrc" > /dev/null; then
  echo "$vimrc_content" > "$HOME/.vimrc"
fi

# Create or update .tmux.conf
tmux_conf_content='set -g mouse on
set -g default-terminal "screen-256color"'

if [ ! -f "$HOME/.tmux.conf" ] || ! diff <(echo "$tmux_conf_content") "$HOME/.tmux.conf" &> /dev/null; then
  echo "$tmux_conf_content" > "$HOME/.tmux.conf"
fi
