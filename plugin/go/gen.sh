_do_log_level_warn "go"


# Listens to the _do_repo_gen hook and generates go support.
#
function _do_go_repo_gen() {
    local proj_dir=${1?'proj_dir arg required'}

    local repo=${2?'repo arg required'}
        
    _do_print_line_1 "Generates go support"

    local repo_dir="${proj_dir}/${repo}"
    local package_dir="${repo_dir}/src/${repo}"
    mkdir -p ${package_dir} &> /dev/null

   
    local prev_go_path=${GOPATH}
    export GOPATH=${repo_dir}

    _do_dir_push "${package_dir}"
    dep init
    _do_dir_pop

    local err=$?
    export GOPATH=${prev_go_path}

    return $err
}
