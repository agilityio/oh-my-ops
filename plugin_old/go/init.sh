_do_plugin "docker"

_do_log_level_warn "go"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================

# The list of commands availble, eg., do-go-help, do-go-build, ...
_DO_GO_CMDS=("help")

# Initializes go plugin.
#
function _do_go_plugin_init() {

  if ! _do_alias_feature_check "go" "go"; then
    return
  fi

  _do_log_info "go" "Initialize plugin"

  _do_plugin_cmd "go" _DO_GO_CMDS

  _do_repo_init_hook_add "go" "init"

  # Adds alias that runs at repository level
  local cmds=("clean" "build")
  # shellcheck disable=SC2068
  for cmd in ${cmds[@]}; do
    alias "do-all-go-${cmd}"="_do_proj_default_exec_all_repo_cmds go-${cmd}"
  done
}

# Prints out helps for go supports.
#
function _do_go_help() {
  _do_log_info "go" "help"
}
