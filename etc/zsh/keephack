# Filename:      /etc/zsh/keephack
# Purpose:       this file belongs to the zsh setup (see /etc/zsh/zshrc)
# Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
################################################################################

# save output in a variable for later use
# Written by Bart Schaefer, for more details see:
# http://www.zsh.org/cgi-bin/mla/wilma_hiliter/users/2004/msg00894.html ff.
function keep {
    setopt localoptions nomarkdirs nonomatch nocshnullglob nullglob
    kept=()         # Erase old value in case of error on next line
    kept=($~*)

    if [[ ! -t 0 ]] ; then
        local line
        while read line; do
            kept+=( $line )         # += is a zsh 4.2+ feature
        done
    fi

    print -Rc - ${^kept%/}(T)
}
# use it via:
# locate -i backup | grep -i thursday | keep
# echo $kept
#
# or:
#
# patch < mypatch.diff
# keep **/*.(orig|rej)
# vim ${${kept:#*.orig}:r}
# rm $kept
alias keep='noglob keep'

_insert_kept() {
    (( $#kept )) || return 1
    local action
    zstyle -s :completion:$curcontext insert-kept action

    if [[ -n $action ]] ; then
        compstate[insert]=$action
    elif [[ $WIDGET == *expand* ]] ; then
        compstate[insert]=all
    fi
    if [[ $WIDGET == *expand* ]] ; then
        compadd -U ${(M)kept:#${~words[CURRENT]}}
    else
        compadd -a kept
    fi
}

# now bind it to keys and enable completion
zle -C insert-kept-result complete-word _generic
zle -C expand-kept-result complete-word _generic
zstyle ':completion:*-kept-result:*' completer _insert_kept
zstyle ':completion:insert-kept-result:*' menu yes select

bindkey '^Xk' insert-kept-result
bindkey '^XK' expand-kept-result    # shift-K to get expansion

# And the "_expand_word_and_keep" replacement for _expand_word:
_expand_word_and_keep() {
    function compadd() {
        local -A args
        zparseopts -E -A args J:
        if [[ $args[-J] == all-expansions ]] ; then
            builtin compadd -A kept "$@"
            kept=( ${(Q)${(z)kept}} )
        fi
        builtin compadd "$@"
    }
    # for older versions of zsh:
    local result
    _main_complete _expand
    result=$?
    unfunction compadd
    return result
    # versions >=4.2.1 understand this:
    # { _main_complete _expand } always { unfunction compadd }
}

# This line must come after "compinit" in startup:
zle -C _expand_word complete-word _expand_word_and_keep

# No bindkey needed, it's already ^Xe from _expand_word
zstyle ':completion:*' insert-kept menu
zmodload -i zsh/complist

## END OF FILE #################################################################
# vim:filetype=zsh foldmethod=marker autoindent expandtab shiftwidth=4
