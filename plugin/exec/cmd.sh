# Runs a exec repository command.
# Arguments:
#   1. dir: The directory to run a exec command.
#   2. repo: The repository to run the command.
#   3. cmd: Any command registered
#   4. dir: The sub directory where the command is found.
#   5. script: The executable script that are discovered.
#
function _do_exec_repo_cmd() {
  # Gets additional opts registered by _do_repo_plugin_cmd_opts
  local dir=${4?'dir required'}
  local script=${5?'script required'}
  shift 5

  # Executes the script
  # shellcheck disable=SC2068
  cd "${dir}" && ${script} $@ || return 1
}
