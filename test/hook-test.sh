before_called="0"
after_called="0"
call_count="0"

function before_hello_world() {
    echo "Before hello_world"
    let call_count+=1
    before_called="${call_count}"
}

function after_hello_world() {
    echo "After hello_world"
    let call_count+=1
    after_called="${call_count}"
}

function test_hook() {
    # Just call an empty hook. Should work.
    _do_hook_call "hello_world" || _do_assert_fail

    # Makes sure hook after work.
    ! _do_hook_exist "hello_world" "after_hello_world" ||  _do_assert_fail
    _do_hook_after "hello_world" "after_hello_world" ||  _do_assert_fail
    _do_hook_exist "hello_world" "after_hello_world" ||  _do_assert_fail

    # Makes sure hook before work.
    ! _do_hook_exist "hello_world" "before_hello_world" ||  _do_assert_fail
    _do_hook_before "hello_world" "before_hello_world" || _do_assert_fail
    _do_hook_exist "hello_world" "before_hello_world" ||  _do_assert_fail

    _do_hook_call "hello_world" || _do_assert_fail

    # Makes sure hook before is called before hook after.
    [ "${before_called}" == "1" ] && [ "${after_called}" == "2" ] || _do_assert_fail

    # Removes before hook and try to trigger again.
    # The after hook is still there
    _do_hook_remove "hello_world" "before_hello_world" || _do_assert_fail
    ! _do_hook_exist "hello_world" "before_hello_world" ||  _do_assert_fail

    before_called="0"
    after_called="0"
    call_count="0"
    _do_hook_call "hello_world" || _do_assert_fail
    [ "${before_called}" == "0" ] && [ "${after_called}" == "1" ] || _do_assert_fail


    # Removes after hook and try to trigger again.
    _do_hook_remove_by_prefix "hello_world" "after_" || _do_assert_fail
    ! _do_hook_exist "hello_world" "after_hello_world" ||  _do_assert_fail

    before_called="0"
    after_called="0"
    call_count="0"
    _do_hook_call "hello_world" || _do_assert_fail
    [ "${before_called}" == "0" ] && [ "${after_called}" == "0" ] || _do_assert_fail
}
