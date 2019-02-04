_do_plugin "proj"

# Docker Supports
_do_log_level_debug "docker"

# The array of all plugin repo comamnds.
_DO_DOCKER_REPO_CMDS=( "help" )


# ==============================================================================
# Proj plugin integration
# ==============================================================================


# If the specified repository has a file "Dockerfile", docker is enabled for 
# the repository. 
#
function _do_docker_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if [ -f "${proj_dir}/${repo}/Dockerfile" ]; then 
        # Docker integration is enabled for this repository.
        return 0
    else
        return 1
    fi
}
 
# Initializes docker support for a repository.
#
function _do_docker_repo_init() {
    local proj_dir=$1
    local repo=$2

    if ! _do_docker_repo_enabled "${proj_dir}" "${repo}"; then 
        return
    fi

    _do_log_debug "docker" "Initializes docker integration for $repo"

    # Registers tmux command such as 'repo-tmux-start', etc.
    _do_proj_repo_plugin "${proj_dir}" "${repo}" "docker" _DO_DOCKER_REPO_CMDS 
}


# Displays helps for docker supports.
#
function _do_docker_repo_help() {
    local proj_dir=$1
    local repo=$2

    echo "  ${repo}-docker-help: See docker command helps"
}

# ==============================================================================
# Plugin Init
# ==============================================================================
_DO_DOCKER_CMDS=( "help" "stop-all" )

function _do_docker_init() {
    _do_log_info "docker" "Initialize plugin"
    _do_plugin_cmd "docker" _DO_DOCKER_CMDS
    
}

function _do_docker_stop_all() {
    _do_log_info "docker" "Stop all running containers"
    _do_hook_call "_do_docker_stop_all" 
}

# Listens to init proj repo hook.
_do_proj_plugin "docker"
