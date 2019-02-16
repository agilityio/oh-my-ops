_do_plugin "repo"
_do_log_level_debug "proj"


function _do_proj_plugin() {
    local plugin=$1

    _do_log_debug "proj" "Register proj plugin $plugin"

    for cmd in "${_DO_REPO_COMMANDS[@]}"; do 
        local func="_do_${plugin}_repo_${cmd}"

        if _do_alias_exist "${func}"; then 
            _do_hook_after "_do_repo_${cmd}" "${func}"
        fi
    done
}


# Adds a project to devops management.
# Arguments:
#   1. dir: The absolute director to the project home.
#
function _do_proj_add() {
    local dir=$1

    # Initializes all sub directories as a code repository
    _do_log_debug "proj" "Adds proj directory $dir"
    for name in $( ls -A $dir ); do 
        if [ -f "$dir/$name/.do.sh" ]; then 
            _do_repo_init $dir $name
        fi
    done
}


# Initializes plugin.
#
function _do_proj_plugin_init() {
    _do_log_info "proj" "Initialize plugin"
    _do_hook_call "_do_proj_init" 
    _do_proj_add $(_do_dir_normalized "$DO_HOME/..")
}
