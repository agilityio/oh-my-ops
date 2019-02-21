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


function _do_error_report_line() {
    local err=$1
    shift

    local msg=$1
    shift

    local line=$(printf '%0.1s' "."{1..75})   

    local pad=${line:${#msg}}
    local color
    local char

    if _do_error $err; then 
        char="F"
        color=${FG_RED}
    else 
        char="P"
        color=${FG_GREEN}
    fi

    printf "${color}%s${FG_NORMAL} ${TX_DIM}%s${FG_NORMAL}[${color}${char}${FG_NORMAL}]\n" "$msg" "${pad}"
}
