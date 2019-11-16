_do_plugin "docker"

_do_log_level_warn "npm"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================
# The list of commands availble, eg., do-npm-help, do-npm-build, ...
_DO_NPM_CMDS=("help")

# Initializes npm plugin.
#
function _do_npm_plugin_init() {
  if ! _do_alias_feature_check "npm" "npm"; then
    return
  fi

  _do_log_info "npm" "Initialize plugin"
  _do_plugin_cmd "npm" _DO_NPM_CMDS

  _do_repo_init_hook_add "npm" "init"

  # Adds alias that runs at repository level
  local cmds=("clean" "build")
  for cmd in ${cmds[@]}; do
    alias "do-all-npm-${cmd}"="_do_proj_default_exec_all_repo_cmds npm-${cmd}"
  done
}

# Prints out helps for npm supports.
#
function _do_npm_help() {
  _do_log_info "npm" "help"
}
