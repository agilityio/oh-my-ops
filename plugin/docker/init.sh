_do_log_level_warn "docker"

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

  # The default repo docker commands supported
  _DO_DOCKER_CMDS=${_DO_DOCKER_CMDS:-'help clean build package deploy'}
  _DO_DOCKER_NETWORK=${_DO_DOCKER_NETWORK:-'do-network'}

  # The ip that docker container can access the host machine
  _DO_DOCKER_HOST_IP=${_DO_DOCKER_HOST_IP:-"$(_do_docker_host_ip)"}

  # The domain name for the docker host ip.
  # A new entry will be added to /etc/hosts via hostfile plugin.
  _DO_DOCKER_HOST_NAME=${_DO_DOCKER_HOST_NAME:-"do"}

  # The docker registry end point.
  # Other plugin like 'registry' might override this.
  _DO_DOCKER_REGISTRY=${_DO_DOCKER_REGISTRY:-}
}
