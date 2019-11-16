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

  # Listens to
  # _do_hook_before 'before_repo_dir_add' '_do_git_hook_before_repo_dir_add'

  alias _do_git=_do_git_repo_add
}
