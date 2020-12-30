_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'registry'
_do_src_include_others_same_dir

# Initializes registry plugin.
#
function _do_registry_plugin_init() {
  _do_log_info 'registry' 'Initialize plugin'

  # This is the default registry version to run with.
  _DO_REGISTRY_VERSION=${_DO_REGISTRY_VERSION:-latest}

  # This is the default registry port.
  _DO_REGISTRY_PORT=${_DO_REGISTRY_PORT:-5000}

  _DO_REGISTRY_USER=${_DO_REGISTRY_USER:-}
  _DO_REGISTRY_PASS=${_DO_REGISTRY_PASS:-}
}
