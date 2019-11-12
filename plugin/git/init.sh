_do_assert_cmd "git"

_do_plugin "repo"

_do_log_level_warn "git"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================

function _do_git_plugin_init() {
    if ! _do_alias_feature_check "git" "git"; then 
        return 
    fi 

    _do_log_info "git" "Initialize plugin"

    # Listens to command that generates new repository and 
    # generate git support.
    _do_repo_init_hook_add "git" "init gen clone"

    # Adds alias that runs at repository level
    local cmds=( "status" "add" "commit" )
    for cmd in ${cmds[@]}; do 
        alias "do-all-git-${cmd}"="_do_proj_default_exec_all_repo_cmds git-${cmd}"
    done

    # FIXME: Fix this in the case that there is more than 
    # one project loaded.
    local proj_dir=$(_do_proj_default_get_dir)
    if  [ ! -z "${proj_dir}" ]; then 
        # Alias alias that runs at remote level 
        local cmds=( "fetch" "sync" "pull" )
        for remote in $( _do_git_get_default_remote_list "${proj_dir}" ); do 
            for cmd in ${cmds[@]}; do 
                alias "do-all-git-${cmd}-$remote"="_do_proj_default_exec_all_repo_cmds git-${cmd}-$remote"
            done
        done
    fi
}

