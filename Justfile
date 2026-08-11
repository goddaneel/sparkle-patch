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


clean-git:
        git clean -xd -f


clean-rm:
        rm -rfv "{{_gs_path_temp}}/flatpak"


shasum-export arg1:
        #!/bin/bash
        set -euxo pipefail
        #       #
        cd "{{_gs_path_export}}"
        export LC_ALL="C"
        shasum -a 512 {{arg1}} >> "{{arg1}}.shasum"


podman-build:
        podman build --tag "goddaneel_flatpak-builder" "."
        podman image prune --force


podman-rmi:
        podman rmi "localhost/goddaneel_flatpak-builder"
        podman image prune --force


podman-up:
        podman compose --in-pod=false up -d


podman-down:
        podman compose down


podman-exec arg1:
        podman compose exec "metacubexd" "{{arg1}}"


podman-just arg1:
        podman compose exec "metacubexd" "just" "{{arg1}}"


flatpak-build:
        #!/bin/bash
        set -euxo pipefail
        #       #
        declare -a "_la_exec_install"
        declare -a "_la_exec_flatpak"
        #       #
        _la_exec_install=(
                install -d -v
                "{{_gs_path_temp}}"
                "{{_gs_path_temp}}/flatpak"
                "{{_gs_path_temp}}/flatpak/repo"
                "{{_gs_path_temp}}/flatpak/state"
                "{{_gs_path_temp}}/flatpak/dir"
        )
        #       #
        _la_exec_flatpak=(
                flatpak-builder --force-clean --disable-rofiles-fuse
                --repo="{{_gs_path_temp}}/flatpak/repo"
                --state-dir="{{_gs_path_temp}}/flatpak/state"
                "{{_gs_path_temp}}/flatpak/dir"
                "{{_gs_path_pwd}}/flatpak/{{_gs_init_id}}.yml"
        )
        #       #
        "${_la_exec_install[@]}"
        "${_la_exec_flatpak[@]}"


flatpak-export:
        #!/bin/bash
        set -euxo pipefail
        #       #
        declare -a "_la_exec_install"
        declare -a "_la_exec_flatpak"
        #       #
        _la_exec_install=(
                install -d -v
                "{{_gs_path_export}}"
        )
        #       #
        _la_exec_flatpak=(
                flatpak build-bundle
                "{{_gs_path_temp}}/flatpak/repo"
                "{{_gs_path_export}}/{{_gs_file_build_flatpak}}"
                "{{_gs_init_id}}"
        )
        #       #
        "${_la_exec_install[@]}"
        "${_la_exec_flatpak[@]}"
        #       #
        just shasum-export "{{_gs_file_build_flatpak}}"



clean-all:
        just clean-rm
        just clean-git


podman-bash:
        just podman-down
        just podman-up
        just podman-exec bash


flatpak-work:
        just flatpak-build
        just flatpak-export


clean-podman:
        just podman-down
        just clean-rm
        just clean-git


podman-flatpak:
        just podman-down
        just clean-rm
        just clean-git
        just podman-up
        just podman-just flatpak-work