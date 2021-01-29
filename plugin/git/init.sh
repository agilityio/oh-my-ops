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
  _DO_GIT_CMDS=${_DO_GIT_CMDS:-'help status add commit push pull sync checkout-branch create-branch remove-branch create-stash apply-stash create-tag remove-tag'}
}
