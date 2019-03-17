_do_assert_cmd "python"  

_do_plugin "docker"

_do_log_level_warn "python"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================
# The list of commands availble, eg., do-python-help, 
_DO_PYTHON_CMDS=( "help" )


# Initializes python plugin.
#
function _do_python_plugin_init() {
    _do_log_info "python" "Initialize plugin"
    _do_plugin_cmd "python" _DO_PYTHON_CMDS

    _do_repo_init_hook_add "python" "init"

    # Adds alias that runs at repository level
    local cmds=( "clean" "build" )
    for cmd in ${cmds[@]}; do 
        alias "do-all-python-${cmd}"="_do_proj_default_exec_all_repo_cmds python-${cmd}"
    done
}


# Prints out helps for python supports.
#
function _do_python_help() {
    _do_log_info "python" "help"
}

