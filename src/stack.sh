# Create a new stack.
#
# Arguments:
#   1. name: The stack variable to be set.
#
function _do_stack_new() {
    local name=${1?'Stack name required'}

    if _do_stack_exists "${name}"; then
        echo "Stack already exists -- ${name}" >&2
        return 1
    fi

    declare -ag "__do_stack_${name}"
    declare -ig "__do_stack_${name}_i"
    let "__do_stack_${name}_i"=0

    return 0
}


# Destroy a stack
#
# Arguments:
#   1. stack_name: The stack variable to destroy.
#
function _do_stack_destroy() {
    local name=${1?'Stack name required'}
    unset "__do_stack_${name}" "__do_stack_${name}_i"
    return 0
}

# Push one or more items onto a stack.
#
# Arguments:
#   1. stack_name: The stack name
#   ... values: One value or more to push to the stack.
#
function _do_stack_push() {
    local name=${1?'Stack name required'}
    shift 1

    : "${1?'Missing item(s) to push'}"

    if ! _do_stack_exists "${name}"; then
        echo "'${name}' stack not found'" >&2
        return 1
    fi


    # Reads all remaining values and push to stack
    while (( $# > 0 )); do
        eval '_i=$'"__do_stack_${name}_i"
        eval "__do_stack_${name}[$_i]='$1'"
        eval "let __do_stack_${name}_i+=1"
        shift 1
    done

    unset _i
    return 0
}


# Print a stack to stdout.
# Arguments:
#   1. The stack name.
#
function _do_stack_print() {
    local name=${1?'Stack name required'}

    if ! _do_stack_exists ${name}; then
        echo "'${name}' stack not found" >&2
        return 1
    fi

    local tmp=""
    eval 'let _i=$'__do_stack_${name}_i
    while (( $_i > 0 ))
    do
        let _i=${_i}-1
        eval 'e=$'"{__do_stack_${name}[$_i]}"
        tmp="$tmp $e"
    done
    echo "(" $tmp ")"
}

# Get the size of a stack
#
# Arguments:
#   1. The stack name.
#   2. The variable name to contains the size.
#
function _do_stack_size
{
    local name=${1?'Stack name required'}
    local var=${2?'Missing name of variable for stack size result'}
    if ! _do_stack_exists "${name}"; then
        echo "'${name}' stack not found'" >&2
        return 1
    fi

    eval "$var"='$'"{#__do_stack_${name}[*]}"
}


# Pop the top element from the stack.
#
# Arguments:
#   1. The stack name.
#   2. The variable name to keep the result.
#
function _do_stack_pop {
    local name=${1?'Stack name required'}
    local var=${2?'Missing name of variable for popped result'}

    eval 'let _i=$'"__do_stack_${name}_i"
    if ! _do_stack_exists "${name}"; then
        echo "'$1' stack is empty" >&2
        return 1
    fi

    if [[ "$_i" -eq 0 ]]
    then
        echo "Empty stack -- $1" >&2
        return 1
    fi

    (( _i-- ))

    eval "${var}"='$'"{__do_stack_${name}[$_i]}"
    eval "unset __do_stack_${name}[$_i]"
    eval "__do_stack_${name}_i=$_i"
    unset _i
    return 0
}

# Checks if a stack exists.
#
# Arguments:
#   1. The stack name.
# Returns:
#   0 if the stack exists; Otherwise, 1.
#
function _do_stack_exists() {
    local name=${1?'Stack name required'}

    eval '_i=$'"__do_stack_${name}_i"
    if [[ -z "$_i" ]]
    then
        return 1
    else
        return 0
    fi
}
