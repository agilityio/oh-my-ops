_do_log_level_debug "flutter"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================
# The list of commands availble, eg., do-flutter-help, do-flutter-build, ...
_DO_FLUTTER_CMDS=("help")

# Initializes flutter plugin.
#
function _do_flutter_plugin_init() {
  if ! _do_alias_feature_check "flutter" "flutter"; then
    _do_log_debug 'flutter' 'Skips flutter supports due to missing flutter command.'
    return
  fi

  _do_log_info 'flutter' 'Initialize plugin'
  _do_plugin_cmd "flutter" _DO_FLUTTER_CMDS

  _do_repo_init_hook_add "flutter" "init"

  # Adds alias that runs at repository level
  local cmds=("clean" "build")
  for cmd in ${cmds[@]}; do
    alias "do-all-flutter-${cmd}"="_do_proj_default_exec_all_repo_cmds flutter-${cmd}"
  done
}

# Prints out helps for flutter supports.
#
function _do_flutter_help() {
  _do_log_info "flutter" "help"
}
