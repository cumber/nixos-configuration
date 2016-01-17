#!/bin/zsh

fpath=("${HOME}/.zsh/functions" "${fpath[@]}")

# unset this option to stop commands like [ 'x' == 'y' ] complaining
unsetopt EQUALS

# completion
autoload -U compinit
compinit
autoload -U bashcompinit
bashcompinit
if [[ -f ~/.bash_completion ]]; then
    source ~/.bash_completion
fi

# correction
setopt correct

# automatically keep directory stack
setopt autopushd pushdignoredups

# Bind ctrl+left and ctrl+right to forward/backward by word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey 'OF' end-of-line
bindkey 'OH' beginning-of-line

# Better history search, if available
if zle -al | grep -q history-incremental-pattern-search-backward; then
    bindkey '\C-r' history-incremental-pattern-search-backward
fi

# history
export HISTSIZE=2000
export HISTFILE="$HOME/.shellhistory"
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
setopt inc_append_history_time
setopt extended_history

# make ls pretty
alias ls='ls --color=auto'

# Default LS_COLORS works perfectly fine, but there's some stuff in
# /etc/profile.d that sets LS_COLORS to slightly uglier colours
unset LS_COLORS

# make diff pretty
alias diff='colordiff -u'

# If LS_COLORS is unset, tree needs to be explicitly told about colours.
alias tree='tree -C'


setopt extendedglob

# prompt
autoload -U colors
colors

# Get __git_ps1 command
source "$(dirname "$(readlink -f "$(which git)")")/../share/git/contrib/completion/git-prompt.sh"

_colourhash_arr=("${fg[green]}" "${fg[yellow]}" "${fg[magenta]}" "${fg[cyan]}" "${fg[red]}" "${fg[blue]}" "${fg[black]}")
function colourhash () {
    x="$(echo "$1" | md5sum | cut -f1 -d' ')"
    x="0x${x[-22,-8]}"
    index=$(( x % ${#_colourhash_arr} + 1))
    echo "${_colourhash_arr[$index]}"
}

setopt prompt_subst
export VIRTUAL_ENV_DISABLE_PROMPT=1
export ORIG_UID="$(id -u "cumber")"

PRE_PROMPT=' '
PRE_PROMPT+='%(${ORIG_UID}#..%{$(colourhash "user:${USER}")%}%n%{${fg[default]}%}@)'
PRE_PROMPT+='${STY:+ }%{$(colourhash "${STY}")%}${STY#*.}%{${fg[default]}%}'
PRE_PROMPT+='%B%{$(colourhash "${PWD}")%}%3~%b'
PRE_PROMPT+='%f%b'

POST_PROMPT=''
POST_PROMPT+='%($(( $COLUMNS / 2 ))l.
. )'
POST_PROMPT+='%B%{$(colourhash "${HOST}")%}%# '
POST_PROMPT+='%f%b'

RPROMPT=''
RPROMPT+='%B%{${fg[white]}%}${IN_NIX_SHELL+nix }%{${fg[default]}%}%b'
RPROMPT+='%B%{$(colourhash "venv:${VIRTUAL_ENV}")%}${VIRTUAL_ENV:+venv:}$(basename "${VIRTUAL_ENV}")%b${VIRTUAL_ENV:+ }'
RPROMPT+='%{$(colourhash "${HOST}")%}%m%{${fg[default]}%}'
RPROMPT+='%f%b'

export GIT_PS1_SHOWDIRTYSTATE="yes"
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWSTASHSTATE="yes"
export GIT_PS1_SHOWUNTRACKEDFILES="yes"
export GIT_PS1_SHOWCOLORHINTS="yes"

function precmd() {
    __git_ps1 "${PRE_PROMPT}" "${POST_PROMPT}"

    # set window title
    case $TERM in
        *xterm*|*screen*)
            print -Pn "\e]0;%m${VIRTUAL_ENV:+  }$(basename "${VIRTUAL_ENV}")${STY:+  }${STY#*.}  %3~  %%\a"
            ;;
    esac
}

function preexec() {
    local command="${1//\%/\\\%}"

    case $TERM in
        *xterm*|*screen*)
            print -Pn "\e]0;${command}\a"
            ;;
    esac
}

# Prevent "error connecting to disability bus" messages from GTK programs
export NO_AT_BRIDGE=1

# Python startup file
export PYTHONSTARTUP="${HOME}/.pythonrc"

# Set NIX_GHC* variables if there's a ghc in path
if whence -p ghc > /dev/null; then
    eval "$(grep '^export NIX_GHC' "$(whence -p ghc)")"
fi

# Don't use nano
export EDITOR=vim

# Completion for stack
if whence stack > /dev/null; then
    eval "$(stack --bash-completion-script stack)"
fi

# autolaunch development shell if we're in an appropriate directory
if [[ $IN_NIX_SHELL != 1 && ( -f default.nix || -f shell.nix ) ]]; then
    exec nix-shell --command zsh
fi
