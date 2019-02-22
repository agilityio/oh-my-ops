
# Determines if the specified directory has go enabled.
# Arguments:
#   1. dir: A directory.
# 
# Returns: 
#   0 if go enabled, 1 otherwise.
#
function _do_go_repo_dep_enabled() {
    local proj_dir=$1
    local repo=$2

    # On the first dep package found, return right away.
    local packages=$(_do_go_repo_dep_package_list $proj_dir $repo)
    if [ ${#packages[@]} -gt 0 ]; then 
        # go dep is enabled
        return 0
    else 
        return 1
    fi
}

function _do_go_repo_dep_package_cmd() {
    _do_log_debug "go" "_do_go_repo_dep_package_cmd $@"
    local proj_dir=$(_do_arg_required $1)
    shift 

    local repo=$(_do_arg_required $1)
    shift 

    local package=$(_do_arg_required $1)
    shift

    _do_dir_push "${proj_dir}/${repo}/src/${package}"
    
    $@
    _do_dir_pop
}

function _do_go_repo_dep_package_install() {
    _do_go_repo_dep_package_cmd $@ "dep ensure --update"
}


# Lists out the names of all repo dep packages found.
#
function _do_go_repo_dep_package_list() {
    local proj_dir=$1
    local repo=$2
    _do_go_repo_dep_package_walk $proj_dir $repo "echo"
}


# Walks through all go package found in the current repositories.
#   
function _do_go_repo_dep_package_walk() {
    _do_log_debug "go" "_do_go_repo_dep_package_walk $@"

    local proj_dir=$(_do_arg_required $1)
    shift 

    local repo=$(_do_arg_required $1)
    shift

    # Looks for all 
    local src_dir="$proj_dir/$repo/src"
    _do_dir_assert $src_dir

    _do_dir_push $src_dir

    local dir 
    for dir in $(find * -maxdepth 0 -type d); do 
        if [ -f "$dir/Gopkg.toml" ]; then 
            eval $@ $dir
            local err=$?
            if _do_error $err; then 
                # stops 
                return $err 
            fi
        fi
    done
    _do_dir_pop
}
