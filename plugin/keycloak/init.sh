_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'keycloak'
_do_src_include_others_same_dir

# Initializes keycloak plugin.
#
function _do_keycloak_plugin_init() {
  _do_log_info 'keycloak' 'Initialize plugin'

  # This is the default keycloak version to run with.
  _DO_KEYCLOAK_VERSION=${_DO_KEYCLOAK_VERSION:-latest}

  # This is the default keycloak port.
  _DO_KEYCLOAK_PORT=${_DO_KEYCLOAK_PORT:-8080}

  # This is the default database created, and credential to access it.
  _DO_KEYCLOAK_DB=${_DO_KEYCLOAK_DB:-db}
  _DO_KEYCLOAK_USER=${_DO_KEYCLOAK_USER:-user}
  _DO_KEYCLOAK_PASS=${_DO_KEYCLOAK_PASS:-pass}

  _DO_KEYCLOAK_ADMIN_USER=${_DO_KEYCLOAK_ADMIN_USER:-admin}
  _DO_KEYCLOAK_ADMIN_PASS=${_DO_KEYCLOAK_ADMIN_PASS:-admin}
}
