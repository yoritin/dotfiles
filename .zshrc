export PS2="%1~ %# "

alias ll='ls -la'
alias la='ls -a'

## zsh
alias sz='source ~/.zshrc'
alias vz='vim ~/.zshrc'
alias setup='git co main && git pull --rebase origin main && git fetch -p'

eval "$(starship init zsh)"
