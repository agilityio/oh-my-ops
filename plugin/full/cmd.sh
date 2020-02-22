# Prints out help for full plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. helped_cmd. The sub command to displays the help for.
#
function _do_full_repo_cmd_help() {
  local dir=${1?'dir arg is required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'arg command is required'}
  local helped_cmd=${4?'helped_cmd command is required'}

  # shellcheck disable=SC2207
  local sub_cmds=( $(_do_full_sub_cmd_list "${dir}" "${repo}" "${helped_cmd}") )

  if [[ ${#sub_cmds[@]} -eq 0 ]]; then
    # Don't display any help since this full command does not have
    # any sub command.
    return
  fi

  echo "Shortcut for running all children's '${helped_cmd}' commands:"
  local sub_cmd
  # shellcheck disable=SC2068
  for sub_cmd in ${sub_cmds[@]}; do
    echo "      * ${sub_cmd}"
  done
}


# The main command handler for all sub commands.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_full_repo_cmd() {
  local sub_cmd

  # shellcheck disable=SC2068
  for sub_cmd in $(_do_full_sub_cmd_list $@); do
    # Executes the command
    ${sub_cmd}
  done
}


function _do_full_sub_cmd_list() {
  local dir=${1?'dir arg is required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'arg command is required'}
  shift 3

  local err=0

  _do_log_debug 'full' "do '${cmd}' full on ${repo}, at: ${dir}"

  # Reads out the repository line by line.
  while read -r sub; do
    # For each line, convert two the array of 2 parts.
    # The first one should be the directory dir, and the second
    # should be the directory name.
    local parts=(${sub})

    local sub_dir=${parts[0]}
    local sub_repo=${parts[1]}

    local sub_plugin
    local sub_cmd

    for sub_plugin in $(_do_repo_plugin_list "${sub_repo}"); do
      if [ "${sub_plugin}" == 'full' ]; then
        # Ignore full command.
        continue
      fi

      for sub_cmd in $(_do_repo_plugin_cmd_list "${sub_repo}" "${sub_plugin}"); do

        if [ "${sub_cmd}" == "${cmd}" ] || [[ "${sub_cmd}" == "${cmd}:"* ]]; then
          _do_log_debug 'full' "Run command: ${sub_repo}-${sub_plugin}-${sub_cmd}, ${sub_dir}"

          # Triggers the plugin command handler.
          local sub_cmd_d
          sub_cmd_d=$(_do_string_to_dash "${sub_cmd}")

          local sub_plugin_d
          sub_plugin_d=$(_do_string_to_dash "${sub_plugin}")

          echo "do-${sub_repo}-${sub_plugin_d}-${sub_cmd_d}"
        fi
      done
    done

  done <<< "$(_do_repo_list "${dir}")"

  return ${err}
}
