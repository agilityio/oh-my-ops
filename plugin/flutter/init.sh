_do_plugin 'repo'

_do_log_level_warn 'flutter'

_do_src_include_others_same_dir

function _do_flutter_plugin_init() {
  if ! _do_alias_feature_check 'flutter' 'flutter'; then
    _do_log_warn 'flutter' 'Skips flutter plugin because of missing flutter command.'
    return
  fi

  _do_log_info 'flutter' 'Initialize plugin'
}
