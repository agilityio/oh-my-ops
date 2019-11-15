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

    _do_plugin_is_loaded "${plugin}" || _do_assert_fail "Invalid or not loaded plugin '${plugin}'"

    # Gets the directory where the repostory is at.
    local dir=$(_do_repo_dir_get "${repo}")

    local plugins=$(_do_plugin_array_name "${repo}")
    local cmds=$(_do_plugin_cmd_array_name "${repo}" "${plugin}")

    _do_array_exists "${plugins}" ||_do_array_new "${plugins}"
    _do_array_exists "${cmds}" ||_do_array_new "${cmds}"

    _do_array_contains "${plugins}" "${plugin}" || _do_array_append "${plugins}" "${plugin}"

    # Appends the new commands to it and make sure no duplicate
    while (( $# > 0 )); do
        local cmd="$1"
        _do_array_contains "${cmds}" "${cmd}" || _do_array_append "${cmds}" "${cmd}"

        # Registers alias for execute the command.
        __do_repo_plugin_cmd_alias "${dir}" "${repo}" "${plugin}" "${cmd}"

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
   _DO_REPO_PLUGIN_CMD_OPTS[${key}]="$@"

}


function _do_repo_plugin_exists() {
    local repo=${1?'repo arg required'}
    local plugin=${2?'plugin arg required'}

    local plugins=$(_do_plugin_array_name "${repo}")
    if _do_array_exists "${plugins}" && _do_array_contains "${plugins}" "${plugin}"; then 
        return 0
    else 
        return 1
    fi
}

function _do_repo_plugin_cmd_exists() {
    local repo=${1?'repo arg required'}
    local plugin=${2?'plugin arg required'}
    local cmd=${3?'cmd arg required'}

    local cmds=$(_do_plugin_cmd_array_name "${repo}" "${plugin}")
    if _do_array_exists "${cmds}" && _do_array_contains "${cmds}" "${cmd}"; then 
        return 0
    else 
        return 1
    fi
}


# Handles the change directory command.
# This command be registered automatically for all repository.
#
function _do_repo_repo_cmd_cd() {
    local dir=${1?'dir arg required'}
    cd ${dir} &> /dev/null
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
    local name="do-${repo}-${plugin}-${cmd}"
    _do_log_debug 'repo' "Adds cmd '${cmd}' alias '${name}' for repo: ${repo}, at dir: ${dir}"

    if type "${name}" &>/dev/null; then
        # The function dedicated for this command is provided.
        # Nothing has to be done.
        return
    fi

    # First, looks for the exact command handler to run.
    local handler=''

    local exact_handler="_do_${plugin}_repo_cmd_${cmd}"
    local generic_handler="_do_${plugin}_repo_cmd"

    if type "${exact_handler}" &>/dev/null; then
        handler="${exact_handler}"
    elif type "${generic_handler}" &>/dev/null; then
        handler="${generic_handler}"
    fi

    if [ -z "${handler}" ]; then 
        _do_log_warn 'repo' "No command handler found for ${name}. Please add '${name}', '${exact_handler}', or '${generic_handler}' function to handle it."
        return 1
    else
        # The function handler exists, execute it.
        eval "function ${name}() { 
            ${handler} ${dir} ${repo} ${cmd} \${_DO_REPO_PLUGIN_CMD_OPTS[${repo}-${plugin}-${cmd}]}
        }"
        return
    fi
}

function _do_repo_plugin_list() {
    local repo=${1?'repo arg required'}

    local plugins=$(_do_plugin_array_name "${repo}")
    _do_array_print "${plugins}"
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

    local arr=$(_do_plugin_cmd_array_name "${repo}" "${plugin}")
    _do_array_print "${arr}"
}


# Executes all commands for the specified repository and plugins.
#
# Arguments:
#   1. repo: The repo to run 
#   2. plugin: The plugin to run.
#   3. cmds: The list of commands to run
#
function _do_repo_plugin_cmd_run() {
    local repo=${1?'repo arg required'}
    local plugin=${2?'plugin arg required'}
    shift 2

    # Makes sure at least one command to run.
    [[ $# -gt 0 ]] || _do_assert_fail 'cmds arg required'

    local arr=$(_do_plugin_cmd_array_name "${repo}" "${plugin}")

    # Gets the directory where the repostory is at.
    local dir=$(_do_repo_dir_get "${repo}")


    # Appends the new commands to it and make sure no duplicate
    while (( $# > 0 )); do
        local cmd="$1"

        # Makes sure that the command has already registered.
        _do_array_contains "${arr}" "${cmd}" || \
            _do_assert_fail "${plugin}-${cmd} is not available for repository ${repo}"

        # Executes the command handler
        local handler="do-${repo}-${plugin}-${cmd}"
        _do_print_line_1 "Runs ${handler}"

        local dir=$(_do_repo_dir_get "${repo}")


        ${handler} "${dir}" "${repo}" ${cmd} || _do_assert_fail "Fail to executes ${handler}"

        shift 1
    done
}


function _do_plugin_array_name() {
    local repo=${1?'repo arg required'}
    echo "_repo_${repo}"
}


function _do_plugin_cmd_array_name() {
    local repo=${1?'repo arg required'}
    local plugin=${2?'plugin arg required'}
    echo "_repo_${repo}_${plugin}"
}
