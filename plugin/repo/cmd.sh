# This is a dictionary that map repo plugin command to related options.
declare -Ag _DO_REPO_PLUGIN_CMD_OPTS

# Adds plugin commands for a repository. This will register alias for
# trigger the plugin command easily in shell.
# For example, register plugin 'npm' , 'build' command on repository 'lime'
# will result in an alias named 'do-lime-npm-build'.
#
# Arguments:
#   1. repo: The repository to add the command for.
#   2. plugin: The plugin that going to handle the command.
#   3. names: The command name to add.
#
function _do_repo_plugin_cmd_add() {
  local repo=${1?'repo arg required'}
  local plugin=${2?'plugin arg required'}
  shift 2

  [[ $# -gt 0 ]] || _do_assert_fail 'cmds arg required'

  # Makes sure that the specified plugin is a valid one.
  _do_plugin_is_loaded "${plugin}" || _do_assert_fail "Invalid or not loaded plugin '${plugin}'"

  # Gets the directory where the repostory is at.
  local dir
  dir=$(_do_repo_dir_get "${repo}")

  # ----------------------------------------------------------------------------
  # Adds the new plugin to the repo's plugin list
  local plugins
  plugins=$(_do_plugin_set_name "${repo}")

  if _do_set_exists "${plugins}"; then
    _do_set_append "${plugins}" "${plugin}"
  else
    _do_set_new "${plugins}" "${plugin}"
  fi

  # ----------------------------------------------------------------------------
  # Adds the set of plugin command to the repo's plugin command list.
  local cmds
  cmds=$(_do_plugin_cmd_set_name "${repo}" "${plugin}")
  _do_set_exists "${cmds}" || _do_set_new "${cmds}"

  # ----------------------------------------------------------------------------
  # Appends the new commands to the command set
  while (($# > 0)); do
    local cmd="$1"
    if ! _do_set_contains "${cmds}" "${cmd}"; then
      _do_set_append "${cmds}" "${cmd}"

      # ------------------------------------------------------------------------
      # Registers alias for execute the command.
      __do_repo_plugin_cmd_alias "${dir}" "${repo}" "${plugin}" "${cmd}"
    fi

    shift 1
  done
}

function _do_repo_plugin_cmd_opts() {
  local repo=${1?'repo arg required'}
  local plugin=${2?'plugin arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  if [[ $# -lt 0 ]]; then
    return
  fi

  # Stores the command ops for later use
  local key="${repo}-${plugin}-${cmd}"
  # shellcheck disable=SC2034
  # shellcheck disable=SC2124
  _DO_REPO_PLUGIN_CMD_OPTS[${key}]="$@"
}


# Determines if the specified plugin is registered for the specified repository.
#
# Arguments:
#   1. repo: The repository name.
#   2. plugin: The plugin to search for.
#
function _do_repo_plugin_exists() {
  local repo=${1?'repo arg required'}
  local plugin=${2?'plugin arg required'}

  local plugins

  plugins=$(_do_plugin_set_name "${repo}")
  if _do_set_exists "${plugins}" && _do_set_contains "${plugins}" "${plugin}"; then
    return 0
  else
    return 1
  fi
}

# Determines if the specified plugin command is registered for the
# specified repository.
#
# Arguments:
#   1. repo: The repository name.
#   2. plugin: The plugin to search for.
#   3. cmd: The command to search for.
#
function _do_repo_plugin_cmd_exists() {
  local repo=${1?'repo arg required'}
  local plugin=${2?'plugin arg required'}
  local cmd=${3?'cmd arg required'}

  local cmds
  cmds=$(_do_plugin_cmd_set_name "${repo}" "${plugin}")

  if _do_set_exists "${cmds}" && _do_set_contains "${cmds}" "${cmd}"; then
    return 0
  else
    return 1
  fi
}

# Internal function to build alias for a single plugin command on
# the specified repository.
#
# Arguments:
#   1. dir: The directory where the repository is at.
#   2. repo: The repository to add the alias for.
#   3. plugin: The plugin to register.
#   4. cmd: The command to register.
#
function __do_repo_plugin_cmd_alias() {
  local dir=${1?'repo arg required'}
  local repo=${2?'repo arg required'}
  local plugin=${3?'plugin arg required'}
  local cmd=${4?'cmd arg required'}

  # Builds the alias to executes the command
  local cmd_d
  cmd_d=$(_do_string_to_dash "${cmd}")
  local name="do-${repo}-${plugin}-${cmd_d}"

  _do_log_debug 'repo' "Adds cmd '${cmd}' alias '${name}' for repo: ${repo}, at dir: ${dir}"

  if type "${name}" &>/dev/null; then
    # The function dedicated for this command is provided.
    # Nothing has to be done.
    return
  fi

  # First, looks for the exact command handler to run.
  local repo_u=
  repo_u=$(_do_string_to_undercase "${repo}")

  local plugin_u
  plugin_u=$(_do_string_to_undercase "${plugin}")

  local cmd_u
  cmd_u=$(_do_string_to_undercase "${cmd}")

  local f1="_do_${repo_u}_${plugin_u}_${cmd_u}"
  local f2="_do_${plugin_u}_repo_cmd_${cmd_u}"
  local f3="_do_${plugin_u}_repo_cmd"

  local funcs=("${f1} ${f2} ${f3}")
  local func

  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  if [ "${cmd}" == "help" ]; then
    for func in ${funcs[@]}; do
      if type "${func}" &>/dev/null; then
    # This is the special case for help command.
    # Generates a function that triggers help command for the current plugin.
    local src
    src="
    function ${name}() {
      _do_print_line_1 \"${name}\"

      local sub_cmd
      for sub_cmd in \$(_do_repo_plugin_cmd_list \"${repo_u}\" \"${plugin_u}\"); do
        local sub_cmd_d
        sub_cmd_d=\$(_do_string_to_dash \"\${sub_cmd}\")

        local s
        s=\$(${func} \"${dir}\" ${repo} ${cmd} \${sub_cmd} \${_DO_REPO_PLUGIN_CMD_OPTS[${repo_u}-${plugin_u}-\${sub_cmd}]})

        [ -z \"\${s}\" ] || _do_print_repo_help_cmd ${plugin_u} ${repo_u} \"\${sub_cmd_d}\" \"\${s}\"
      done
    }"
        eval "${src}"
        return
      fi
    done

  else
    # Generates a function that triggers the command handler.

    for func in ${funcs[@]}; do
      if type "${func}" &>/dev/null; then
        # The function handler found.
        # Generates code for executing it.

        eval "
        function ${name}() {
            local err=0
            _do_dir_push ${dir}

            {
                _do_print_header_1 \"${name}\" &&
                ${func} ${dir} ${repo} ${cmd} \${_DO_REPO_PLUGIN_CMD_OPTS[${repo}-${plugin}-${cmd}]} &&
                _do_print_finished \"${name}: Success!\"
            } || {
                err=1
                _do_print_error \"${name}: Failed\"
            }

            _do_dir_pop
            return \${err}
        }"

        return
      fi
    done

    _do_log_warn 'repo' "No handler for ${name}. Please add '${name}', '${f1}', '${f2}', or '${f3}' function to handle it."
    return 1
  fi
}

function _do_repo_plugin_list() {
  local repo=${1?'repo arg required'}

  local plugins

  plugins=$(_do_plugin_set_name "${repo}")
  _do_set_print "${plugins}"
}

# Gets out the list of command available for a repository.
#
# Arguments:
#   1. repo: The repository to get the command.
#   2. plugin: The plugin to get the command.
#
function _do_repo_plugin_cmd_list() {
  local repo=${1?'repo arg required'}
  local plugin=${2?'plugin arg required'}

  local arr

  arr=$(_do_plugin_cmd_set_name "${repo}" "${plugin}")
  _do_set_print "${arr}"
}

function _do_plugin_set_name() {
  local repo=${1?'repo arg required'}
  echo "_repo_${repo}"
}

function _do_plugin_cmd_set_name() {
  local repo=${1?'repo arg required'}
  local plugin=${2?'plugin arg required'}
  echo "_repo_${repo}_${plugin}"
}
