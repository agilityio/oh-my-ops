_do_plugin 'repo'

_do_log_level_warn 'proj'
_do_src_include_others_same_dir


# Initializes the plugin.
#
function _do_proj_plugin_init() {
    _do_log_info 'proj' 'Initialize plugin'

    # Provides short command for user
    alias _do_proj=_do_proj_add

    
    [ -z "${DO_PROJ_DIRS}" ] || {
        # Loads all default project

        local last_index=${#BASH_SOURCE[@]}
        last_index=$((size - 1))
        
        local file=${BASH_SOURCE[$last_index]}
        _do_log_debug "proj" "last file in bash source $file"

        local dir="$(dirname $file)"
        _do_log_debug "proj" "last dir in bash source $dir"

        _do_dir_push "${dir}"

        local proj_dir
        for proj_dir in ${DO_PROJ_DIRS}; do 
            proj_dir=$(_do_dir_normalized "${proj_dir}")
            local proj_name=$(basename ${proj_dir})
            proj_name=$(_do_string_to_alias_name "${proj_name}")

            _do_log_info 'proj' "Loads project ${proj_name} at ${proj_dir}"

            _do_proj_add "${proj_dir}" "${proj_name}"
            _do_repo_plugin_cmd_add "${proj_name}" "proj" 'help'
        done

        _do_dir_pop
    }
}


function _do_proj_repo_cmd_help() {
    _do_log_info 'proj' 'Show help'
}


# Adds a new project to the management list.
# Arguments: 
#   1. dir: The project directories
#   2. name: The project custom name.
#
function _do_proj_add() {
    local dir=${1?'dir arg required'}
    local name=${2?'name arg required'}

    # Adds the project as the root repository of all
    _do_repo_dir_add "${dir}" "${name}"
}
