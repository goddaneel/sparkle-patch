### variable
## variable
_gs_path_pwd := $(realpath .)
_gs_path_temp := $(_gs_path_pwd)/temp
_gs_path_patch := $(_gs_path_pwd)/patch
_gs_path_origin := $(_gs_path_pwd)/sparkle
_gs_path_project := /_project/sparkle


## array
_ga_exec_bwrap += '/usr/bin/bwrap'
_ga_exec_bwrap += --die-with-parent
_ga_exec_bwrap += --unshare-all
_ga_exec_bwrap += --proc "/proc"
_ga_exec_bwrap += --dev "/dev"
_ga_exec_bwrap += --tmpfs "/tmp"
_ga_exec_bwrap += --tmpfs "${HOME}"
_ga_exec_bwrap += --ro-bind "/etc" "/etc"
_ga_exec_bwrap += --ro-bind "/srv" "srv"
_ga_exec_bwrap += --ro-bind "/opt" "/opt"
_ga_exec_bwrap += --ro-bind "/usr/bin" "/usr/bin"
_ga_exec_bwrap += --ro-bind "/usr/include" "/usr/include"
_ga_exec_bwrap += --ro-bind "/usr/lib" "/usr/lib"
_ga_exec_bwrap += --ro-bind "/usr/lib" "/usr/lib"
_ga_exec_bwrap += --ro-bind "/usr/lib64" "/usr/lib64"
_ga_exec_bwrap += --ro-bind "/usr/libexec" "/usr/libexec"
_ga_exec_bwrap += --ro-bind "/usr/share" "/usr/share"
_ga_exec_bwrap += --ro-bind "/usr/src" "/usr/src"
_ga_exec_bwrap += --symlink "/usr/bin" "/bin"
_ga_exec_bwrap += --symlink "/usr/lib" "/lib"
_ga_exec_bwrap += --symlink "/usr/lib64" "/lib64"
_ga_exec_bwrap += --unsetenv "PS1"
_ga_exec_bwrap += --bind "$(_gs_path_temp)/home" "${HOME}"
_ga_exec_bwrap += --ro-bind-try "$(_gs_path_pwd)/.bashrc" "${HOME}/.bashrc"
_ga_exec_bwrap += --ro-bind-try "$(_gs_path_pwd)/.npmrc" "${HOME}/.npmrc"
_ga_exec_bwrap += --remount-ro "${HOME}"
_ga_exec_bwrap += --overlay-src "$(_gs_path_origin)"
_ga_exec_bwrap += --tmp-overlay "$(_gs_path_project)"
_ga_exec_bwrap += --ro-bind "$(_gs_path_origin)/.git" "$(_gs_path_project)/.git"
_ga_exec_bwrap += --bind "$(_gs_path_temp)/project/dist" "$(_gs_path_project)/dist"
_ga_exec_bwrap += --bind "$(_gs_path_temp)/project/extra" "$(_gs_path_project)/extra"
_ga_exec_bwrap += --bind "$(_gs_path_temp)/project/node_modules" "$(_gs_path_project)/node_modules"
_ga_exec_bwrap += --bind "$(_gs_path_temp)/project/out" "$(_gs_path_project)/out"
_ga_exec_bwrap += --bind "$(_gs_path_temp)/project/resources/files" "$(_gs_path_project)/resources/files"
_ga_exec_bwrap += --bind "$(_gs_path_temp)/project/resources/sidecar" "$(_gs_path_project)/resources/sidecar"
_ga_exec_bwrap += --chdir "${_gs_path_project}"
_ga_exec_bwrap += --share-net
_ga_exec_bwrap += --remount-ro "/"



### target
## mkdir
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


## test
.PHONY: testcr
testcr: temp
	$(_ga_exec_bwrap) --remount-ro "$(_gs_path_project)" '/usr/bin/bash'

.PHONY: testcv
testcv: temp
	$(_ga_exec_bwrap) '/usr/bin/bash'
