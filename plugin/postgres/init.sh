_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'postgres'
_do_src_include_others_same_dir

# Initializes postgres plugin.
#
function _do_postgres_plugin_init() {
  _do_log_info 'postgres' 'Initialize plugin'

  # This is the default postgres version to run with.
  _DO_POSTGRES_VERSION=${_DO_POSTGRES_VERSION:-latest}

  # This is the default postgres port.
  _DO_POSTGRES_PORT=${_DO_POSTGRES_PORT:-5432}

  # This is the default database created, and credential to access it.
  _DO_POSTGRES_DB=${_DO_POSTGRES_DB:-db}
  _DO_POSTGRES_USER=${_DO_POSTGRES_USER:-user}
  _DO_POSTGRES_PASS=${_DO_POSTGRES_PASS:-pass}
}
