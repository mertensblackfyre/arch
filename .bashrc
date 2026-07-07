# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\u@\h:\033[38;2;12;183;175m\w\033[0m$ '
#PS1='[\u@\h \W]\$ '

export CLICOLOR=1
case $- in
    *i*) ;;
      *) return;;
esac


export PATH=$PATH:/usr/local/go/bin
export MOZ_ENABLE_WAYLAND=1
HISTCONTROL=ignoreboth

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize


[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias vim="nvim"
alias ls='ls --color=auto'
alias grep='grep --color=auto'


alias reswifi="sudo systemctl restart NetworkManager"
alias nn="fastfetch"
alias rr="reboot"
alias sss="shutdown -P now"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -z "$TMUX" ]; then
    tmux
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Created by `pipx` on 2026-05-03 11:44:38
export PATH="$PATH:/home/mertens/.local/bin"
