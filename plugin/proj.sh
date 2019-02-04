_do_log_level_warn "proj"


# Adds a project to devops management.
# Arguments:
#   1. dir: The absolute director to the project home.
#
function _do_proj_add() {
    local dir=$1

    # Initializes all sub directories as a code repository
    for d in $( ls $dir ); do 
        if [ -f "$dir/$d/.do.sh" ]; then 
            _do_proj_repo_init "$dir" "$d"
        fi
    done
}


# Change directory and push it to stack.
#
function _do_proj_repo_dir_push() {
    local proj_dir=$1
    local repo=$2

    pushd "$proj_dir/$repo" &> /dev/null
}


function _do_proj_plugin() {
    local plugin=$1

    _do_log_debug "proj" "Register proj plugin $plugin"

    for cmd in "${_DO_REPO_COMMANDS[@]}"; do 
        local func="_do_${plugin}_repo_${cmd}"

        if _do_alias_exist "${func}"; then 
            _do_hook_after "_do_proj_repo_${cmd}" "${func}"
        fi
    done
}



# Registers plugin specific repo commands. 
# Arguments:
#   1. proj_dir: The project absolute directory.
#   2. repo: The repo name.
#   3. plugin: The plugin name.
#   4. The global array name that contains all plugin commands.
#
# Notes:
#   odd syntax here for passing array parameters: 
#   http://stackoverflow.com/questions/8082947/how-to-pass-an-array-to-a-bash-function
#
function _do_proj_repo_plugin() {
    local proj_dir=$1
    local repo=$2
    local plugin=$3
    local cmds=$4[@]

    for cmd in "${!cmds}"; do 
        # Converts the command to undercase
        local under_cmd=$(_do_string_to_undercase $cmd)
        local func="_do_${plugin}_repo_${under_cmd}"

        local cmd="${repo}-${plugin}-${cmd}"

        if ! _do_alias_exist "${cmd}"; then 
            # Register an alias for the plugin repo command.
            _do_log_debug "proj" "Register '${cmd}' alias"

            alias "${cmd}"="${func} ${proj_dir} ${repo}"
        fi
    done
}


# Runs 'git add .' on the specified directory.
# Arguments: 
#   1.proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_proj_repo_cmd() {
    local proj_dir=$1 
    shift
    local repo=$1
    shift

    _do_print_header_2 "$repo: $@"
    _do_proj_repo_dir_push $proj_dir $repo 

    $@

    _do_dir_pop
}


# ==============================================================================
# Project Repository Support
#
# Basic Life Cycle Command
# 
# init:
#   Initializes devops supports.
#
# help:
#   Prints out helps for available devops commands.
# 
# clean:
#   Cleans the repository built artifact.
# 
# build: 
#   Builds the repository.
#
# start: 
#   Starts the repository in local environment with live-reloading ability.
#
# deploy:
#   Deploys the repository.
#
# ==============================================================================

# The list of commands available to any project repository.
_DO_REPO_COMMANDS=(
    "init"
    "cd"
    "help"
    "clean"
    "build"
    "start"
    "deploy"
)


# Initializes project repository support.
# Other plugins will register hooks on this function to implement
# additional behaviors. For example, the git plugin would add hooks to this 
# function to provides more git-specific command likes `repo-git-status`, etc.
#
function _do_proj_repo_init() {
    local proj_dir=$1
    local repo=$2

    _do_hook_call "_do_proj_repo_init" "${proj_dir}" "${repo}"

    # Adds alias to quickly go to a repository directory
    for cmd in "${_DO_REPO_COMMANDS[@]}"; do 
        alias "${repo}-${cmd}"="_do_proj_repo_${cmd} ${proj_dir} ${repo}"
    done
}


# Prints out helps for all repo's available commands.
#
function _do_proj_repo_help() {
    local proj_dir=$1
    local repo=$2

    _do_print_header_2 "${repo}-help"

    # Triggers hook call for other plugins
    _do_hook_call "_do_proj_repo_help" "${prod_dir}" "${repo}" "--short"
}


# Changes the current directory to the project's repo root.
#
function _do_proj_repo_cd() {
    local proj_dir=$1
    local repo=$2

    cd "${proj_dir}/${repo}"

    # Triggers hook call for other plugin.
    _do_hook_call "_do_proj_repo_cd" "${proj_dir}" "${repo}"
}


# Initializes plugin.
#
function _do_proj_init() {
    _do_log_info "proj" "Initialize plugin"
    _do_hook_call "_do_proj_init" 

    _do_proj_add "$DO_HOME/.."
}
