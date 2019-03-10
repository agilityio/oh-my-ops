
function _do_dotnet_repo_venv_start() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    _do_repo_dir_push $proj_dir $repo

    _do_print_line_1 "activate virtual environment"

    _do_dir_pop
}


function _do_dotnet_repo_venv_stop() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)
    
    _do_print_line_1 "deactivate virtual environment"
}

