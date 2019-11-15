function _do_docker_compose() {
    local repo=${1?'repo arg required'}
    shift 1

    _do_repo_plugin_cmd_add "${repo}" 'docker-compose' 'doctor' 'start' 'stop' 'build' $@
}

