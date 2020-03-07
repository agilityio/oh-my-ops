_do_plugin 'repo'

_do_log_level_warn "npm"

_do_src_include_others_same_dir

function _do_npm_plugin_init() {
  # Checks that the `npm` command is available or not.
  if ! _do_alias_feature_check "npm" "npm"; then
    _do_log_warn 'npm' 'Skips npm plugin because missing npm command.'
    return
  fi

  _do_log_info "npm" "Initialize plugin"


  # This is the default npm commands supported
  if [ -z "${DO_NPM_CMDS}" ]; then
    DO_NPM_CMDS='help install'
  fi
}
