function _do_full_repo_add() {
    local repo=${1?'repo arg required'}
    shift 1

    _do_repo_plugin_cmd_add "${repo}" 'full' 'help' 'clean' 'install' 'build' 'test' 'package' 'deploy'

    if [[ $# -gt 0 ]]; then 
        _do_repo_plugin_cmd_add "${repo}" 'full' $@
    fi
}
