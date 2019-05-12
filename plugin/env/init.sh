_do_log_level_debug "env"

# ==============================================================================
# Plugin Init
# ==============================================================================

_DO_ENV_CMDS=( "help" "logout" )

# The current working environment.
DO_ENV=""

# Initializes env plugin.
# Arguments: None.
#
function _do_env_plugin_init() {

    if [ -z "${DO_ENVS}" ]; then 
        _do_log_debug "env" "Env plugin is disabled because of empty DO_ENVS settings"
        return 
    fi 

    _do_log_info "env" "Initialize plugin"
    _do_plugin_cmd "env" _DO_ENV_CMDS

    for env in $DO_ENVS; do 
        alias "do-env-${env}-login"="_do_env_login ${env}"
    done 
}


# Prints help about this plugin.
# Arguments: None
#
function _do_env_help() {
    _do_log_info "env" "help"

    _do_print_header_2 "Environment Help"

    echo "  
  Environment Variables:
    DO_ENV=\"${DO_ENV}\"

  do-env-help:
    Show this help.
  
  do-env-logout:
    Logouts the current environment."

    for env in $DO_ENVS; do 
        echo "
  do-env-login-${env}:
    Logins to the ${env} environment."
    done

}

# Logins the specified environment.
# Arguments:
#  1. env: Required. The environment name. This must be one specified in DO_ENVS array.
#
function _do_env_login() {
    local env=${1?'env arg required'}
    _do_log_debug "env" "Logins ${env} environment."

    if [ "${env}" = "${DO_ENV}" ]; then 
        _do_log_warn "env" "Already in ${env}."
        return 
    fi

    # Changes the active environment to the new one.
    DO_ENV="${env}"
}


# Logout of the current environment.
# Arguments: None.
#
function _do_env_logout() {
    _do_log_debug "env" "Logout ${DO_ENV} environment."

    _do_hook_call "_do_env_logout" "${DO_ENV}"

    # Resets the environment to the default one.
    DO_ENV=""
}
