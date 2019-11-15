_do_log_level_debug "docker-compose"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================

function _do_docker-compose_plugin_init() {
    if ! _do_alias_exist "docker-compose"; then 
        _do_log_warn "docker-compose" "Disable 'docker-compose' supports because missing 'docker-compose' command."
        return 
    fi

    _do_log_info "docker-compose" "Initialize plugin"
}
