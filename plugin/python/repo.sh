# The array of all plugin repo commands.
_DO_PYTHON_REPO_CMDS=( "help" "venv-start" "venv-stop" )

_DO_PYTHON_PATHS=()

# Displays helps about how to run a repository python commands.
#
function _do_python_repo_help() {
    local proj_dir=$1
    local repo=$2
    
    if ! _do_python_repo_venv_enabled $proj_dir $repo; then 
        return
    fi 

    _do_print_header_2 "$repo: Python help"

    echo "  
  ${repo}-python-help: 
    See python command helps

  ${repo}-python-venv-start: 
    Activates python virtual environment


  ${repo}-python-venv-stop:
    Deactivates python virtual environment.
"
}


# Initializes python support for a repository.
#
function _do_python_repo_init() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    if ! _do_python_repo_venv_enabled ${proj_dir} ${repo}; then 
        _do_log_debug "python" "Skips python support for '$repo'"
        # This directory does not have python support.
        return
    fi 

    # Sets up the alias for showing the repo python status
    _do_log_info "python" "Initialize python for '$repo'"

    # Register hooks for command repo life cycle command.
    _do_repo_plugin "${proj_dir}" "${repo}" "python" _DO_PYTHON_REPO_CMDS 
}

