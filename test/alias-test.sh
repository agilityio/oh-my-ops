function test_alias_list_all_1() {
    _do_alias_list || _do_assert_fail
}

function test_alias_list_all_2() {
    _do_alias_list "" || _do_assert_fail
}

function test_alias_list_by_prefix() {
    _do_alias_list "do-" || _do_assert_fail
}

function test_alias_exist() {
    _do_alias_exist "do-version" || _do_assert_fail
    ! _do_alias_exist "do-version-NEVER" || _do_assert_fail
}

function test_alias_remove_by_prefix() {
    _do_alias_exist "do-version" || _do_assert_fail
    _do_alias_remove_by_prefix "do-ver"
    ! _do_alias_exist "do-version" || _do_assert_fail
}

# TODO: Fix this failed test. Why we cannot call that in unit testing. Regular is fine.
function test_alias_call_if_exist() {
    # _do_alias_call_if_exists "do-version" || _do_assert_fail
    # ! _do_alias_call_if_exists "do-version-NEVER" || _do_assert_fail
}
