#!/usr/bin/bash -i
# https://github.com/pl643/fzf-repl/fzf-repl.bash
#   bash REPL (Read/Evaluate/Print/Loop) using fzf to edit/execute/lazygit files/directories/history

# suggested alias:
#    alias fr='~/repo/fzf-repl/fzf-repl.bash'

fzf_height=6

# FZF_DEFAULT_COMMAND --prompt doesn't support ansi color, our REPL prompt will not be colorless
PS1="\u@\h:\w$ "
# defaults editor to neovim
[ -z "$EDITOR" ] || export EDITOR="nvim"

# display fzf bindings
menu() {
    printf "
      fzf-repl

      fzf bindings:

         <Enter>     execute/eval fzf query string
         C-e         edit selected fzf item
         C-f         fc (fix command) selected fzf item and execute (sourced)
         C-g         start lazygit in the directory of selected fzf item
         C-x         execute/eval selected fzf item is file / cd if a directory

         alias m='menu/bindings'      displays this menu
         alias x='exit'               exit fzf-repl

    "
}

alias m=menu
alias x=exit

menu

fzf_repl_history="$HOME/.fzf_repl_history"
fzf_fc="$HOME/.fzf_fc"
# https://learnbyexample.github.io/learn_perl_oneliners/one-liner-introduction.html - for uniq lines without sorting
export FZF_DEFAULT_COMMAND="([ -f $fzf_repl_history ] && tac $fzf_repl_history; tac ~/.bash_history; find . -type f -or -type d) | perl -MList::Util=uniq -e 'print uniq <>'"

while [ true ]; do
    eval 'prompt="${PS1@P}";' 2> /dev/null
    eval export FZF_DEFAULT_OPTS=\'--height=$fzf_height --info=inline --layout=reverse --prompt \"$prompt\"\'
    selected=$(fzf --print-query --bind \
        'ctrl-f:execute(echo {} > ~/.fzf_fc; nvim ~/.fzf_fc > /dev/tty)+abort,ctrl-e:execute([ -f {} ] && (echo {} > ~/.fzf_repl_history; nvim {} > /dev/tty))+abort,ctrl-g:execute(cd $(dirname {}); lazygit > /dev/tty)+abort,ctrl-x:execute(echo {}; eval {})+abort'\
    )
    if [ -f "$fzf_fc" ] ; then
        query=$(cat "$fzf_fc")
        rm "$fzf_fc"
    else
        query=$(echo "$selected" | head -1)
    fi
    echo "$prompt$query"

    # if query is a directory, repl will cd into it
    if [ -d "$query" ]; then 
        cd $query 
    else
        eval "$query"
    fi

    [ -z "$query" ] || echo "$query" >> $fzf_repl_history
done
