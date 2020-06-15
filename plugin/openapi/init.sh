_do_plugin 'repo'
_do_log_level_warn 'openapi'
_do_src_include_others_same_dir

# Initializes git plugin.
#
function _do_openapi_plugin_init() {
  if ! _do_alias_feature_check 'openapi' 'openapi-generator'; then
    _do_log_warn 'openapi' 'openapi plugin disabled because no openapi-generator command. See https://openapi-generator.tech/docs/installation for installation.'
    return
  fi

  if [ -z "${DO_OPENAPI_CONFIG_FILE}" ]; then
    DO_OPENAPI_CONFIG_FILE='openapi-config.yml'
  fi

  if [ -z "${DO_OPENAPI_SCHEMA_FILE}" ]; then
    DO_OPENAPI_SCHEMA_FILE='openapi-schema.yml'
  fi

  _do_log_info 'openapi' 'Initialize plugin'
}
