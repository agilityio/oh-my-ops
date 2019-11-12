function test_do_error_report_line() {
    _do_error_report_line "0"
    _do_error_report_line "1"
    _do_error_report_line "0" "Single line"
    _do_error_report_line "1" "Single line"

    _do_error_report_line 0
    _do_error_report_line 1
    _do_error_report_line 0 "Double line"
    _do_error_report_line 1 "Double line"

    # Test the long display
    local line=$(printf '%0.1s' "?"{1..79})   
    _do_error_report_line 0 "Super long ${line}"
    _do_error_report_line 1 "Super long ${line}"
}
