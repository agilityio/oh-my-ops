function test_setup() {
    _do_env_logout
}

function test_help() {
    _do_env_help
}

function test_env() {
    _do_env_login "local"
    _do_env_login "local"

    _do_env_login "dev"
    _do_env_help

    _do_env_logout
}