_do_plugin 'repo'

_do_log_level_warn "full"

_do_src_include_others_same_dir

function _do_full_plugin_init() {
  _do_log_info "full" "Initialize plugin"

  local cmds
  cmds="start stop logs"
  _DO_FULL_CMDS=${_DO_FULL_CMDS:-"${DO_REPO_BASE_CMDS} ${cmds}"}
  _DO_FULL_API_CMDS=${_DO_FULL_API_CMDS:-"${DO_REPO_API_CMDS} ${cmds}"}
  _DO_FULL_WEB_APP_CMDS=${_DO_FULL_WEB_APP_CMDS:-"${DO_REPO_WEB_APP_CMDS} ${cmds}"}
  _DO_FULL_MOBILE_APP_CMDS=${_DO_FULL_MOBILE_APP_CMDS:-"${DO_REPO_MOBILE_APP_CMDS} ${cmds}"}
  _DO_FULL_PROJ_CMDS=${_DO_FULL_PROJ_CMDS:-"${DO_REPO_PROJ_CMDS} ${cmds}"}
}
