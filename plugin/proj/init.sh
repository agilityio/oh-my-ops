_do_plugin 'repo'

_do_log_level_warn 'proj'
_do_src_include_others_same_dir

# Initializes the plugin.
#
function _do_proj_plugin_init() {
  _do_log_info 'proj' 'Initialize plugin'

  # Provides short command for user
  _do_alias "_do_proj" "_do_proj_add"
}

function _do_proj_repo_cmd_help() {
  _do_log_info 'proj' 'Show help'
}

# Adds a new project to the management list.
# Arguments:
#   1. dir: The project directories
#   2. name: The project custom name.
#
function _do_proj_add() {
  local dir=${1?'dir arg required'}
  local name=${2?'name arg required'}

  # Adds the project as the root repository of all
  _do_repo_dir_add "${dir}" "${name}"
}
