_do_log_level_debug "git-gen"


# Listens to the _do_repo_gen hook and generates git support.
#
function _do_git_repo_gen() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)
        
    _do_log_info "git-gen" "Generates git support"

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
            _do_log_debug "git-gen" "Add git remote '$remote': '$uri'"
            git remote add $remote $uri
        fi
    done 

    _do_dir_pop
}
