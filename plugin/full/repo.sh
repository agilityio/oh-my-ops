function _do_full() {
    local repo=${1?'repo arg required'}
    shift 1

    _do_repo_plugin_cmd_add ${repo} 'full' ${DO_FULL_BASE_CMDS} $@
}


function _do_full_api() {
    local repo=${1?'repo arg required'}
    shift 1

    _do_repo_plugin_cmd_add ${repo} 'full' ${DO_FULL_API_CMDS} $@
}


function _do_full_web() {
    local repo=${1?'repo arg required'}
    shift 1

    _do_repo_plugin_cmd_add ${repo} 'full' ${DO_FULL_WEB_APP_CMDS} $@
}


function _do_full_mobile() {
    local repo=${1?'repo arg required'}
    shift 1

    _do_repo_plugin_cmd_add ${repo} 'full' ${DO_FULL_MOBILE_APP_CMDS} $@
}


function _do_full_proj() {
    local repo=${1?'repo arg required'}
    shift 1

    _do_repo_plugin_cmd_add ${repo} 'full' ${DO_FULL_PROJ_CMDS} $@
}
