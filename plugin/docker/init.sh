_do_assert_cmd "docker"

_do_plugin "proj"

# Docker Supports
_do_log_level_warn "docker"

_do_src_include_others_same_dir


# ==============================================================================
# Plugin Init
# ==============================================================================
_DO_DOCKER_CMDS=( "help" "stop-all" )

function _do_docker_plugin_init() {
    if ! _do_alias_exist "docker"; then 
        _do_log_warn "docker" "Disable 'docker' supports because missing 'docker' command."
        return 
    fi

    _do_log_info "docker" "Initialize plugin"
    _do_plugin_cmd "docker" _DO_DOCKER_CMDS

}

function _do_docker_stop_all() {
    _do_log_info "docker" "Stop all running containers"
    _do_hook_call "_do_docker_stop_all"
}
