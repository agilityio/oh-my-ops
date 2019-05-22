
function _do_npm_repo_venv_start() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    _do_repo_dir_push $proj_dir $repo

    _do_print_line_1 "activate virtual environment"

    _do_dir_pop
}


function _do_npm_repo_venv_stop() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    
    _do_print_line_1 "deactivate virtual environment"
}

