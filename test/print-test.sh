function test_do_print_line() {
    _do_print_line_1
    _do_print_line_1 "Single line"

    _do_print_line_2
    _do_print_line_2 "Double line"

    # Test the long display
    local line=$(printf '%0.1s' "?"{1..79})   
    _do_print_line_1 "Super long ${line}"
}
