_do_plugin 'repo'

_do_log_level_warn 'dotnet'

_do_src_include_others_same_dir

function _do_dotnet_plugin_init() {
  # Makes sure the 'dotnet' command line exists.
  if ! _do_alias_feature_check 'dotnet' 'dotnet'; then
    _do_log_warn 'dotnet' 'Skips dotnet plugin because of missing dotnet command.'
    return
  fi

  _do_log_info 'dotnet' 'Initialize plugin'

  # This is the default dotnet commands supported
  if [ -z "${DO_DOTNET_CMDS}" ]; then
    DO_DOTNET_CMDS='help install clean build test'
  fi

  if [ -z "${DO_DOTNET_CLI_CMDS}" ]; then
    DO_DOTNET_CLI_CMDS="${DO_DOTNET_CMDS} start stop"
  fi

  if [ -z "${DO_DOTNET_API_CMDS}" ]; then
    DO_DOTNET_API_CMDS="${DO_DOTNET_CMDS} start stop"
  fi

  if [ -z "${DO_DOTNET_WEB_CMDS}" ]; then
    DO_DOTNET_WEB_CMDS="${DO_DOTNET_CMDS} start stop"
  fi

  if [ -z "${DO_DOTNET_TEST_CMDS}" ]; then
    DO_DOTNET_TEST_CMDS="${DO_DOTNET_CMDS}"
  fi

}
