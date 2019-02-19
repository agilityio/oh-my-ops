function _do_error() {
    local err="$1"

    if [ -z "$err" ] || [ "$err" = "0" ]; then 
        # No error found
        return 1
    else 
        # True, error found.
        return 0
    fi 
}


function _do_error_report() {
    local err=$1
    local msg=${2:-}

    if _do_error $1; then 
        _do_print_error $msg

    else 
        _do_print_finished $msg
    fi
}
