### set
set positional-arguments
set export
set shell := ["bash", "-uc"]



### variable
## info
_gs_init_id := "io.goddaneel.sparkle-lite"

_gs_init_version_main := ```
'/usr/bin/jq' -Mr ".version" "sparkle/package.json"
```

_gs_init_version_full := ```
'/usr/bin/xmlstarlet' sel -t -v "/component/releases/release/@version" "flatpak/extra/metainfo/io.goddaneel.sparkle-lite.metainfo.xml"
```

_gs_file_build_deb := "sparkle-linux-" + _gs_init_version_main + "-amd64.deb"
_gs_file_build_flatpak := "sparkle-linux-" + _gs_init_version_full + "-amd64.flatpak"


## path
_gs_path_pwd := invocation_directory()
_gs_path_patch := _gs_path_pwd / "patch"
_gs_path_temp := _gs_path_pwd / "temp"
_gs_path_origin := _gs_path_pwd / "sparkle"
_gs_path_export := _gs_path_pwd / "export"
_gs_path_project := "/_project/sparkle"



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


clean-env:
        #!/bin/bash
        set -euxo pipefail
        #       #
        declare -a "_la_exec_git"
        #       #
        _la_exec_git=(
                '/usr/bin/git'
                clean -xd -f
                -e "/sparkle"
                -e "/temp/home"
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


init-temp:
        #!/bin/bash
        set -euxo pipefail
        #       #
        declare -a "_la_exec_install"
        #       #
        _la_exec_install=(
                '/usr/bin/install'
                -d -v
                "${_gs_path_temp}"
                "${_gs_path_temp}/home"
                "${_gs_path_temp}/patch"
        )
        #       #
        "${_la_exec_install[@]}"


init-patch:
        #!/bin/bash
        set -euxo pipefail
        #       #
        declare -a "_la_exec_install"
        declare -a "_la_exec_sed"
        #       #
        _la_exec_install=(
                '/usr/bin/install'
                -v
                "${_gs_path_origin}/electron-builder.yml"
                "${_gs_path_temp}/patch/electron-builder.yml"
        )
        #       #
        "${_la_exec_install[@]}"
        #       #
        _la_exec_sed=(
                '/usr/bin/sed'
                -i
                "/productName/s/Sparkle/sparkle/g"
                "${_gs_path_temp}/patch/electron-builder.yml"
        )
        #       #
        "${_la_exec_sed[@]}"


shasum-export arg1:
        #!/bin/bash
        set -euxo pipefail
        #       #
        cd "{{_gs_path_export}}"
        #       #
        declare -a "_la_exec_shasum"
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
        declare -a "_la_exec_dpkg"
        declare -a "_la_exec_flatpak"
        #       #
        _la_exec_install=(
                '/usr/bin/install'
                -d -v
                "{{_gs_path_temp}}/flatpak"
                "{{_gs_path_temp}}/flatpak/repo"
                "{{_gs_path_temp}}/flatpak/state"
                "{{_gs_path_temp}}/flatpak/dir"
        )
        #       #
        "${_la_exec_install[@]}"
        #       #
        cd "{{_gs_path_temp}}/project/dist"
        #       #
        _la_exec_dpkg=(
                '/usr/bin/dpkg-deb'
                -R
                "{{_gs_file_build_deb}}"
                "build_deb"
        )
        #       #
        "${_la_exec_dpkg[@]}"
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


work-cleannew:
        just remove-env
        just clean-new

work-cleanenv:
        just remove-env
        just clean-env

work-init:
        just remove-env
        just clean-env
        just init-temp
        just init-patch
        just init-pnpm

work-flatpak:
        just remove-env
        just clean-env
        just init-temp
        just init-patch
        just init-pnpm
        just build-flatpak
        just export-flatpak