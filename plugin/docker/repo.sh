function _do_docker() {
    local repo=${1?'repo arg required'}
    shift 1

    _do_repo_plugin_cmd_add "${repo}" 'docker' 'doctor' 'clean' 'build' $@
}
