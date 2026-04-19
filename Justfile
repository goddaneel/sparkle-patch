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


## bwrap
_gs_mode_network := "true"

_ga_args_bwrapsh_base := '''
        --die-with-parent
        --overlay-src "${_gs_path_origin}"
        --overlay-src "${_gs_path_patch}"
        --tmp-overlay "${_gs_path_project}"
        --ro-bind "${_gs_path_origin}/.git" "${_gs_path_project}/.git"
        --bind "${_gs_path_temp}/home" "${HOME}"
        --bind "${_gs_path_temp}/project/dist" "${_gs_path_project}/dist"
        --bind "${_gs_path_temp}/project/extra" "${_gs_path_project}/extra"
        --bind "${_gs_path_temp}/project/node_modules" "${_gs_path_project}/node_modules"
        --bind "${_gs_path_temp}/project/out" "${_gs_path_project}/out"
        --bind "${_gs_path_temp}/project/resources/files" "${_gs_path_project}/resources/files"
        --bind "${_gs_path_temp}/project/resources/sidecar" "${_gs_path_project}/resources/sidecar"
        --ro-bind-try "${_gs_path_pwd}/bwrapsh/.npmrc" "${HOME}/.npmrc"
        --setenv "PATH" "${HOME}/node_prefix/bin:${PATH}"
        '''

_ga_exec_bwrapsh_sparkle := '''
        "/usr/bin/bwrapsh"
        dbusproxy
        "sparkle-patch"
        '''



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
                -e "/temp/project/extra"
                -e "/temp/project/node_modules"
                -e "/temp/project/out"
                -e "/temp/project/resources/files"
                -e "/temp/project/resources/sidecar"
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
                "${_gs_path_temp}/project"
                "${_gs_path_temp}/project/dist"
                "${_gs_path_temp}/project/extra"
                "${_gs_path_temp}/project/node_modules"
                "${_gs_path_temp}/project/out"
                "${_gs_path_temp}/project/resources"
                "${_gs_path_temp}/project/resources/files"
                "${_gs_path_temp}/project/resources/sidecar"
        )
        #       #
        "${_la_exec_install[@]}"


init-pnpm:
        #!/bin/bash
        set -euxo pipefail
        #       #
        function _ef_load_bwrapsh () {
                _ga_arg1_bwrapsh=(
                        {{_ga_args_bwrapsh_base}}
                        --chdir "${HOME}"
                )
        }
        #       #
        declare -fx "_ef_load_bwrapsh"
        declare -a "_la_exec_bwrapsh"
        #       #
        _la_exec_bwrapsh=(
                {{_ga_exec_bwrapsh_sparkle}}
                npm install -g "pnpm"
        )
        #       #
        "${_la_exec_bwrapsh[@]}"
        #       #
        _la_exec_bwrapsh=(
                {{_ga_exec_bwrapsh_sparkle}}
                npm update -g "pnpm"
        )
        #       #
        "${_la_exec_bwrapsh[@]}"


init-env:
        #!/bin/bash
        set -euxo pipefail
        #       #
        function _ef_load_bwrapsh () {
                _ga_arg1_bwrapsh=(
                        {{_ga_args_bwrapsh_base}}
                        --chdir "{{_gs_path_project}}"
                )
        }
        #       #
        declare -fx "_ef_load_bwrapsh"
        declare -a "_la_exec_bwrapsh"
        #       #
        _la_exec_bwrapsh=(
                {{_ga_exec_bwrapsh_sparkle}}
                pnpm install
        )
        #       #
        "${_la_exec_bwrapsh[@]}"


init-envfix:
        #!/bin/bash
        set -euxo pipefail
        #       #
        function _ef_load_bwrapsh () {
                _ga_arg1_bwrapsh=(
                        {{_ga_args_bwrapsh_base}}
                        --chdir "{{_gs_path_project}}/node_modules/electron"
                )
        }
        #       #
        declare -fx "_ef_load_bwrapsh"
        declare -a "_la_exec_bwrapsh"
        #       #
        _la_exec_bwrapsh=(
                {{_ga_exec_bwrapsh_sparkle}}
                node "./install.js"
        )
        #       #
        "${_la_exec_bwrapsh[@]}"


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


build-deb:
        #!/bin/bash
        set -euxo pipefail
        #       #
        function _ef_load_bwrapsh () {
                _ga_arg1_bwrapsh=(
                        {{_ga_args_bwrapsh_base}}
                        --chdir "{{_gs_path_project}}"
                )
        }
        #       #
        declare -fx "_ef_load_bwrapsh"
        declare -a "_la_exec_bwrapsh"
        #       #
        _la_exec_bwrapsh=(
                {{_ga_exec_bwrapsh_sparkle}}
                pnpm build:linux deb --x64
        )
        #       #
        "${_la_exec_bwrapsh[@]}"


export-deb:
        #!/bin/bash
        set -euxo pipefail
        #       #
        declare -a "_la_exec_install"
        #       #
        _la_exec_install=(
                '/usr/bin/install'
                -d -v
                "{{_gs_path_export}}"
        )
        #       #
        "${_la_exec_install[@]}"
        #       #
        _la_exec_install=(
                '/usr/bin/install'
                -v
                "{{_gs_path_temp}}/project/dist/{{_gs_file_build_deb}}"
                "{{_gs_path_export}}/"
        )
        #       #
        "${_la_exec_install[@]}"
        #       #
        just shasum-export "{{_gs_file_build_deb}}"


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
        just init-pnpm
        just init-env
        just init-envfix

work-deb:
        just remove-env
        just clean-env
        just init-temp
        just init-pnpm
        just init-env
        just init-envfix
        just build-deb
        just export-deb

work-flatpak:
        just remove-env
        just clean-env
        just init-temp
        just init-pnpm
        just init-env
        just init-envfix
        just build-deb
        just build-flatpak
        just export-flatpak