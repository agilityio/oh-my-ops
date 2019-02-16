
_do_log_level_debug "git-remote"


# This function is a util function to compute the remote uri for a given
# repository and remote name.
# Arguments:
#   1. repo: The repository
#   2. remote: The remote name.
#
function _do_git_repo_get_remote_uri() {
    local repo=$1
    local remote=$2

    _do_dir_push $DO_HOME
    
    # Remove the last .git
    # For example, if a remote is ssh://git@bitbucket.org/abc/devops.git
    # The result would be ssh://git@bitbucket.org/abc
    local uri=$( git config --local --get "remote.${remote}.url" | sed -e 's/\/[^\/]*\.git$//' )

    _do_dir_pop

    if [ -z "$uri" ]; then 
        echo ""
    else 
        echo "${uri}/${repo}.git"
    fi
}


function _do_git_repo_get_remote_list() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)
    
    _do_repo_dir_push $proj_dir $repo 

    git remote

    _do_dir_pop
}


# Gets the default git remote list available 
# at devops repository. 
#
function _do_git_get_default_remote_list() {
    _do_dir_push $DO_HOME
    git remote
    _do_dir_pop
}


# Fetch changes from a git remote.
# Arguments: 
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_remote_fetch() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)    
    local remote=$(_do_arg_required $3)    

    _do_repo_cmd $proj_dir $repo "git fetch $remote"
}


# Pull changes from a git remote.
# Arguments: 
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_remote_pull() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)    
    local remote=$(_do_arg_required $3)    
    
    local branch=$(_do_git_repo_get_branch $proj_dir $repo)

    _do_repo_cmd $proj_dir $repo "echo git pull $remote $branch"
}


# Sync changes from a git remote.
# Arguments: 
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_remote_sync() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)
    local remote=$(_do_arg_required $3)

    local branch=$(_do_git_repo_get_branch $proj_dir $repo)
    _do_repo_cmd $proj_dir $repo "echo git push $remote $branch"
}


function _do_git_repo_remote_init() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    # For all git remotes, register additional command such as git fetch, git sync, ...
    for remote in $(_do_git_repo_get_remote_list $proj_dir $repo); do 
        _do_log_info "git-remote" "Initialize git remote for '$remote'"
        _do_hook_call "_do_git_repo_remote_init" $proj_dir $repo $remote

        # Register git fetch command
        local names=( "fetch" "pull" "sync" )
        for name in ${names[@]}; do
            local cmd="${repo}-git-${name}-${remote}"

            _do_log_debug "git-remote" "  Register '$cmd' alias"
            alias "${cmd}"="_do_git_repo_remote_${name} ${proj_dir} ${repo} ${remote}"
        done

    done    
}
