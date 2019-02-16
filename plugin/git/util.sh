
# Gets the git root directory of the current dir
#
function _do_git_util_get_root() {
    local dir=$(git rev-parse --show-toplevel)
    local err=$?

    if _do_error $error; then
        echo ""
    else
        echo "$dir"
    fi
}


# Checks if the given git repository is up to date or not.
#
function _do_git_repo_is_up_to_date() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)
    
    _do_repo_dir_push $proj_dir $repo
    
    local err=0
    local text=$(git status)
    if [[ ${text} = *"Your branch is up-to-date"* ]]; then
        err=0
    else
        err=1
    fi

    _do_dir_pop
    return $err
}


# Checks if the given git repository is dirty or not.
# Arugments:
#   1. repo: The git repository name.
#
function _do_git_repo_is_dirty() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)
    
    _do_repo_dir_push $proj_dir $repo
    
    local err=0
    local text=$(git status)
    if [[ ${text} = *"Changes not staged"* ]] || \
       [[ ${text} = *"Changes to be committed"* ]] ||
       [[ ${text} = *"Not committing merge"* ]]; then
        err=0
    else
        err=1
    fi

    _do_dir_pop
    return $err
}

