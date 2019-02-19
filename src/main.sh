
# The remaining arguments that cannot be parsed.
_DO_MAIN_ARGS=()

# Plugins system should be loaded
_DO_PLUGINS_ENABLED="yes"

# Boots up the framework fastest possible.
_DO_MAIN_QUICK="no"


# Parse input arguments
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -np|--no-plugins)
        _DO_PLUGINS_ENABLED="no"
        shift
        ;;

        -q|--quick)
        _DO_MAIN_QUICK="yes"
        shift
        ;;

        *)    # unknown option
        _DO_MAIN_ARGS+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done


# Checks if the current shell is bash
if [ _DO_MAIN_QUICK == "no" ] && ! echo "$0" | grep -q "bash"; then 
    echo "This script only support bash! Please executes 'bash' to change to bash shell instead."
    return
fi


# Loads core libraries
src_files=(
    "os"
    "src"
    "dir"
    "file"
    "string"
    "alias"
    "color"
    "print"
    "trap"
    "assert"
    "arg"
    "log"
    "error"
    "alias"
    "hook"
    "plugin"
)

# Loads all core source files.
for src_file in "${src_files[@]}"; do
    source "${DO_HOME}/src/${src_file}.sh"
done

_do_log_level_warn "main"


if [ "${_DO_PLUGINS_ENABLED}" == "yes" ]; then 
    if [ -z "${DO_PLUGINS}" ]; then
        _do_log_debug "main" "load all plugins"

        # Loads all plugins.
        for plugin in $( ls -A ${DO_HOME}/plugin ); do
            _do_plugin $(_do_file_name_without_ext $plugin)
        done

    else
        _do_log_debug "main" "load just specified plugins"
        # Just loads the specified plugins.
        _do_plugin  "${DO_PLUGINS}"
    fi
fi


# Initializes all plugins registered
_do_plugin_init


# Display banner for full activation.
if [ "$_DO_MAIN_QUICK" == "no" ]; then 
    _do_print_banner
fi 

