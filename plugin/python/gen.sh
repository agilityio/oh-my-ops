_do_log_level_warn "python"


# Listens to the _do_repo_gen hook and generates python support.
#
function _do_python_repo_gen() {
    local proj_dir=$(_do_arg_required $1)

    local repo=$(_do_arg_required $2)
        
    _do_print_line_1 "Generates python support"

    _do_repo_dir_push $proj_dir $repo
    touch ./requirements.txt
    local err=$?

    _do_dir_pop

    return $err
}
