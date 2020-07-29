# Provides utils for different plugins to register custom handlers
# to hooks. For instance,for the public "do-docker-stop-all" command,
# mongo plugin might want to register a listener that will terminate
# the mongo daemon process.
#
# See: https://www.artificialworlds.net/blog/2012/10/17/bash-associative-array-examples/

_do_log_level_warn 'hook'

# Declares an associate array (or map)
declare -A _do_hook_map

# Adds the specified function to the hook.
# Arguments:
#   1. hook: The hook name, returned by _do_hook_declare function.
#
# Notes that the function list is delimited by comma.
#
function _do_hook_before() {
  local hook=${1?'hook arg required'}
  local func=${2?'func arg required'}

  if _do_hook_exist "${hook}" "${func}"; then
    return
  fi

  _do_log_debug 'hook' "Register ${func} before ${hook}"

  local funcs=${_do_hook_map[$hook]}
  if [ -z "$funcs" ]; then
    funcs=":"
  fi
  _do_hook_map[$hook]=":${func}${funcs}"
}


# Adds the specified function to the hook.
# Arguments:
#   1. hook: The hook name, returned by _do_hook_declare function.
#
# Notes that the function list is delimited by comma.
#
function _do_hook_after() {
  local hook=${1?'hook arg required'}
  local func=${2?'func arg required'}

  if _do_hook_exist "${hook}" "${func}"; then
    _do_log_debug "hook" "$func is already registered in $hook"
    return
  fi

  _do_log_debug "hook" "Register '$func' after '$hook' hook"

  local funcs=${_do_hook_map[$hook]}
  if [ -z "$funcs" ]; then
    funcs=":"
  fi

  _do_hook_map[$hook]="${funcs}${func}:"
}

# Short-hand for _do_hook_after
function _do_hook() {
  # shellcheck disable=SC2068
  _do_hook_after $@
}

# Determines if the specified function is already registered with the hook.
# Arguments:
#   1. hook: The hook name.
#   2. func: The function name.
# Returns:
#   0 if function is already registered. Otherwise, 1.
#
function _do_hook_exist() {
  local hook=$1
  local func=$2

  local funcs=${_do_hook_map[$hook]}
  for i in ${funcs//:/ }; do
    if [ "$i" = "$func" ]; then
      # The hook is found
      return 0
    fi
  done

  # The hook is not found.
  return 1
}

# Removes a function from a hook, if that exists.
# Arguments:
#   1. hook: The hook name.
#   2. func: The function name.
#
function _do_hook_remove() {
  local hook=$1
  local func=$2

  local funcs=${_do_hook_map[$hook]}

  funcs=${funcs//:${func}:/:}
  _do_hook_map[${hook}]="${funcs}"
}

# Removes all functions starting with a prefix from a hook
# Arguments:
#   1. hook: The hook name.
#   2. prefix: The prefix to search for
#
function _do_hook_remove_by_prefix() {
  local hook=$1
  local prefix=$2

  local funcs=${_do_hook_map[$hook]}

  funcs=${funcs//:${prefix}[^:]*:/:}
  _do_hook_map[${hook}]="${funcs}"
}

# Trigers all registered function for the specified hook
# and list of argument.s
# Arguments:
#   1. hook: The hook name, returned by _do_hook_declare function.
#   2,3,4 ....: The arguments that will be passed to all registered function.
#
function _do_hook_call() {
  local hook=$1

  # Removes the first argument to the argument list.
  shift
  local args=( "$@" )

  _do_log_debug "hook" "_do_hook_call $hook"

  # Triggers all registered functions with the specified
  # argument list.
  local funcs=${_do_hook_map[$hook]}

  for func in ${funcs//:/ }; do
    _do_log_debug "hook" "Call $func" "${args[@]}"

    ${func} ${args[@]}
  done
}
