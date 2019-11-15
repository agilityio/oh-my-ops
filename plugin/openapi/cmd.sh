function _do_openapi_repo_cmd() {
    local err=0
    local dir=${1?'dir arg required'}
    local repo=${2?'repo arg required'}
    local cmd=${3?'cmd arg required'}

    shift 3

    _do_dir_push "${dir}" || return 1

    local lang=''
    local out_dir='.'
    local config_file
    local schema_file

    {
        { 
            case "${cmd}" in 
            build-dart-client)
                lang='dart'
                config_file=${1:-}
                schema_file=${2:-}
                shift 2

                if [ -z "${config_file}" ]; then 
                    config_file="${DO_OPENAPI_CONFIG_FILE}"
                fi

                if [ -z "${schema_file}" ]; then 
                    schema_file="${DO_OPENAPI_SCHEMA_FILE}"
                fi
                ;;
            *)
                _do_assert_fail "Not supported openapi command: ${cmd}"
                ;;
            esac
        } &&
        openapi-generator generate \
            -g "${lang}" -c "${config_file}" \
            -i "${schema_file}" -o ${out_dir}
    } || {
        err=1
    }

    _do_dir_pop

    return ${err}
}
