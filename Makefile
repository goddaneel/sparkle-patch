### variable
## path
_gs_path_pwd := $(realpath .)
_gs_path_temp := $(_gs_path_pwd)/temp
_gs_path_build := $(_gs_path_pwd)/build
_gs_path_patch := $(_gs_path_pwd)/patch
_gs_path_origin ?= $(_gs_path_pwd)/sparkle
_gs_path_project := /_project/sparkle


## init
ifneq (, $(wildcard "$(_gs_path_origin)/package.json"))
	_gs_init_version ?= $(shell '/usr/bin/jq' -Mr ".version" "$(_gs_path_origin)/package.json")
else
	_gs_init_version ?= null
endif

_gs_file_build_deb := sparkle-linux-$(_gs_init_version)-amd64.deb



### array
## clean
_ga_args_clean_git += '/usr/bin/git'
_ga_args_clean_git += clean
_ga_args_clean_git += -xd
_ga_args_clean_git += -f
_ga_args_clean_git += -e "/sparkle"

_ga_exec_clean_gitnew += $(_ga_args_clean_git)

_ga_exec_clean_gitenv += $(_ga_args_clean_git)
_ga_exec_clean_gitenv += -e "/temp/home"
_ga_exec_clean_gitenv += -e "/temp/project/extra"
_ga_exec_clean_gitenv += -e "/temp/project/node_modules"
_ga_exec_clean_gitenv += -e "/temp/project/out"
_ga_exec_clean_gitenv += -e "/temp/project/resources/files"
_ga_exec_clean_gitenv += -e "/temp/project/resources/sidecar"


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
_ga_args_bwrap_profile += --setenv "PATH" "${HOME}/node_prefix/bin:${PATH}"
_ga_args_bwrap_profile += --setenv "NODE_PATH" "${HOME}/node_prefix/lib/node_modules:${NODE_PATH}"

_ga_args_bwrap_end += --remount-ro "/"
_ga_args_bwrap_end += --


## init
_ga_args_init_pnpm += $(_ga_args_bwrap)
_ga_args_init_pnpm += $(_ga_args_bwrap_project)
_ga_args_init_pnpm += $(_ga_args_bwrap_temp)
_ga_args_init_pnpm += $(_ga_args_bwrap_profile)
_ga_args_init_pnpm += --chdir "${HOME}"
_ga_args_init_pnpm += $(_ga_args_bwrap_end)

_ga_exec_init_pnpm_install += $(_ga_args_init_pnpm)
_ga_exec_init_pnpm_install += '/usr/bin/npm' install -g "pnpm"

_ga_exec_init_pnpm_update += $(_ga_args_init_pnpm)
_ga_exec_init_pnpm_update += '/usr/bin/npm' update -g "pnpm"

_ga_exec_init_env += $(_ga_args_bwrap)
_ga_exec_init_env += $(_ga_args_bwrap_project)
_ga_exec_init_env += $(_ga_args_bwrap_temp)
_ga_exec_init_env += $(_ga_args_bwrap_profile)
_ga_exec_init_env += $(_ga_args_bwrap_end)
_ga_exec_init_env += pnpm install

_ga_exec_init_envfix += $(_ga_args_bwrap)
_ga_exec_init_envfix += $(_ga_args_bwrap_project)
_ga_exec_init_envfix += $(_ga_args_bwrap_temp)
_ga_exec_init_envfix += $(_ga_args_bwrap_profile)
_ga_exec_init_envfix += --chdir "$(_gs_path_project)/node_modules/electron"
_ga_exec_init_envfix += $(_ga_args_bwrap_end)
_ga_exec_init_envfix += '/usr/bin/node' "./install.js"


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
_ga_exec_debug_cv += '/usr/bin/bash'


## test
_ga_exec_test_cr += $(_ga_args_bwrap)
_ga_exec_test_cr += $(_ga_args_bwrap_project)
_ga_exec_test_cr += $(_ga_args_bwrap_profile)
_ga_exec_test_cr += --remount-ro "${HOME}"
_ga_exec_test_cr += --remount-ro "$(_gs_path_project)"
_ga_exec_test_cr += $(_ga_args_bwrap_end)
_ga_exec_test_cr += '/usr/bin/bash'

_ga_exec_test_cv += $(_ga_args_bwrap)
_ga_exec_test_cv += $(_ga_args_bwrap_project)
_ga_exec_test_cv += $(_ga_args_bwrap_profile)
_ga_exec_test_cv += $(_ga_args_bwrap_end)
_ga_exec_test_cv += '/usr/bin/bash'



### prerequisites
## work
_ga_pres_work_init += clean-gitenv
_ga_pres_work_init += init-pnpm
_ga_pres_work_init += init-env
_ga_pres_work_init += init-envfix

_ga_pres_work_build += clean-gitenv
_ga_pres_work_build += init-pnpm
_ga_pres_work_build += init-env
_ga_pres_work_build += init-envfix
_ga_pres_work_build += build-deb



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


## clean
.PHONY: clean-gitnew
clean-gitnew:
	$(_ga_exec_clean_gitnew)

.PHONY: clean-gitenv
clean-gitenv:
	$(_ga_exec_clean_gitenv)


## init
.PHONY: init-pnpm
init-pnpm: temp
	$(_ga_exec_init_pnpm_install)
	$(_ga_exec_init_pnpm_update)

.PHONY: init-env
init-env: temp
	$(_ga_exec_init_env)

.PHONY: init-envfix
init-envfix: temp
	$(_ga_exec_init_envfix)


## build
.PHONY: build-deb
build-deb: temp build
	$(_ga_exec_build_deb_pnpm)
	$(_ga_exec_build_deb_shasum) > "$(_gs_path_temp)/project/dist/$(_gs_file_build_deb).shasum"
	'/usr/bin/cp' -v "$(_gs_path_temp)/project/dist/$(_gs_file_build_deb)" "$(_gs_path_build)/"
	'/usr/bin/cp' -v "$(_gs_path_temp)/project/dist/$(_gs_file_build_deb).shasum" "$(_gs_path_build)/"


## work
.PHONY: work-init
work-init: $(_ga_pres_work_init)

.PHONY: work-build
work-build: $(_ga_pres_work_build)


## debug
.PHONY: debug-cr
debug-cr: temp
	$(_ga_exec_debug_cr)

.PHONY: debug-cv
debug-cv: temp
	$(_ga_exec_debug_cv)


## test
.PHONY: test-cr
test-cr:
	$(_ga_exec_test_cr)

.PHONY: test-cv
test-cv:
	$(_ga_exec_test_cv)

