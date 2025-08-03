### variable
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
_ga_exec_bwrap += 
_ga_exec_bwrap += --share-net
_ga_exec_bwrap += --remount-ro "/"