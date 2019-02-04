
function _do_error() {
    local err="$1"

    if [ -z "$err"] || [ "$err" = "0" ]; then 
        # No error found
        return 1
    else 
        # True, error found.
        return 0
    fi 
}
