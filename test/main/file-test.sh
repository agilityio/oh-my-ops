function test_file_name() {
    _do_assert_eq "README.md" "$(_do_file_name 'README.md')"
    _do_assert_eq "README.md" "$(_do_file_name './README.md')"
    _do_assert_eq "README.md" "$(_do_file_name '/somedir/README.md')"
    _do_assert_eq "README.md.bak" "$(_do_file_name '/somedir/README.md.bak')"
}

function test_file_name_without_ext() {
    _do_assert_eq "README" "$(_do_file_name_without_ext 'README.md')"
    _do_assert_eq "README" "$(_do_file_name_without_ext 'README.md.bak')"
}

function test_file_ext() {
    _do_assert_eq "md" "$(_do_file_ext 'README.md')"
    _do_assert_eq "md.bak" "$(_do_file_ext 'README.md.bak')"
}

function test_file_scan() {
    local files=( $(_do_file_scan "${DO_HOME}" '*.sh') )
    [ ${#files[@]} -gt 1 ] || _do_assert_fail
}
