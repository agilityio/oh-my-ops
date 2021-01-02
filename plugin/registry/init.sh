_do_plugin 'docker'
_do_plugin 'repo'
_do_plugin 'htpasswd'

_do_log_level_warn 'registry'
_do_src_include_others_same_dir

# Initializes registry plugin.
# See: https://buildvirtual.net/create-a-private-docker-registry-tutorial/
#
function _do_registry_plugin_init() {
  _do_log_info 'registry' 'Initialize plugin'

  # The registry commands available.
  _DO_REGISTRY_CMDS=${_DO_REGISTRY_CMDS:-'install login logout start stop status logs attach help'}

  # This is the default registry version to run with.
  _DO_REGISTRY_VERSION=${_DO_REGISTRY_VERSION:-2}

  # This is the default registry host.
  # Uses localhost to avoid https requirements.
  _DO_REGISTRY_HOST=${_DO_REGISTRY_HOST:-"localhost"}

  # This is the default registry port.
  _DO_REGISTRY_PORT=${_DO_REGISTRY_PORT:-5000}

  _DO_REGISTRY_USER=${_DO_REGISTRY_USER:-user}
  _DO_REGISTRY_PASS=${_DO_REGISTRY_PASS:-pass}

  # shellcheck disable=SC2034
  _DO_DOCKER_REGISTRY="${_DO_REGISTRY_HOST}:${_DO_REGISTRY_PORT}"
}
