_do_plugin 'repo'

_do_log_level_warn 'git'
_do_src_include_others_same_dir

# Initializes git plugin.
#
function _do_git_plugin_init() {
  if ! _do_alias_feature_check "git" "git"; then
    _do_log_warn 'git' 'Git plugin disabled because no git command'.
    return
  fi

  _do_log_info 'git' 'Initialize plugin'
}
