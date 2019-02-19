plugin_dir="$DO_HOME/plugin"

_do_log_level_warn "plugin"

# This is the array of loaded plugins
declare -a _DO_PLUGIN_LIST


# Determines if a plugin is loaded.
# $1. plugin_name: string
#
function _do_plugin_is_loaded() {
    for i in "${_DO_PLUGIN_LIST[@]}"; do 
        if [ "$i" = "$1" ]; then 
            # Found the plugin in the loaded list.
            return 0
        fi 
    done

    # Could not found in the loaded list.
    return 1
}


# Requires a plugin
# $1. plugin_names: string, space delimited
#
function _do_plugin() {
    local plugin_name

    for plugin_name in $1; do
        if ! _do_plugin_is_loaded $plugin_name; then 

            # Add the plugin into the loaded list.
            _DO_PLUGIN_LIST+=( "$plugin_name" )

            # Loads the plugin.
            local init_file="${plugin_dir}/${plugin_name}.sh"
            if [ ! -f "${init_file}" ]; then 
                init_file="${plugin_dir}/${plugin_name}/init.sh"
            fi

            if [ -f "${init_file}" ]; then 
                source "${init_file}"
            fi

            _do_log_debug "plugin" "load $plugin_name"
        fi 
    done
}


# Registers plugin specific repo commands. 
# Arguments:
#   1. plugin: The plugin name.
#   2. The global array name that contains all plugin commands.
#
# Notes:
#   odd syntax here for passing array parameters: 
#   http://stackoverflow.com/questions/8082947/how-to-pass-an-array-to-a-bash-function
#
function _do_plugin_cmd() {
    local plugin=$1
    local cmds=$2[@]

    for cmd in "${!cmds}"; do 
        # Converts the command to undercase
        local under_cmd=$(_do_string_to_undercase $cmd)

        local func="_do_${plugin}_${under_cmd}"
        local cmd="do-${plugin}-${cmd}"

        if ! _do_alias_exist "${cmd}"; then 
            # Register an alias for the plugin repo command.
            _do_log_debug "plugin" "Register '${cmd}' alias"

            alias "${cmd}"="${func}"
        fi
    done
}


# Initializes plugin module.
#
function _do_plugin_init() {
    
    # For all loaded plugins, trigger plugin init function if that 
    # exists. For example, for 'git' plugin, the init function should be 
    # named '_do_git_plugin_init'.
    #
    for plugin in "${_DO_PLUGIN_LIST[@]}"; do 
        local func="_do_${plugin}_plugin_init" 

        if _do_alias_exist "${func}"; then 
            ${func}
        fi 
    done


    for plugin in "${_DO_PLUGIN_LIST[@]}"; do 
        local func="_do_${plugin}_plugin_ready" 

        if _do_alias_exist "${func}"; then 
            ${func}
        fi 
    done
}
