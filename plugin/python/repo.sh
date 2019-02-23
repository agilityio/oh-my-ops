# The array of all plugin repo comamnds.
_DO_PYTHON_REPO_CMDS=( "help" "clean" "build" )

_DO_PYTHON_PATHS=()

# Displays helps about how to run a repository python commands.
#
function _do_python_repo_help() {
    local proj_dir=$1
    local repo=$2
    
    if ! _do_python_repo_enabled $proj_dir $repo; then 
        return
    fi 

    _do_print_header_2 "$repo: Python help"

    echo "  
  ${repo}-python-help: 
    See python command helps

  ${repo}-python-clean: 
    Cleans python build output

  ${repo}-python-build: 
    Builds python documentation. The result is stored in doc/_build.

  ${repo}-python-start: 
    Starts the python web server as daemon, with live-reloading.

  ${repo}-python-watch: 
    Watches the python web server, with live-reloading.

  ${repo}-python-stop: 
    Stops the python web server.

  ${repo}-python-status: 
    Displays the python status.

  ${repo}-python-web: 
    Opens the python web page.
"
}


function _do_python_repo_venv_activate() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    _do_repo_dir_push $proj_dir $repo


    if [ ! -d ".venv" ]; then 
        _do_print_line_1 "activate virtual environment"
        python -m venv .venv
        
        # Activates the python virtual environmebnt
        source .venv/bin/activate

        pip install --upgrade pip
        pip install -r $proj_dir/$repo/requirements.txt
    else 
        _do_print_line_1 "activate virtual environment"
        # Activates the python virtual environmebnt
        source .venv/bin/activate
    fi 

    _do_dir_pop
}


function _do_python_repo_venv_deactivate() {
    _do_print_line_1 "deactivate virtual environment"
    deactivate 
}

# Cleans the repository python output.
#
function _do_python_repo_clean() {
    local proj_dir=$1
    local repo=$2

    if ! _do_python_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local title="$repo: cleans python build result"
    _do_print_header_2 $title

    if _do_python_is_running; then 
        _do_print_error "Python is running. ${repo}-python-stop to stop the server first."
        return 1
    fi    

    _do_python_repo_venv_activate $proj_dir $repo

    # Triggers hook call for other plugin.
    _do_hook_call "_do_python_repo_clean" "${proj_dir}" "${repo}"

    _do_python_repo_venv_deactivate $proj_dir $repo

    local err=$?
    _do_error_report $err "$title"
    return $err
}


# Builds the python repository.
#
function _do_python_repo_build() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    if ! _do_python_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local title="$repo: Builds python repository"
    _do_print_header_2 $title

    _do_python_repo_venv_activate $proj_dir $repo

    # TODO: Remove this
    _do_dir_push $proj_dir/$repo/src
    python manage.py check
    _do_dir_pop 

    # Triggers hook call for other plugin.
    _do_hook_call "_do_python_repo_build" "${proj_dir}" "${repo}"

    _do_python_repo_venv_deactivate $proj_dir $repo

    local err=$?
    _do_error_report $err "$title"
    return $err
}


# Determines if the specified directory has python enabled.
# Arguments:
#   1. dir: A directory.
# 
# Returns: 
#   0 if python enabled, 1 otherwise.
#
function _do_python_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if [ -f $proj_dir/$repo/requirements.txt ]; then 
        return 0
        
    else 
        # Python is enabled for the specified directory
        return 1
    fi 
}


# Initializes python support for a repository.
#
function _do_python_repo_init() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    if ! _do_python_repo_enabled ${proj_dir} ${repo}; then 
        _do_log_debug "python" "Skips python support for '$repo'"
        # This directory does not have python support.
        return
    fi 

    # Sets up the alias for showing the repo python status
    _do_log_info "python" "Initialize python for '$repo'"

    # Register hooks for command repo life cycle command.
    _do_repo_plugin "${proj_dir}" "${repo}" "python" _DO_PYTHON_REPO_CMDS 
}

