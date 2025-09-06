### variable
## path
_gs_path_pwd := $(realpath .)
_gs_path_temp := $(_gs_path_pwd)/temp
_gs_path_build := $(_gs_path_pwd)/build
_gs_path_patch := $(_gs_path_pwd)/patch
_gs_path_origin ?= $(path_origin)
_gs_path_origin ?= $(_gs_path_pwd)/sparkle
_gs_path_project := /_project/sparkle

_gs_init_version ?= $(shell '/usr/bin/jq' -Mr ".version" "$(_gs_path_origin)/package.json")
_gs_file_build_deb := sparkle-linux-$(_gs_init_version)-x64.deb



### array
## bwrap
_ga_args_bwrap += '/usr/bin/bwrap'
_ga_args_bwrap += --die-with-parent
_ga_args_bwrap += --unshare-all
_ga_args_bwrap += --proc "/proc"
_ga_args_bwrap += --dev "/dev"
_ga_args_bwrap += --tmpfs "/var"
_ga_args_bwrap += --tmpfs "/tmp"
_ga_args_bwrap += --tmpfs "/run"
_ga_args_bwrap += --tmpfs "/home"
_ga_args_bwrap += --ro-bind "/etc" "/etc"
_ga_args_bwrap += --ro-bind "/srv" "srv"
_ga_args_bwrap += --ro-bind "/opt" "/opt"
_ga_args_bwrap += --ro-bind "/usr/bin" "/usr/bin"
_ga_args_bwrap += --ro-bind "/usr/include" "/usr/include"
_ga_args_bwrap += --ro-bind "/usr/lib" "/usr/lib"
_ga_args_bwrap += --ro-bind "/usr/lib" "/usr/lib"
_ga_args_bwrap += --ro-bind "/usr/lib64" "/usr/lib64"
_ga_args_bwrap += --ro-bind "/usr/libexec" "/usr/libexec"
_ga_args_bwrap += --ro-bind "/usr/share" "/usr/share"
_ga_args_bwrap += --ro-bind "/usr/src" "/usr/src"
_ga_args_bwrap += --symlink "/usr/bin" "/bin"
_ga_args_bwrap += --symlink "/usr/lib" "/lib"
_ga_args_bwrap += --symlink "/usr/lib64" "/lib64"
_ga_args_bwrap += --symlink "/run" "/var/run"
_ga_args_bwrap += --tmpfs "${HOME}"
_ga_args_bwrap += --tmpfs "${XDG_RUNITIME_DIR}"
_ga_args_bwrap += --unsetenv "PS1"

_ga_args_bwrap_project += --overlay-src "$(_gs_path_origin)"
_ga_args_bwrap_project += --tmp-overlay "$(_gs_path_project)"
_ga_args_bwrap_project += --ro-bind "$(_gs_path_origin)/.git" "$(_gs_path_project)/.git"
_ga_args_bwrap_project += --chdir "$(_gs_path_project)"
_ga_args_bwrap_project += --share-net

_ga_args_bwrap_temp += --bind "$(_gs_path_temp)/home" "${HOME}"
_ga_args_bwrap_temp += --bind "$(_gs_path_temp)/project/dist" "$(_gs_path_project)/dist"
_ga_args_bwrap_temp += --bind "$(_gs_path_temp)/project/extra" "$(_gs_path_project)/extra"
_ga_args_bwrap_temp += --bind "$(_gs_path_temp)/project/node_modules" "$(_gs_path_project)/node_modules"
_ga_args_bwrap_temp += --bind "$(_gs_path_temp)/project/out" "$(_gs_path_project)/out"
_ga_args_bwrap_temp += --bind "$(_gs_path_temp)/project/resources/files" "$(_gs_path_project)/resources/files"
_ga_args_bwrap_temp += --bind "$(_gs_path_temp)/project/resources/sidecar" "$(_gs_path_project)/resources/sidecar"

_ga_args_bwrap_profile += --ro-bind-try "$(_gs_path_pwd)/.bashrc" "${HOME}/.bashrc"
_ga_args_bwrap_profile += --ro-bind-try "$(_gs_path_pwd)/.npmrc" "${HOME}/.npmrc"

_ga_args_bwrap_end += --remount-ro "/"


## init
_ga_exec_init_pnpm += $(_ga_args_bwrap)
_ga_exec_init_pnpm += $(_ga_args_bwrap_project)
_ga_exec_init_pnpm += $(_ga_args_bwrap_temp)
_ga_exec_init_pnpm += $(_ga_args_bwrap_profile)
_ga_exec_init_pnpm += --chdir "${HOME}"
_ga_exec_init_pnpm += $(_ga_args_bwrap_end)
_ga_exec_init_pnpm += '/usr/bin/npm' -g "pnpm"

_ga_exec_init_env += $(_ga_args_bwrap)
_ga_exec_init_env += $(_ga_args_bwrap_project)
_ga_exec_init_env += $(_ga_args_bwrap_temp)
_ga_exec_init_env += $(_ga_args_bwrap_profile)
_ga_exec_init_env += $(_ga_args_bwrap_end)
_ga_exec_init_env += pnpm install


