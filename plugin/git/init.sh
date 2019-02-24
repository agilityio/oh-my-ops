_do_assert_cmd "git"

_do_plugin "repo"

_do_log_level_debug "git"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================

function _do_git_plugin_init() {
    _do_log_info "git" "Initialize plugin"

    # Listens to command that generates new repository and 
    # generate git support.
    _do_repo_cmd_hook_add "git" "init help gen clone status"

    # Adds alias that runs at repository level
    local cmds=( "status" )
    for cmd in ${cmds[@]}; do 
        alias "do-proj-git-${cmd}"="_do_proj_default_exec_all_repo_cmds git-${cmd}"
    done

    # Alias alias that runs at remote level 
    local cmds=( "fetch" "sync" )
    for remote in $( _do_git_get_default_remote_list ); do 
        for cmd in ${cmds[@]}; do 
            alias "do-proj-git-${cmd}-$remote"="_do_proj_default_exec_all_repo_cmds git-${cmd}-$remote"
        done
    done
}

