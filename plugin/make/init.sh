_do_plugin 'repo'
_do_log_level_warn 'make'
_do_src_include_others_same_dir


function _do_make_plugin_init() {
  # Makes sure the 'make' command line exists.
  if ! _do_alias_feature_check 'make' 'make'; then
    _do_log_warn 'make' 'Skips make plugin because of missing make command.'
    return
  fi

  _do_log_info 'make' 'Initialize plugin'

  # This is the default make commands supported
  if [ -z "${DO_MAKE_CMDS}" ]; then
    DO_MAKE_CMDS="${DO_REPO_BASE_CMDS} doctor"
  fi

  if [ -z "${DO_MAKE_CLI_CMDS}" ]; then
    DO_MAKE_CLI_CMDS="${DO_MAKE_CMDS} start stop"
  fi

  if [ -z "${DO_MAKE_API_CMDS}" ]; then
    DO_MAKE_API_CMDS="${DO_MAKE_CMDS} start stop"
  fi

  if [ -z "${DO_MAKE_WEB_CMDS}" ]; then
    DO_MAKE_WEB_CMDS="${DO_MAKE_CMDS} start stop"
  fi
}
