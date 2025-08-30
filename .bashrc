#!/bin/bash



### bash
## variable
# environment
export PS1='\n\[\033[46;30m\] $? \[\033[0m\]\[\033[44;30m\] \w \[\033[0m\]\n\[\033[43;30m\] \$ \[\033[0m\] '
export PS1='\n\[\033[41;30m\] $? \w \[\033[0m\]\n\[\033[41;30m\] \$ \[\033[0m\] '



### history
## variable
# environment
export HISTTIMEFORMAT="%F %T %t"



### echo
## command
# short
alias echoe='echo -e'



### ls
## command
# short
alias ls,='ls --color'
alias la='ls --color -A'
alias ll='ls --color -lh'
alias lla='ls --color -lhA'



### tree
## command
# short
alias tree,='tree -C'
alias trea='tree -C -a'
alias tres='tree -C -pugshD'
alias tresa='tree -C -pugshDa'



### exa/eza
## command
# short
alias ezaa='eza -a'
alias ezl='eza --time-style=long-iso -lgh'
alias ezla='eza --time-style=long-iso -lgha'
alias ezt='eza -T'
alias ezta='eza -Ta'
alias eztl='eza --time-style=long-iso -Tlgh'
alias eztla='eza --time-style=long-iso -Tlgha'



### less
## variable
# environment
export LESS='-R --use-color -Dd+r$Du+b$'



### batcat
## variable
# environment
export BAT_STYLE='header,grid'


## command
# alias
function bat ()
{
        batcat "${@}" ;
}

# short
alias batf='batcat --style=full'
alias catb='batcat --paging=never'
alias lessb='batcat --paging=always'
#       #
alias ,helpb='batcat -l help'
alias ,bashb='batcat -l bash'
#       #
function _GF__gitb () 
{
        declare "_ls_1_type" ;
        declare -a "_la_exec_batcat" ;
        #       #
        _ls_1_type="${1:?}" || return ;
        #       #
        shift 1 ;
        #       #
        _la_exec_batcat=(
                batcat
                -l "git ${_ls_1_type}"
                "${@}"
        )
        #       #
        "${_la_exec_batcat[@]}" ;
}
declare -fr "_GF__gitb"
alias ,gitb='_GF__gitb'



### diff
## command
# short
alias diff,='diff --color'
alias diffr='diff --color -r'

# print
function _GF_p_diffb () 
{
        declare -a "_la_exec_batcat" ;
        #       #
        _la_exec_batcat=(
                batcat
                --paging=auto
                -n
                -l "diff"
        )
        #       #
        diff "${@}" | "${_la_exec_batcat[@]}" ;
}
declare -fr "_GF_p_diffb"
alias p,diffb='_GF_p_diffb'
alias p,diffbr='_GF_p_diffb -r'



### grep
## command
# short
alias grep,='grep --color'
alias grepi='grep --color -i'
alias grepe='grep --color -E'
alias grepie='grep --color -iE'



### rg
## command
# short
alias rgi='rg -i'
alias rge='rg -e'
alias rgie='rg -ie'



### fdfind
## command
# alias
alias fdf='fdfind'

# short
alias fdfh='fdfind -H'



### fzf
## command
# environment
function _GF_e_fzfk () 
{
        declare -gx "FZF_ALT_C_OPTS" ;
        #       #
        FZF_ALT_C_OPTS="--preview 'exa -la --no-user --no-time --no-filesize {}'" ;
        #       #
        source "/usr/share/doc/fzf/examples/key-bindings.bash" ;
}
#       #
function _GF_e_fzfc () 
{
        source "/usr/share/doc/fzf/examples/completion.bash" ;
}
#       #
declare -fr "_GF_e_fzfk"
declare -fr "_GF_e_fzfc"
alias e,fzfk='_GF_e_fzfk'
alias e,fzfc='_GF_e_fzfc'
alias e,fzfa='_GF_e_fzfk ; _GF_e_fzfc'
alias e,fzf='_GF_e_fzfk'



### node
## environment
export PATH="${HOME}/node_prefix/bin:${PATH}"
export NODE_PATH="${HOME}/node_prefix/lib/node_modules:${NODE_PATH}"
