function _do_openapi_dart_client() {
    local repo=${1?'repo arg required'}
    local config_file=${2:-}
    local schema_file=${3:-}
    shift 3

    _do_repo_plugin_cmd_add "${repo}" 'openapi' 'generate'
    _do_repo_plugin_cmd_opts "${repo}" 'openapi' 'generate' 'dart '"${config_file}" "${schema_file}"
}


function _do_openapi_angular_client() {
    local repo=${1?'repo arg required'}
    local config_file=${2:-}
    local schema_file=${3:-}
    shift 3

    _do_repo_plugin_cmd_add "${repo}" 'openapi' 'generate'
    _do_repo_plugin_cmd_opts "${repo}" 'openapi' 'generate' 'typescript-angular '"${config_file}" "${schema_file}"
}
