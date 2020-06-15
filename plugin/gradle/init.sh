
_do_plugin 'repo'

_do_log_level_warn 'gradle'

_do_src_include_others_same_dir

function _do_gradle_plugin_init() {
  # if ! _do_alias_feature_check 'gradle' 'gradle'; then
  #   _do_log_warn 'gradle' 'Skips gradle plugin because of missing gradle command.'
  #   return
  # fi

  _do_log_info 'gradle' 'Initialize plugin'
}
