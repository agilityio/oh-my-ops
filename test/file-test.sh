function test_file() {
    _do_assert_eq "README.md" "$(_do_file_name '/somedir/README.md')"
}