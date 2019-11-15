_do_plugin 'repo'

_do_log_level_warn "full"

_do_src_include_others_same_dir


function _do_full_plugin_init() {
    _do_log_info "full" "Initialize plugin"

    # Initializes common commands.
    # These are the base life-cycle commands that commonly found in any 
    # project.
    if [ -z "${DO_FULL_BASE_CMDS}" ]; then 
        DO_FULL_BASE_CMDS='help clean install build test'
    fi
    
    # Provides some additional comands for apis development.
    if [ -z "${DO_FULL_API_CMDS}" ]; then 
        DO_FULL_API_CMDS="${DO_FULL_BASE_CMDS} run package deploy"
    fi
    
    # Provides some additional commands for web app development.
    if [ -z "${DO_FULL_WEB_APP_CMDS}" ]; then 
        DO_FULL_WEB_APP_CMDS="${DO_FULL_BASE_CMDS} run package deploy"
    fi
    
    # Provides some additional commands for mobile app development.
    if [ -z "${DO_FULL_MOBILE_APP_CMDS}" ]; then 
        DO_FULL_MOBILE_APP_CMDS="${DO_FULL_BASE_CMDS} build-ios build-android run-ios run-android package deploy"
    fi

    # Provides some additional for a full project development.
    if [ -z "${DO_FULL_PROJ_CMDS}" ]; then 
        DO_FULL_PROJ_CMDS="${DO_FULL_BASE_CMDS} package deploy"
    fi
}
