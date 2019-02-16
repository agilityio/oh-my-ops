
# Gets the git root directory of the current dir
#
function _do_git_root() {
    local dir=$(git rev-parse --show-toplevel)
    local err=$?

    if _do_error $error; then
        echo ""
    else
        echo "$dir"
    fi
}


# Determines if the specified directory has git enabled.
# Arguments:
#   1. dir: A directory.
# 
# Returns: 
#   0 if git enabled, 1 otherwise.
#
function _do_git_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if [ -d "$proj_dir/$repo/.git" ]; then 
        return 0
    else 
        # Git is enabled for the specified directory
        return 1
    fi 
}


# Checks if the given git repository is up to date or not.
#
function _do_git_repo_up_to_date() {
    local proj_dir=$1
    local repo=$2

    local err=0
    _do_repo_dir_push $proj_dir $repo

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
    local repo=$1
    local err=0

    _do_repo_dir_push $proj_dir $repo

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

function _do_git_repo_is_clean() {
    local repo=$1

    if _do_git_repo_is_dirty $repo; then
        return 1
    else
        return 0
    fi
}


# Checks if the repository has the specified branch or not.
# Arugments:
#   1. repo: The git repository name.
#   2. branch: The git branch name.
#
function _do_git_repo_has_branch() {
    local proj_dir=$1
    local repo=$1
    local branch=$2
    local success=0

    _do_dir_repo_push $repo

    local text=$(git branch -l)
    if [[ ${text} = *"$branch"* ]]; then
        success=0
    else
        success=1
    fi

    _do_dir_pop
    return $success
}
