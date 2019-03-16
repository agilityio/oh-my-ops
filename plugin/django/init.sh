_do_plugin "python"

_do_log_level_warn "django"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================

# The list of commands availble, eg., do-django-help, do-django-build, ...
_DO_DJANGO_CMDS=( "help" )


# Initializes django plugin.
#
function _do_django_plugin_init() {
    _do_log_info "django" "Initialize plugin"

    _do_plugin_cmd "django" _DO_DJANGO_CMDS

    _do_repo_cmd_hook_add "django" "init help clean build"

    # Adds alias that runs at repository level
    local cmds=( "clean" "build" )
    for cmd in ${cmds[@]}; do 
        alias "do-all-django-${cmd}"="_do_proj_default_exec_all_repo_cmds django-${cmd}"
    done
}



# Prints out helps for django supports.
#
function _do_django_help() {
    _do_log_info "django" "help"
}

