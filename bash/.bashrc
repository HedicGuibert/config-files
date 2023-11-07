# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s cdspell
shopt -s cmdhist
shopt -s expand_aliases
shopt -s extglob
shopt -s nocaseglob
shopt -s hostcomplete

# Ignore case for tab autocompletion
if [ ! -a ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi
echo 'set completion-ignore-case On' >> ~/.inputrc

export HISTSIZE=50000
export HISTFILESIZE=${HISTSIZE}
export HISTIGNORE="ls:cd:[bf]g:exit"
export HISTCONTROL=ignoreboth # don't put duplicate lines or lines starting with space in the history.

export LESS="FRS"

FZF_DEFAULT_COMMAND="fd --type f"
FZF_DEFAULT_OPTS="--preview 'bat --color=always {}'"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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
force_color_prompt=yes

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

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lfa='ls -lFa'
alias open='xdg-open'
alias chmod='sudo chmod -c'
alias chown='sudo chown -c'
alias find='fdfind'
alias cd='z'

alias godev='cd /home/hedic/Dev/'
alias goperso='cd /home/hedic/Dev/perso'
alias gojoli='cd /home/hedic/Dev/JoliCode/'

alias docc='docker-compose'

alias cas='castor'

export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/home/hedic/.yarn/bin/"
export PATH="$PATH:/home/hedic/.local/bin"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

source /usr/share/bash-completion/completions/git

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(atuin init bash)"

