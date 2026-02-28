set positional-arguments
set shell := ["bash", "-uc"]



_gs_init_version := `'/usr/bin/jq' -Mr ".version" "sparkle/package.json"`

_gs_file_build_deb := "sparkle-linux-" + _gs_init_version + "-amd64.deb"



default:
        just --list --unsorted


cleanenv:
        #!/bin/bash
        declare -a "_ga_exec_git"
        #       #
        _ga_exec_git=(
                '/usr/bin/git'
                clean -xd -f
                -e "/sparkle"
                -e "/temp/home"
                -e "/temp/project/extra"
                -e "/temp/project/node_modules"
                -e "/temp/project/out"
                -e "/temp/project/resources/files"
                -e "/temp/project/resources/sidecar"
        )
        #       #
        "${_ga_exec_git[@]}"

