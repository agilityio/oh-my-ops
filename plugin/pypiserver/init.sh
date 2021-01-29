_do_plugin 'docker'
_do_plugin 'repo'
_do_plugin 'htpasswd'

_do_log_level_warn 'pypiserver'
_do_src_include_others_same_dir

# Initializes pypiserver plugin.
#
function _do_pypiserver_plugin_init() {
  _do_log_info 'pypiserver' 'Initialize plugin'

  # This is the default pypiserver version to run with.
  _DO_PYPISERVER_VERSION=${_DO_PYPISERVER_VERSION:-latest}

  _DO_PYPISERVER_PORT=${_DO_PYPISERVER_PORT:-8080}
  _DO_PYPISERVER_USER=${_DO_PYPISERVER_USER:-admin}
  _DO_PYPISERVER_PASS=${_DO_PYPISERVER_PASS:-password}
}
