# Provides utils for different plugins to register custom handlers
# to hooks. For instance,for the public "do-docker-stop-all" command, 
# mongo plugin might want to register a listener that will terminate
# the mongo daemon process.
#
# See: https://www.artificialworlds.net/blog/2012/10/17/bash-associative-array-examples/

_do_log_level_warn "hook"


# Declares an associate array (or map)
declare -A _do_hook_map


# Adds the specified function to the hook.
# Arguments:
#   1. hook: The hook name, returned by _do_hook_declare function.
#
# Notes that the function list is delimited by comma.
#
function _do_hook_before() {
    local hook=$1
    local func=$2

    if _do_hook_exist "$hook" "$func"; then
        return
    fi

    _do_log_debug "hook" "Register $func before $hook"

    local funcs=${_do_hook_map[$hook]}
    if [ ! -z "$funcs" ]; then
        func=",${funcs}"
    fi
    _do_hook_map[$hook]="$func$funcs"
}


# Adds the specified function to the hook.
# Arguments:
#   1. hook: The hook name, returned by _do_hook_declare function.
#
# Notes that the function list is delimited by comma.
#
function _do_hook_after() {
    local hook=$1
    local func=$2

    if _do_hook_exist "$hook" "$func"; then
        _do_log_debug "hook" "$func is already registered in $hook"
        return
    fi

    _do_log_debug "hook" "Register '$func' after '$hook' hook"

    local funcs=${_do_hook_map[$hook]}
    if [ -z "$funcs" ]; then
        funcs=""
    else
        funcs="${funcs},"
    fi

    _do_hook_map[$hook]="$funcs$func"
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
    for i in $(echo "$funcs" | sed 's/,/ /g'); do
        if [ "$i" = "$func" ]; then
            # The hook is found
            return 0
        fi
    done

    # The hook is not found.
    return 1
}


# Trigers all registered function for the specified hook
# and list of argument.s
# Arguments:
#   1. hook: The hook name, returned by _do_hook_declare function.
#   2,3,4 ....: The arguments that will be passed to all registered function.
#
function _do_hook_call() {
    local hook=$1

    _do_log_debug "hook" "_do_hook_call $hook"

    # Removes the first argument to the argument list.
    shift

    # Triggers all registered functions with the specified
    # argument list.
    local funcs=${_do_hook_map[$hook]}

    for func in $(echo "$funcs" | sed 's/,/ /g'); do
        _do_log_debug "hook" "Call $func"

        ${func} "$@"
    done
}
