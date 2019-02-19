# Unit testing plugin

function _do_assert_fail() {
    local msg=${1:-}

    if [ -z "${msg}" ]; then 
        msg="Failed"
    fi

    printf "${FG_CYAN}${msg}${FG_NORMAL}\n" >&2
    _do_assert_stack_trace
    exit 1
}


function _do_assert() {
    local actual=$1
    local msg=${2:-}

    if [ -z "$actual" ]; then 
        if [ ! -z "$msg" ]; then 
            printf "${FG_CYAN}${msg}.${FG_NORMAL} " >&2
        fi

        printf "Expected not empty.\n" >&2
        _do_assert_stack_trace
        exit 1
    fi 
}


function _do_assert_eq() {
    local expected=$1
    local actual=$2
    local msg=${3:-}

    if [ "$expected" != "$actual" ]; then 
        if [ ! -z "$msg" ]; then 
            printf "${FG_CYAN}${msg}.${FG_NORMAL} " >&2
        fi

        printf "Expected ${FG_YELLOW}[$expected]${TX_NORMAL} but was ${FG_RED}[$actual]${TX_NORMAL}\n" >&2
        _do_assert_stack_trace
        exit 1
    fi 
}


function _do_assert_neq() {
    local expected=$1
    local actual=$2
    local msg=${3:-}

    if [ "$expected" == "$actual" ]; then 
        if [ ! -z "$msg" ]; then 
            printf "${FG_CYAN}${msg}.${FG_NORMAL} " >&2
        fi

        printf "Expected not ${FG_RED}[$actual]${TX_NORMAL}\n" >&2
        _do_assert_stack_trace
        exit 1
    fi
}


# Prints out assert failed stack trace.
#
function _do_assert_stack_trace() {
    # Print out stack trace.
    printf "${TX_DIM}" >&2
    local i=
    while ! [ -z "${BASH_SOURCE[$i]:-}" ]
    do
        local src="${BASH_SOURCE[$i]}"
        local func="${FUNCNAME[$i]}"
        local lineno="${BASH_LINENO[$((i-1))]}"
        if ! [[ "$func" =~ "_do_assert_" ]]; then 
            echo "    ${src}:${lineno}:${func}()" >&2
        fi
        i=$((i + 1))
    done | grep -v "^$BASH_SOURCE"
    printf "${TX_NORMAL}" >&2

}
