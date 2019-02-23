
# ==============================================================================
# Project Repository Support
#
# Basic Life Cycle Command
# 
# init:
#   Initializes devops supports.
#
# cd: 
#   Changes the working directory to the repository's directory.
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
    "status"
    "help"
    "clean"
    "build"
    "start"
    "stop"
    "watch"
    "deploy"
)


# Initializes project repository support.
# Other plugins will register hooks on this function to implement
# additional behaviors. For example, the git plugin would add hooks to this 
# function to provides more git-specific command likes `repo-git-status`, etc.
#
function _do_repo_init() {
    local proj_dir=$1
    local repo=$2

    _do_log_debug "repo" "Init $proj_dir $repo"

    # local proj_dir=$(_do_arg_required $1)
    # local repo=$(_do_arg_required $2)

    _do_hook_call "_do_repo_init" "${proj_dir}" "${repo}"

    # Adds alias to quickly go to a repository directory
    for cmd in "${_DO_REPO_COMMANDS[@]}"; do 
        alias "${repo}-${cmd}"="_do_repo_${cmd} ${proj_dir} ${repo}"
    done
}


# Prints out helps for all repo's available commands.
#
function _do_repo_help() {
    local proj_dir=$1
    local repo=$2

    _do_print_header_2 "${repo}-help"

    # Triggers hook call for other plugins
    _do_hook_call "_do_repo_help" "${proj_dir}" "${repo}" "--short"
}


# Changes the current directory to the project's repo root.
#
function _do_repo_cd() {
    local proj_dir=$1
    local repo=$2

    cd "${proj_dir}/${repo}"

    # Triggers hook call for other plugin.
    _do_hook_call "_do_repo_cd" "${proj_dir}" "${repo}"
}


function _do_repo_status() {
    local proj_dir=$1
    local repo=$2

    _do_print_header_2 "${repo}-status"

    # Triggers hook call for other plugin.
    _do_hook_call "_do_repo_status" "${proj_dir}" "${repo}"
}

function _do_repo_clean() {
    local proj_dir=$1
    local repo=$2

    _do_print_header_2 "${repo}-clean"

    # Triggers hook call for other plugin.
    _do_hook_call "_do_repo_clean" "${proj_dir}" "${repo}"
}

function _do_repo_build() {
    local proj_dir=$1
    local repo=$2

    _do_print_header_2 "${repo}-build"

    # Triggers hook call for other plugin.
    _do_hook_call "_do_repo_build" "${proj_dir}" "${repo}"

}

function _do_repo_start() {
    local proj_dir=$1
    local repo=$2

    _do_print_header_2 "${repo}-start"

    # Triggers hook call for other plugin.
    _do_hook_call "_do_repo_start" "${proj_dir}" "${repo}"

}


function _do_repo_stop() {
    local proj_dir=$1
    local repo=$2

    _do_print_header_2 "${repo}-stop"

    # Triggers hook call for other plugin.
    _do_hook_call "_do_repo_stop" "${proj_dir}" "${repo}"
}


function _do_repo_watch() {
    local proj_dir=$1
    local repo=$2

    _do_print_header_2 "${repo}-watch"

    # Triggers hook call for other plugin.
    _do_hook_call "_do_repo_watch" "${proj_dir}" "${repo}"
}


function _do_repo_deploy() {
    local proj_dir=$1
    local repo=$2

    _do_print_header_2 "${repo}-deploy"

    # Triggers hook call for other plugin.
    _do_hook_call "_do_repo_deploy" "${proj_dir}" "${repo}"
}
