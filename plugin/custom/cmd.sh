function _do_custom_repo_cmd() {
    local err=0
    local dir=${1?'dir arg required'}
    local repo=${2?'repo arg required'}
    local cmd=${3?'cmd arg required'}

    local repo_u=$(_do_string_to_undercase "${repo}")
    local cmd_u=$(_do_string_to_undercase "${cmd}")

    local handler="_do_${repo_u}_custom_${cmd_u}"
    _do_print_warn "Please implement 'function ${handler}()'."
    return 1
}