## build
_ga_args_build_deb += $(_ga_args_bwrap)
_ga_args_build_deb += $(_ga_args_bwrap_project)
_ga_args_build_deb += $(_ga_args_bwrap_temp)
_ga_args_build_deb += $(_ga_args_bwrap_profile)

_ga_exec_build_deb_pnpm += $(_ga_args_build_deb)
_ga_exec_build_deb_pnpm += $(_ga_args_bwrap_end)
_ga_exec_build_deb_pnpm += pnpm build:linux deb --x64

_ga_exec_build_deb_shasum += $(_ga_args_build_deb)
_ga_exec_build_deb_shasum += --chdir "$(_gs_path_project)/dist"
_ga_exec_build_deb_shasum += $(_ga_args_bwrap_end)
_ga_exec_build_deb_shasum += '/usr/bin/shasum' -a 512
_ga_exec_build_deb_shasum += "$(_gs_file_build_deb)"


## debug
_ga_exec_debug_cr += $(_ga_args_bwrap)
_ga_exec_debug_cr += $(_ga_args_bwrap_project)
_ga_exec_debug_cr += $(_ga_args_bwrap_temp)
_ga_exec_debug_cr += $(_ga_args_bwrap_profile)
_ga_exec_debug_cr += --remount-ro "$(_gs_path_project)"
_ga_exec_debug_cr += $(_ga_args_bwrap_end)
_ga_exec_debug_cr += '/usr/bin/bash'

_ga_exec_debug_cv += $(_ga_args_bwrap)
_ga_exec_debug_cv += $(_ga_args_bwrap_project)
_ga_exec_debug_cv += $(_ga_args_bwrap_temp)
_ga_exec_debug_cv += $(_ga_args_bwrap_profile)
_ga_exec_debug_cv += $(_ga_args_bwrap_end)


## test
_ga_exec_test_cr += $(_ga_args_bwrap)
_ga_exec_test_cr += $(_ga_args_bwrap_project)
_ga_exec_test_cr += $(_ga_args_bwrap_profile)
_ga_exec_test_cr += $(_ga_args_bwrap_end)
_ga_exec_test_cr += --remount-ro "${HOME}"
_ga_exec_test_cr += --remount-ro "$(_gs_path_project)"
_ga_exec_test_cr += '/usr/bin/bash'

_ga_exec_test_cv += $(_ga_args_bwrap)
_ga_exec_test_cv += $(_ga_args_bwrap_project)
_ga_exec_test_cv += $(_ga_args_bwrap_profile)
_ga_exec_test_cv += $(_ga_args_bwrap_end)
_ga_exec_test_cv += bash



### target
## mkdir
.PHONY: build
build:
	'/usr/bin/mkdir' -pv "$(_gs_path_build)"

.PHONY: temp
temp:
	'/usr/bin/mkdir' -pv "$(_gs_path_temp)"
	'/usr/bin/mkdir' -pv "$(_gs_path_temp)/home"
	'/usr/bin/mkdir' -pv "$(_gs_path_temp)/project"
	'/usr/bin/mkdir' -pv "$(_gs_path_temp)/project/dist"
	'/usr/bin/mkdir' -pv "$(_gs_path_temp)/project/extra"
	'/usr/bin/mkdir' -pv "$(_gs_path_temp)/project/node_modules"
	'/usr/bin/mkdir' -pv "$(_gs_path_temp)/project/out"
	'/usr/bin/mkdir' -pv "$(_gs_path_temp)/project/resources"
	'/usr/bin/mkdir' -pv "$(_gs_path_temp)/project/resources/files"
	'/usr/bin/mkdir' -pv "$(_gs_path_temp)/project/resources/sidecar"


## init
.PHONY: init-pnpm
init-pnpm: temp
	$(_ga_exec_init_pnpm)

.PHONY: init-env
init-env: temp
	$(_ga_exec_init_env)


## debug
.PHONY: debug-cr
debug-cr: temp
	$(_ga_exec_debug_cr)

.PHONY: debug-cv
debug-cv: temp
	$(_ga_exec_debug_cv)


## build
.PHONY: build-deb
build-deb: temp build
	$(_ga_exec_build_deb_pnpm)
	$(_ga_exec_build_deb_shasum) > "$(_gs_path_pwd)/dist/$(_gs_file_build_deb).shasum"
	'/usr/bin/cp' -v "$(_gs_path_pwd)/dist/$(_gs_file_build_deb)" "$(_gs_path_build)"
	'/usr/bin/cp' -v "$(_gs_path_pwd)/dist/$(_gs_file_build_deb).shasum" "$(_gs_path_build)"


## test
.PHONY: test-cr
test-cr:
	$(_ga_exec_test_cr)

.PHONY: test-cv
test-cv:
	$(_ga_exec_test_cv)

