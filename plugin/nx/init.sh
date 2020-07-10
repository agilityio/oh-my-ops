_do_plugin 'repo'

_do_log_level_warn "nx"

_do_src_include_others_same_dir

function _do_nx_plugin_init() {
  # Checks that the `nx` command is available or not.
  if ! _do_alias_feature_check "nx" "nx"; then
    _do_log_warn 'nx' 'Skips nx plugin because missing nx command.'
    return
  fi

  _do_log_info "nx" "Initialize plugin"


  # This is the default nx commands supported
  if [ -z "${DO_NX_CMDS}" ]; then
    DO_NX_CMDS='help affected:build affected:test affected:lint'
  fi

  if [ -z "${DO_NX_ANGULAR_APP_CMDS}" ]; then
    DO_NX_ANGULAR_APP_CMDS='build test start lint'
  fi

  if [ -z "${DO_NX_ANGULAR_LIB_CMDS}" ]; then
    DO_NX_ANGULAR_LIB_CMDS='build test lint'
  fi

  if [ -z "${DO_NX_NODE_APP_CMDS}" ]; then
    DO_NX_NODE_APP_CMDS='build test start lint'
  fi

  if [ -z "${DO_NX_NODE_LIB_CMDS}" ]; then
    DO_NX_NODE_LIB_CMDS='build test lint'
  fi

}
