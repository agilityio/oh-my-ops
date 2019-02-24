
# Displays helps about how to run a repository django commands.
#
function _do_django_repo_help() {
    local proj_dir=$1
    local repo=$2
    
    if ! _do_django_repo_enabled $proj_dir $repo; then 
        return
    fi 

    _do_print_header_2 "$repo: Django help"

    echo "  
  ${repo}-django-help: 
    See django command helps

  ${repo}-django-clean: 
    Cleans django build output

  ${repo}-django-build: 
    Builds django documentation. The result is stored in doc/_build.

  ${repo}-django-start: 
    Starts the django web server as daemon, with live-reloading.

  ${repo}-django-watch: 
    Watches the django web server, with live-reloading.

  ${repo}-django-stop: 
    Stops the django web server.

  ${repo}-django-status: 
    Displays the django status.

  ${repo}-django-web: 
    Opens the django web page.
"
}


# Cleans the repository django output.
#
function _do_django_repo_clean() {
    local proj_dir=$1
    local repo=$2

    if ! _do_django_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local title="$repo: cleans django build result"
    _do_print_header_2 $title

    if _do_django_is_running; then 
        _do_print_error "Django is running. ${repo}-django-stop to stop the server first."
        return 1
    fi    

    _do_python_repo_venv_start $proj_dir $repo

    # Triggers hook call for other plugin.
    _do_hook_call "_do_django_repo_clean" "${proj_dir}" "${repo}"

    _do_python_repo_venv_stop $proj_dir $repo

    local err=$?
    _do_error_report $err "$title"
    return $err
}


# Builds the django repository.
#
function _do_django_repo_build() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    if ! _do_django_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local title="$repo: Builds django repository"
    _do_print_header_2 $title

    _do_python_repo_venv_start $proj_dir $repo

    _do_dir_push $proj_dir/$repo/src
    python manage.py check
    _do_dir_pop 

    _do_python_repo_venv_stop $proj_dir $repo

    # Triggers hook call for other plugin.
    _do_hook_call "_do_django_repo_build" "${proj_dir}" "${repo}"

    local err=$?
    _do_error_report $err "$title"
    return $err
}


# Starts the django web server
#
function _do_django_repo_watch() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    if ! _do_django_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local title="$repo: Starts django web server"
    _do_print_header_2 $title

    # Activates python virtual environment.
    _do_python_repo_venv_start $proj_dir $repo

    _do_dir_push $proj_dir/$repo/src
    python manage.py runserver
    _do_dir_pop 

    # Triggers hook call for other plugin.
    _do_hook_call "_do_django_repo_build" "${proj_dir}" "${repo}"

    # Deactivates the python virtaul environment.
    _do_python_repo_venv_stop $proj_dir $repo

    local err=$?
    _do_error_report $err "$title"
    return $err
}


# Determines if the specified directory has django enabled.
# Arguments:
#   1. dir: A directory.
# 
# Returns: 
#   0 if django enabled, 1 otherwise.
#
function _do_django_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if [ -f $proj_dir/$repo/src/manage.py ]; then 
        return 0
        
    else 
        # Django is enabled for the specified directory
        return 1
    fi 
}


# Gets the repository's sphinx web url
function _do_django_repo_get_url() {
    local proj_dir=$1
    local repo=$2
    echo "http://localhost:${DO_DJANGO_PORT}"
}


# Opens the web browser
#
function _do_django_repo_web() {
    _do_log_info "django" "web"

    if ! _do_django_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local url=$(_do_django_repo_get_url $proj_dir $repo)
    _do_print_header_2 "$repo: Open django web at $url"

    _do_browser_open "$url"
}


# Initializes django support for a repository.
#
function _do_django_repo_init() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    if ! _do_django_repo_enabled ${proj_dir} ${repo}; then 
        _do_log_debug "django" "Skips django support for '$repo'"
        # This directory does not have django support.
        return
    fi 

    # Sets up the alias for showing the repo django status
    _do_log_info "django" "Initialize django for '$repo'"

    # Register hooks for command repo life cycle command.
    _do_repo_alias_add $proj_dir $repo "bin" "help clean build start watch stop status web"
}

