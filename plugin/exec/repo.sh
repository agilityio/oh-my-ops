# Adds a new project to the management list.
# Arguments:
#   1. dir: The project custom name.
#   2. repo: The repository name.
#
function _do_exec() {
  local repo=${1?'repo arg required'}
  local dir=${2?'dir(s) arg required'}

  local repo_dir
  repo_dir=$(_do_repo_dir_get "${repo}")

  _do_dir_push "${repo_dir}" || return 1
  cd "${dir}" || return 1

  local name
  local cmds
  cmds=""

  # Finds all executable under a directory, limit to 3 level depth only.
  # shellcheck disable=SC2044
  for name in $(find . -perm +111 -type f -maxdepth 3 -print); do
    local cmd

    # Removes the first "./"
    cmd=$(echo "$name" | cut -c 3-)

    # removes the file extension from the file if any.
    # replace all weird characters to make it an alias friendly.
    # Example:
    #   for bin/run_something.hello.sh
    #   the cmd will be "bin-run-something-hello"
    #
    cmd=$(_do_string_to_dash "${cmd%%.*}")
    cmds="${cmds} ${cmd}"

    _do_log_debug "exec" "Scripts found $name, $cmd"
    _do_repo_plugin_cmd_opts "${repo}" 'exec' "${cmd}" "${dir}" "${name}"
  done

  _do_dir_pop

  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${repo}" 'exec' ${cmds}
}
