function test_help() {
    _do_env_help
}

function test_env() {
    _do_env_login "local"
    _do_env_login "local"

    _do_env_is_local || _do_assert_fail
    ! _do_env_is_prod || _do_assert_fail

    _do_env_login "dev"
    _do_env_help

    ! _do_env_is_local || _do_assert_fail
    ! _do_env_is_prod || _do_assert_fail

    _do_env_login "prod"
    _do_env_help

    ! _do_env_is_local || _do_assert_fail
    _do_env_is_prod || _do_assert_fail

    _do_env_logout
}