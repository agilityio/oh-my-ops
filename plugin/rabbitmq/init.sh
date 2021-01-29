_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'rabbitmq'
_do_src_include_others_same_dir

# Initializes rabbitmq plugin.
#
function _do_rabbitmq_plugin_init() {
  _do_log_info 'rabbitmq' 'Initialize plugin'

  # This is the default rabbitmq version to run with.
  _DO_RABBITMQ_VERSION=${_DO_RABBITMQ_VERSION:-"3-management"}

  # This is the default rabbitmq port.
  _DO_RABBITMQ_HTTP_PORT=${_DO_RABBITMQ_HTTP_PORT:-15672}

  # This is the default database created, and credential to access it.
  _DO_RABBITMQ_USER=${_DO_RABBITMQ_USER:-admin}
  _DO_RABBITMQ_PASS=${_DO_RABBITMQ_PASS:-pass}
}
