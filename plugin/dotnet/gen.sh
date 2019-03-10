_do_log_level_warn "dotnet"


# Listens to the _do_repo_gen hook and generates dotnet support.
#
function _do_dotnet_repo_gen() {
    local proj_dir=$(_do_arg_required $1)

    local repo=$(_do_arg_required $2)
        
    _do_print_line_1 "Generates dotnet support"

    local repo_dir="${proj_dir}/${repo}"
    local package_dir="${repo_dir}/src/${repo}"
    mkdir -p ${package_dir} &> /dev/null

   
    local prev_dotnet_path=${DOTNETPATH}
    export DOTNETPATH=${repo_dir}

    _do_dir_push "${package_dir}"
    dep init
    _do_dir_pop

    local err=$?
    export DOTNETPATH=${prev_dotnet_path}

    return $err
}
