_do_log_level_debug "docker"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================

function _do_docker_plugin_init() {
  if ! _do_alias_exist "docker"; then
    _do_log_warn "docker" "Disable 'docker' supports because missing 'docker' command."
    return
  fi

  _do_log_info "docker" "Initialize plugin"
}
