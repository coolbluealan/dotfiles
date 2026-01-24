function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end

abbr --add --set-cursor o 'cd ~/Sync/OTIS/%'
abbr --add --set-cursor p 'cd ~/Sync/OTIS/PSets/%'

abbr --add n nvim
abbr --add nc nvim "*.cpp"

abbr used 'sudo du -h -d1 | sort -h'
abbr --add dotdot --regex '^\.\.+$' --function multicd

bind -M default \ce accept-autosuggestion
bind -M insert \ce accept-autosuggestion

fzf_configure_bindings --directory=\cf --git_status=\cs

alias cp 'cp -i'
alias mv 'mv -i'
alias rm 'rm -i'

alias dot='/usr/bin/python3 -m dot'
alias mod='/usr/bin/python3 -m mod'
alias otis='/usr/bin/python3 -m otis-scrape'
alias bench='/usr/bin/python3 -m bench'
alias stomp='/usr/bin/python3 -m stomp'
alias tsqx='/usr/bin/python3 -m tsqx'
alias ysa='/usr/bin/python3 -m ysa'

alias gg='cd (git rev-parse --show-toplevel)'
alias trash='gio trash'

alias gclip="xclip -selection clipboard -o"
alias pclip="xclip -selection clipboard"

export EDITOR='nvim'
export GPG_TTY=(tty)
export PYTHONPATH="$PYTHONPATH:$HOME/Desktop/:$HOME/dotfiles/py-scripts/"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export fish_prompt_pwd_dir_length=3

zoxide init fish | source

function nt --argument-names name
    if test -z "$name"
        set tex *.tex
    else
        set tex *$name*.tex
    end
    set num (count $tex)
    switch $num
        case 0
            echo "Cannot find suitable file."
            return 1
        case 1
            nvim $tex
        case '*'
            for i in (seq $num)
                echo -n "  $i) $tex[$i]"
            end
            echo
            read -P "Choose file: " n
            if test -z "$n" -o "$n" -eq 0
                return
            else
                nvim $tex[$n]
            end
    end
end

function templatefile --no-scope-shadowing
    argparse --name=directory d/directory= -- $argv
    or return 1

    if set -ql _flag_directory
        set name $_flag_directory
        if test -z "$argv[1]"
            set file $name
        end
    end

    if test -z "$file"
        if test -z "$argv[1]"
            echo "No filename given"
            return 1
        end
        set file "$argv[1]"
    end
    if not string match "*.$ext" "$file"
        set file "$file.$ext"
    end

    if set -ql name
        mkdir "$name"
        cd "$name"
    end
    if test -e "$file"
        echo "Already exists: '$file'"
        return 1
    end
    echo >"$file" $template
    nvim "$file"
end

function newtex
    set ext tex
    set template "\
\documentclass[11pt]{scrartcl}
\usepackage{alan}

\begin{document}
\title{}
\author{}
\maketitle

\end{document}"
    templatefile $argv
end

function newioi
    set ext cpp
    set template "\
#include <bits/stdc++.h>
using namespace std;

int main() {
  int n; cin >> n;
}"
    templatefile $argv
end

function t
    if not test -d tests
        mkdir tests
    end
    if test -z "$argv"
        set argv 1
    end
    nvim tests/$argv.{input,answer}
end

function pdf --wraps=zathura
    set head (echo $argv | cut -f 1 -d '.')
    if string match '*.pdf' $argv >/dev/null; and test -f $argv
        zathura $argv &>/dev/null &
        disown
    else if test -f $head".pdf"
        zathura $head".pdf" &>/dev/null &
        disown
    else if test -f "$argv""pdf"
        zathura "$argv""pdf" &>/dev/null &
        disown
    else if test -f "$argv.pdf"
        zathura "$argv.pdf" &>/dev/null &
        disown
    else
        echo "Cannot find suitable file."
        return 1
    end
end

function jdf --wraps=zathura
    pdf $argv
    and exit
end

function ll --wraps=eza
    if test (count *.tex) -eq 0 -o -n "$argv"
        eza -l $argv
        return
    end
    set regex '('(string join '|' (string sub --end=-5 (string escape --style=regex *.tex)))')'
    set regex $regex'\.(aux|fdb_latexmk|fls|log|nav|out|pre|pytxcode|pytxmcr|pytxpyg|snm|synctex(\.gz|\(busy\))|toc)|-[0-9]{1,2}\.(asy|pdf)$'
    set regex '('$regex')|pythontex_data\.pkl'
    set num_hidden (ls -l | grep -E $regex 2> /dev/null | wc --lines)
    eza -l --color=always | grep -Ev $regex 2>/dev/null
    if test $num_hidden -gt 0
        echo (set_color blue)"("(set_color --bold brgreen)$num_hidden(set_color normal)(set_color blue) "garbage files not shown)"(set_color normal)
    end
end

function la --wraps=eza
    eza -la $argv
end

function fish_greeting
    echo (set_color green)Hello (set_color --bold cyan)$USER(set_color normal; set_color blue)@$hostname(set_color green)!
    echo (set_color --italics $fish_color_comment)It is $(date +'%a %d %b %Y, %r %Z').
    set_color normal
end

function fish_prompt
    set -l last_status $status
    echo -n (set_color --italics $fish_color_cwd)(prompt_pwd)(set_color normal)
    if not test $last_status -eq 0
        echo -n (set_color $fish_color_error) [$last_status]
    end
    if set -q SSH_TTY
        echo -n (set_color blue) "($(prompt_hostname))"
    end
    set_color --bold 00cca7
    if fish_is_root_user
        echo -n ' # '
    else
        echo -n ' ❱ '
    end
    set_color normal
end

function fish_right_prompt
    if set -q VIRTUAL_ENV
        echo -n -s (set_color -b blue white) (basename $VIRTUAL_ENV | string sub -l 2) 🐍 (set_color normal)
    end
    echo -n (set_color normal)(__fish_git_prompt)
    echo -n (set_color $fish_color_comment) [(date +'%I:%M')]
end
