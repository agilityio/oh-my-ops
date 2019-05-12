_do_log_level_warn "git-branch"


# Gets the current git branch
#
function _do_git_repo_get_branch() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    
    _do_repo_dir_push $proj_dir $repo
    echo "$(git status | grep 'On branch ' | awk {'print $3'})"
    _do_dir_pop
}



# Gets the current git branch
#
function _do_git_repo_get_branch_list() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    
    _do_repo_dir_push $proj_dir $repo
    
    echo "$(git for-each-ref refs/heads | cut -d/ -f3-)"

    _do_dir_pop
}


# Checks if the repository has the specified branch or not.
# Arugments:
#   1. repo: The git repository name.
#   2. branch: The git branch name.
#
function _do_git_repo_has_branch() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    local branch=${3?'branch arg required'}
        
    local err=0

    _do_repo_dir_push $proj_dir $repo

    local text=$(_do_git_repo_get_branch_list $proj_dir $repo)
    if [[ ${text} = *"$branch"* ]]; then
        err=0
    else
        err=1
    fi

    _do_dir_pop
    return $err
}


# Arguments: 
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_branch_checkout() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    local branch=${3?'branch arg required'}

    _do_repo_cmd $proj_dir $repo "echo git checkout $branch"
}


# Arguments: 
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_branch_merge() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    local branch=${3?'branch arg required'}

    _do_repo_cmd $proj_dir $repo "echo git merge $branch"
}


function _do_git_repo_branch_init() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    # For all git remotes, register additional command such as git fetch, git sync, ...
    for branch in $(_do_git_repo_get_branch_list $proj_dir $repo); do 
        _do_log_info "git-branch" "Initialize git branch for '$branch'"
        _do_hook_call "_do_git_repo_branch_init" $proj_dir $repo $branch

        # Register git fetch command
        local names=( "checkout" "merge" )
        local name
        for name in ${names[@]}; do
            local cmd="${repo}-git-${name}-${branch}"
            _do_log_debug "git-branch" "  Register alias '$cmd'"

            alias "${cmd}"="_do_git_repo_branch_${name} ${proj_dir} ${repo} ${branch}"
        done
    done    
}
