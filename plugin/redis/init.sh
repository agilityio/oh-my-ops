_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'redis'
_do_src_include_others_same_dir

# Initializes redis plugin.
#
function _do_redis_plugin_init() {
  _do_log_info 'redis' 'Initialize plugin'

  # This is the default redis version to run with.
  _DO_REDIS_VERSION=${_DO_REDIS_VERSION:-latest}

  # This is the default redis port.
  _DO_REDIS_PORT=${_DO_REDIS_PORT:-6379}

  # This is the default database created, and credential to access it.
  _DO_REDIS_DB=${_DO_REDIS_DB:-db}
  _DO_REDIS_USER=${_DO_REDIS_USER:-user}
  _DO_REDIS_PASS=${_DO_REDIS_PASS:-pass}
}
