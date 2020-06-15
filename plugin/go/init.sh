_do_plugin 'repo'

_do_log_level_warn "go"

_do_src_include_others_same_dir

function _do_go_plugin_init() {
  if ! _do_alias_feature_check "go" "go"; then
    _do_log_warn 'go' 'Skips go plugin because missing go command.'
    return
  fi

  _do_log_info "go" "Initialize plugin"

  # This is the default go commands supported
  if [ -z "${DO_GO_CMDS}" ]; then
    DO_GO_CMDS='help clean install build test gen get doctor'
  fi

  if [ -z "${DO_GO_MOD_CMDS}" ]; then
    DO_GO_MOD_CMDS="${DO_GO_CMDS} mod tidy"
  fi

  if [ -z "${DO_GO_CLI_CMDS}" ]; then
    DO_GO_CLI_CMDS="${DO_GO_CMDS} mod tidy start stop"
  fi
}
