_do_plugin "docker"

_do_log_level_debug "firebase"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================
# The list of commands availble, eg., do-firebase-help, do-firebase-start, ...
_DO_FIREBASE_CMDS=( "help" )


# Initializes firebase plugin.
#
function _do_firebase_plugin_init() {
    if ! _do_alias_feature_check "firebase" "firebase"; then 
        return 
    fi 

    _do_log_info "firebase" "Initialize plugin"
    _do_plugin_cmd "firebase" _DO_FIREBASE_CMDS

    _do_repo_init_hook_add "firebase" "init"
}


# Prints out helps for firebase supports.
#
function _do_firebase_help() {
    _do_log_info "firebase" "help"
}
