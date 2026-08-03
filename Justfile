### set
set positional-arguments
set export
set shell := ["bash", "-uc"]



### variable
## info
_gs_init_id := "io.goddaneel.sparkle-lite"

_gs_init_version_full := ```
'/usr/bin/xmlstarlet' sel -t -v "/component/releases/release/@version" "flatpak/extra/metainfo/io.goddaneel.sparkle-lite.metainfo.xml"
```

_gs_file_build_flatpak := "sparkle-linux-" + _gs_init_version_full + "-amd64.flatpak"


## path
_gs_path_pwd := invocation_directory()
_gs_path_temp := _gs_path_pwd / "temp"
_gs_path_export := _gs_path_pwd / "export"



### target
default:
        just --list --unsorted


clean-new:
        #!/bin/bash
        set -euxo pipefail
        #       #
        declare -a "_la_exec_git"
        #       #
        _la_exec_git=(
                '/usr/bin/git'
                clean -xd -f
        )
        #       #
        "${_la_exec_git[@]}"


remove-env:
        #!/bin/bash
        set -euxo pipefail
        #       #
        declare -a "_la_exec_rm"
        #       #
        _la_exec_rm=(
                '/usr/bin/rm'
                -rfv
                "{{_gs_path_temp}}/flatpak"
        )
        #       #
        "${_la_exec_rm[@]}"


shasum-export arg1:
        #!/bin/bash
        set -euxo pipefail
        #       #
        cd "{{_gs_path_export}}"
        #       #
        declare -a "_la_exec_shasum"
        #       #
        export LC_ALL="C"
        #       #
        _la_exec_shasum=(
                '/usr/bin/shasum'
                -a 512
                {{arg1}}
        )
        #       #
        "${_la_exec_shasum[@]}" >> "{{arg1}}.shasum"


build-flatpak:
        #!/bin/bash
        set -euxo pipefail
        #       #
        declare -a "_la_exec_install"
        declare -a "_la_exec_flatpak"
        #       #
        _la_exec_install=(
                '/usr/bin/install'
                -d -v
                "{{_gs_path_temp}}"
                "{{_gs_path_temp}}/flatpak"
                "{{_gs_path_temp}}/flatpak/repo"
                "{{_gs_path_temp}}/flatpak/state"
                "{{_gs_path_temp}}/flatpak/dir"
        )
        #       #
        "${_la_exec_install[@]}"
        #       #
        _la_exec_flatpak=(
                '/usr/bin/flatpak-builder'
                --force-clean --disable-rofiles-fuse
                --repo="{{_gs_path_temp}}/flatpak/repo"
                --state-dir="{{_gs_path_temp}}/flatpak/state"
                "{{_gs_path_temp}}/flatpak/dir"
                "{{_gs_path_pwd}}/flatpak/io.goddaneel.sparkle-lite.yml"
        )
        #       #
        "${_la_exec_flatpak[@]}"


export-flatpak:
        #!/bin/bash
        set -euxo pipefail
        #       #
        declare -a "_la_exec_install"
        declare -a "_la_exec_flatpak"
        #       #
        _la_exec_install=(
                '/usr/bin/install'
                -d -v
                "{{_gs_path_export}}"
        )
        #       #
        "${_la_exec_install[@]}"
        #       #
        _la_exec_flatpak=(
                '/usr/bin/flatpak'
                build-bundle
                "{{_gs_path_temp}}/flatpak/repo"
                "{{_gs_path_export}}/{{_gs_file_build_flatpak}}"
                "{{_gs_init_id}}"
        )
        #       #
        "${_la_exec_flatpak[@]}"
        #       #
        just shasum-export "{{_gs_file_build_flatpak}}"



work-clean:
        just remove-env
        just clean-new

work-flatpak:
        just build-flatpak
        just export-flatpak