_do_log_level_warn "repo"

function _do_repo_is_enabled() {
    local proj_dir=$1
    local repo=$2    
    if [ -f "$proj_dir/$repo/.do.sh" ]; then 
        return 0
    else 
        return 1
    fi
}

# Change directory and push it to stack.
#
function _do_repo_dir_push() {
    local proj_dir=$1
    local repo=$2

    pushd "$proj_dir/$repo" &> /dev/null
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
function _do_repo_plugin() {
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
            _do_log_debug "repo" "Register '${cmd}' alias"

            alias "${cmd}"="${func} ${proj_dir} ${repo}"
        fi
    done
}


# Runs 'git add .' on the specified directory.
# Arguments: 
#   1.proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_repo_cmd() {
    local proj_dir=$1 
    shift
    local repo=$1
    shift

    _do_print_header_2 "$repo: $@"
    _do_repo_dir_push $proj_dir $repo 

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


# Generates a new repository under the current project directory
#
function _do_repo_gen() {
    local proj_dir=$(_do_proj_default_get_dir)

    _do_print_header_2 "Generates new repository"

    # Reads the repository name from command line.
    printf "Please enter repository name: "
    read repo

    _do_log_info "proj" "Generates new repo '${repo}' at '${proj_dir}'"

    local repo_dir="${proj_dir}/${repo}"

    # Creates the repository directory
    mkdir ${repo_dir}
    cd $repo_dir

    # Makes the .do.sh file so that this repository is picked up 
    # by devops framework.
    touch .do.sh

    # Adds empty README file
    touch README.md

    # Trigger hook for other plugins to generate more.
    _do_hook_call "_do_repo_gen" "${proj_dir}" "${repo}"

    # Triggers additional init for the repository.
    _do_repo_init $proj_dir $repo
}


# Listens to "_do_prompt" event and update the list of repo aliases
# Arguments:
#   1. dir: The current directory. This is sent from prompt plugin. 
#
function _do_repo_prompt_changed() {    
    local dir=$1

    if [ ! -f "$dir/.do.sh" ]; then 
        # Repository is not enabled for this directory
        return
    fi

    local repo=$(basename $dir)
    _do_log_info "repo" "Updates aliases for repo '${repo}'"
    
    # Removes all aliases begin with "repo-"
    for cmd in $(_do_alias_list "repo-"); do
        unalias "repo-${cmd}"
    done

    # Creates new aliases for the current repo
    for cmd in $(_do_alias_list "$repo-"); do
        alias "repo-${cmd}"="${repo}-${cmd}"
    done
}


# Initializes plugin.
function _do_repo_plugin_init() {
    _do_log_info "repo" "Plugin initialize"

    alias "do-repo-gen"="_do_repo_gen"
    _do_hook_after "_do_prompt" "_do_repo_prompt_changed"
}
