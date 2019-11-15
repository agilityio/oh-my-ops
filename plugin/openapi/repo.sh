function _do_openapi_dart_client() {
    local repo=${1?'repo arg required'}
    local config_file=${2:-}
    local schema_file=${3:-}
    shift 3

    _do_repo_plugin_cmd_add "${repo}" 'openapi' 'build-dart-client'
    _do_repo_plugin_cmd_opts "${repo}" 'openapi' 'build-dart-client' "${config_file}" "${schema_file}"
}
