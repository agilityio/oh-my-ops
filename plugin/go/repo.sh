# The array of all plugin repo comamnds.
_DO_GO_REPO_CMDS=( "help" "clean" "build" )

_DO_GO_PATHS=()

# Displays helps about how to run a repository go commands.
#
function _do_go_repo_help() {
    local proj_dir=$1
    local repo=$2

    _do_print_header_2 "$repo: Go help"

    echo "  
  ${repo}-go-help: 
    See go command helps

  ${repo}-go-clean: 
    Cleans go build output

  ${repo}-go-build: 
    Builds go documentation. The result is stored in doc/_build.

  ${repo}-go-start: 
    Starts the go web server as daemon, with live-reloading.

  ${repo}-go-watch: 
    Watches the go web server, with live-reloading.

  ${repo}-go-stop: 
    Stops the go web server.

  ${repo}-go-status: 
    Displays the go status.

  ${repo}-go-web: 
    Opens the go web page.
"
}


# Cleans the repository go output.
#
function _do_go_repo_clean() {
    local proj_dir=$1
    local repo=$2

    local title="$repo: cleans go build result"
    _do_print_header_2 $title

    if _do_go_is_running; then 
        _do_print_error "Go is running. ${repo}-go-stop to stop the server first."
        return 1
    fi    

    _do_go_build_ensured

    _do_go_repo_cmd $proj_dir $repo "echo TODO: Go Clean"

    local err=$?
    _do_error_report $err "$title"
    return $err
}


# Builds the go repository.
#
function _do_go_repo_build() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    local title="$repo: Builds go repository"
    _do_print_header_2 $title

    if _do_go_is_running; then 
        _do_print_error "Go is running. ${repo}-go-stop to stop the server first."
        return 1
    fi    

    _do_go_build_ensured

    local cmd="_do_go_repo_dep_package_install $proj_dir $repo"
    _do_go_repo_dep_package_walk "$proj_dir" "$repo" "\"$cmd\""

    _do_go_repo_cmd $proj_dir $repo "go install" 

    local err=$?
    _do_error_report $err "$title"
    return $err
}


# Determines if the specified directory has go enabled.
# Arguments:
#   1. dir: A directory.
# 
# Returns: 
#   0 if go enabled, 1 otherwise.
#
function _do_go_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if _do_go_repo_dep_enabled ${proj_dir} ${repo}; then 
        return 0
        
    else 
        # Go is enabled for the specified directory
        return 1
    fi 
}


# Initializes go support for a repository.
#
function _do_go_repo_init() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    if ! _do_go_repo_enabled ${proj_dir} ${repo}; then 
        _do_log_debug "go" "Skips go support for '$repo'"
        # This directory does not have go support.
        return
    fi 

    # adds the current repository to go path
    export GOPATH="$proj_dir/$repo:$GOPATH"
    
    # Sets up the alias for showing the repo go status
    _do_log_info "go" "Initialize go for '$repo'"

    # Register hooks for command repo life cycle command.
    _do_repo_plugin "${proj_dir}" "${repo}" "go" _DO_GO_REPO_CMDS 
}


# Runs any go command in docker.
# Arguments:
#   1. repo: The repository name.
#
function _do_go_repo_cmd() {
    local proj_dir=$1
    shift

    local repo=$1
    shift

    local daemon_opts=""

    if [ "$1" == "--daemon" ]; then 
        daemon_opts="-d"
        shift
    fi 

    local cmd=$@

    local repo_dir=${proj_dir}/${repo}

    docker run --rm ${daemon_opts} \
        --name="${_DO_GO_DOCKER_CONTAINER_NAME}"\
        -p=${DO_GO_PORT}:${DO_GO_PORT} \
        -e DO_ENVIRONMENT=${DO_ENVIRONMENT} \
        -v $(_do_docker_dir_resolved ${repo_dir})/doc:/app/src \
        -w=/app/src \
        ${_DO_GO_DOCKER_IMG} ${cmd}
    
    return $?
}
