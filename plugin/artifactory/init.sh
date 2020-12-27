_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'artifactory'
_do_src_include_others_same_dir

# Initializes artifactory plugin.
#
function _do_artifactory_plugin_init() {
  _do_log_info 'artifactory' 'Initialize plugin'

  # This is the default artifactory version to run with.
  _DO_ARTIFACTORY_VERSION=${_DO_ARTIFACTORY_VERSION:-latest}

  # This is the default artifactory port.
  _DO_ARTIFACTORY_HTTP_REST_PORT=${_DO_ARTIFACTORY_HTTP_REST_PORT:-8081}
  _DO_ARTIFACTORY_HTTP_UI_PORT=${_DO_ARTIFACTORY_HTTP_UI_PORT:-8082}

  # This is the default database created, and credential to access it.
  _DO_ARTIFACTORY_USER=${_DO_ARTIFACTORY_USER:-admin}
  _DO_ARTIFACTORY_PASS=${_DO_ARTIFACTORY_PASS:-password}
}
