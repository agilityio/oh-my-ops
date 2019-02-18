
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
    "test"
)

for src_file in "${src_files[@]}"; do
    source "${DO_HOME}/src/${src_file}.sh"
done

_do_log_level_warn "main"

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

# Initializes all plugins registered
_do_plugin_init
_do_print_banner
