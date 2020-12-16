_do_log_level_warn "env"

# The current working environment.
DO_ENV=""

# This is the default local environment
DO_ENV_LOCAL="local"

# This is the default production environment
DO_ENV_PROD="prod"

_DO_ENV_CMDS=("help" "logout")

# ==============================================================================
# Plugin Init
# ==============================================================================

# Initializes env plugin.
# Arguments: None.
#
function _do_env_plugin_init() {
  _do_log_info "env" "Initialize plugin"

  if ! _do_env_exists "${DO_ENV_LOCAL}"; then
    DO_ENVS+=" ${DO_ENV_LOCAL}"
  fi

  _do_plugin_cmd "env" _DO_ENV_CMDS

  # Registers aliases for all environments
  for env in $DO_ENVS; do
    _do_alias "do-env-login-${env}" "_do_env_login ${env}"
  done

  # Logins into the default local environment
  _do_env_login "${DO_ENV_LOCAL}"
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
  local name=${1?'name arg required'}

  if [ "${name}" = "${DO_ENV}" ]; then
    _do_log_warn "env" "Already in ${name}."
    return
  fi

  _do_env_exists_assert "${name}"
  _do_log_debug "env" "Logins ${env} environment."

  # Changes the active environment to the new one.
  DO_ENV="${env}"

  # Updates the environment color
  if _do_env_is_local; then
    _DO_FG_ENVIRONMENT=${_DO_FG_GREEN}

  elif _do_env_is_prod; then
    _DO_FG_ENVIRONMENT=${_DO_FG_RED}

  else
    _DO_FG_ENVIRONMENT=${_DO_FG_YELLOW}
  fi

  _do_hook_call "_do_env_login" "${DO_ENV}"
}

# Logout of the current environment.
# Arguments: None.
#
function _do_env_logout() {
  if [ "${DO_ENV}" == "${DO_ENV_LOCAL}" ]; then
    _do_log_warn "env" "Already at the default ${DO_ENV_LOCAL} environment."
    return
  fi

  _do_log_debug "env" "Logout ${DO_ENV} environment."

  # Resets the environment to the default one.
  _do_env_login "${DO_ENV_LOCAL}"
}

# Determines if the current environment is local or not.
# Returns:
#  0. if the environment is local; 1 otherwise.
#
function _do_env_is_local() {
  if [ "${DO_ENV}" == "${DO_ENV_LOCAL}" ]; then
    return 0
  else
    return 1
  fi
}

# Determines if the current environment is production or not.
# Returns:
#  0. if the environment is local; 1 otherwise.
#
function _do_env_is_prod() {
  if [ "${DO_ENV}" == "${DO_ENV_PROD}" ]; then
    return 0
  else
    return 1
  fi
}

# Determines if the specified environment exists or not.
#
# Returns:
#  0. if the environment exists; 1 otherwise.
#
function _do_env_exists() {
  local name=${1?'name arg required'}

  # Makes sure the "local" environment is specified in the environment list.
  for env in $DO_ENVS; do
    if [ "${env}" == "${name}" ]; then
      return 0
    fi
  done

  return 1
}

function _do_env_exists_assert() {
  local name=${1?'name arg required'}
  _do_env_exists "${name}" || _do_assert_fail "${name} environment does not exist."
}
