function _do_docker_compose_repo_cmd() {
    local err=0
    local dir=${1?'dir arg is required'}
    local repo=${2?'repo arg required'}
    local cmd=${3?'arg command is required'}
    shift 3

    local run="docker-compose ${cmd}"

    _do_dir_push "${dir}" || return 1

    {
        { 
            case "${cmd}" in 
            start)
                run="docker-compose up"
                ;;
            stop)
                run="docker-compose down"
                ;;
            build)
                run="docker-compose build --no-cache"
                ;;
            esac
        } &&
        ${run} $@
    } || {
        err=1
    }

    _do_dir_pop

    return ${err}
}
