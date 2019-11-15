_do_plugin 'repo'

_do_log_level_debug "full"

_do_src_include_others_same_dir


function _do_full_plugin_init() {
    _do_log_info "full" "Initialize plugin"    

    # Provides shortcuts for developer
    alias _do_full="_do_full_repo_add"
}
