#!/bin/zsh

fpath=("${HOME}/.zsh/functions" "${fpath[@]}")

# unset this option to stop commands like [ 'x' == 'y' ] complaining
unsetopt EQUALS

# completion
autoload -U compinit
compinit

# correction
setopt correct

# automatically keep directory stack
setopt autopushd pushdignoredups

# Bind ctrl+left and ctrl+right to forward/backward by word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Better history search, if available
if zle -al | grep -q history-incremental-pattern-search-backward; then
    bindkey '\C-r' history-incremental-pattern-search-backward
fi

# history
export HISTSIZE=2000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt histignorealldups

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

# set window title
case $TERM in
    *xterm*|*screen*)
        precmd () {
            print -Pn "\e]0;%m${VIRTUAL_ENV:+ }$(basename "${VIRTUAL_ENV}")${STY:+ }${STY#*.} %3~\a"
        }
esac

# prompt
autoload -U colors
colors

_colourhash_arr=("${fg_bold[green]}" "${fg_bold[yellow]}" "${fg_bold[magenta]}" "${fg_bold[cyan]}" "${fg_bold[red]}" "${fg_bold[blue]}")
function colourhash () {
    x="$(echo "$1" | md5sum | cut -f1 -d' ')"
    x="0x${x[-22,-8]}"
    index=$(( x % ${#_colourhash_arr} + 1))
    echo "${_colourhash_arr[$index]}"
}

setopt prompt_subst
export VIRTUAL_ENV_DISABLE_PROMPT=1
export ORIG_UID="$(id -u "cumber")"
PROMPT=''
PROMPT+='%(${ORIG_UID}#..%{$(colourhash "user:${USER}")%}%n%{${fg_no_bold[default]}%}@)'
PROMPT+='%{$(colourhash "${HOST}")%}%m%{${fg_bold[default]}%}'
PROMPT+='${VIRTUAL_ENV:+ }%{$(colourhash "venv:${VIRTUAL_ENV}")%}${VIRTUAL_ENV:+venv:}$(basename "${VIRTUAL_ENV}")'
PROMPT+='${HSENV:+ }%{$(colourhash "hsenv:${HSENV}")%}${HSENV:+hsenv:}$(basename "${HSENV}")%{${fg_no_bold[default]}%}'
PROMPT+='${STY:+ }%{$(colourhash "${STY}")%}${STY#*.}%{${fg_no_bold[default]}%}'
PROMPT+=' %{$(colourhash "${PWD}")%}%3~%{${fg_no_bold[default]}%}'
PROMPT+='%($(( $COLUMNS / 2 ))l.
. )'
PROMPT+='%{$(colourhash "${HOST}")%}%# %{${fg_no_bold[default]}%}'
export PROMPT

# Python startup file
export PYTHONSTARTUP="${HOME}/.pythonrc"

# GHC version switching
autoload -U set-ghc
