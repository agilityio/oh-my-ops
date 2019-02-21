_do_log_level_debug "git-clone"


# Listens to the _do_repo_clone hook and generates git support.
#
function _do_git_repo_clone() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)
        
    _do_log_info "git-clone" "Generates git support"

    local title="Clone git repository at ${proj_dir}/${repo}"
    _do_print_header_2 ${title}

    _do_repo_dir_push $proj_dir $repo
    
    # Initializes an empty git structure
    # The default origin would be at local
    git init .

    # Copies over the list of git remotes from devops repository
    local remotes=$( _do_git_get_default_remote_list )
    for remote in ${remotes[@]}; do 

        # Resolves the git uri for this repository.
        local uri=$(_do_git_repo_get_remote_uri $repo $remote)

        if [ ! -z "$uri" ]; then 
            _do_log_debug "git-clone" "Add git remote '$remote': '$uri'"
            _do_print_header_2 ${title}
            git remote add $remote $uri

            # Just fetch out all code from the remote.
            git fetch ${remote}
        fi
    done 

    # Gets the current git branch
    local branch=$(git branch -a)
    if [[ ${text} = *"bitbucket/develop"* ]]; then
        # Checks out the develop branch if seeing it.
        git checkout "develop"
    else
        git checkout master
    fi


    _do_dir_pop
}
