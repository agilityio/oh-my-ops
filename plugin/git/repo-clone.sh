_do_log_level_warn "git-clone"


# Listens to the _do_repo_clone hook and generates git support.
# Arguments:
# 1. proj_dir: Required. The project directory.
# 2. repo: Required. The repository name.
function _do_git_repo_clone() {
    local proj_dir=${1?'proj_dir arg required'}
    _do_dir_assert "${proj_dir}"

    local repo=${2?'repo arg required'}
        
    _do_log_info "git-clone" "Generates git support"

    local title="Clone git repository at ${proj_dir}/${repo}"
    _do_print_header_2 ${title}

    _do_repo_dir_push $proj_dir $repo

    local err=0
    
    # Initializes an empty git structure
    # The default origin would be at local
    git init .

    # Copies over the list of git remotes from devops repository
    local default_repo=$( _do_proj_repo_get_default "${proj_dir}" )
    _do_log_debug "git-clone" "Default repo: $default_repo"

    if [ ! -z "${default_repo}" ]; then 
        local remotes=$( _do_git_repo_get_remote_list ${proj_dir} ${default_repo} )

        for remote in ${remotes[@]}; do 
            # Resolves the git uri for this repository.
            local uri=$(_do_git_repo_get_remote_uri $proj_dir $repo $remote)

            if [ ! -z "$uri" ]; then 
                _do_log_debug "git-clone" "Add git remote '$remote': '$uri'"
                _do_print_line_1 "Clone from $remote"

                git remote add $remote $uri && git fetch ${remote}
                if _do_error $?; then 
                    # Some thing wrong
                    err=1
                fi
            fi
        done 

        # Gets the current git branch
        local default_branch=$(_do_git_repo_get_branch $proj_dir $default_repo)
        _do_assert "${default_branch}"

        # Gets out all remote branches available and check if the default branch is available
        local found=$(git for-each-ref refs/remotes | cut -d/ -f4- | grep "$default_branch")

        if [ -z "$found" ]; then
            # Just checkout the master branch by default
            git checkout master
        else
            _do_print_line_1 "Checkout branch $branch"

            # Checks out the develop branch if seeing it.
            git checkout $branch
        fi
    fi
    
    _do_dir_pop

    _do_error_report $err $title
    return $err
}
