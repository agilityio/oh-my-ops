_do_log_level_debug "git"


# Runs git status on the specified repository.
# Arguments: 
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_status() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)    

    _do_repo_cmd $proj_dir $repo "git status"
}

