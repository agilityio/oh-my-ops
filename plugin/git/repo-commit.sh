_do_log_level_warn "git"


# Runs git status on the specified repository.
# Arguments: 
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_commit() {
    local proj_dir=$(_do_arg_required $1)
    shift 

    local repo=$(_do_arg_required $1)    
    shift

    # Reads the repository name from command line.
    local message=$@
    if [ $# -eq 0 ]; then 
        printf "Please enter commit message: "
        read message
    fi 

    _do_repo_cmd $proj_dir $repo "git commit -m \"$message\""
    return $?
}
