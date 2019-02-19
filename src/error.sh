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
    shift

    if _do_error $err; then 
        _do_print_error "ERROR!" $@

    else 
        _do_print_finished "SUCCESS!" $@
    fi
}
