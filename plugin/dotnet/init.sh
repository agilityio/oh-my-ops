_do_plugin "docker"

_do_log_level_warn "dotnet"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================
# The list of commands availble, eg., do-dotnet-help, do-dotnet-build, ...
_DO_DOTNET_CMDS=( "help" )


# Initializes dotnet plugin.
#
function _do_dotnet_plugin_init() {
    if ! _do_alias_feature_check "dotnet" "dotnet"; then 
        return 
    fi 

    _do_log_info "dotnet" "Initialize plugin"
    _do_plugin_cmd "dotnet" _DO_DOTNET_CMDS

    _do_repo_init_hook_add "dotnet" "init"

    # Adds alias that runs at repository level
    local cmds=( "clean" "build" )
    for cmd in ${cmds[@]}; do 
        alias "do-all-dotnet-${cmd}"="_do_proj_default_exec_all_repo_cmds dotnet-${cmd}"
    done
}



# Prints out helps for dotnet supports.
#
function _do_dotnet_help() {
    _do_log_info "dotnet" "help"
}
