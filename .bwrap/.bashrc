#!/bin/bash



### source
if [[ -f "/usr/share/bwrapsh/main/patch/bash/.bashrc" ]] ; then
        source "/usr/share/bwrapsh/main/patch/bash/.bashrc"
fi



### project
## environment
export _ES_path_project="/_project/sparkle"


## command
# directory
alias d,project='cd "${_ES_path_project}" ; pwd'
