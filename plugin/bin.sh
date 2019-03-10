_do_plugin "proj"

# Docker Supports
_do_log_level_debug "bin"


# ==============================================================================
# Proj plugin integration
# ==============================================================================


# If the specified repository has a directory "bin", bin is enabled for 
# the repository. 
#
function _do_bin_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if [ -d "${proj_dir}/${repo}/bin" ]; then 
        # Docker integration is enabled for this repository.
        return 0
    else
        return 1
    fi
}
 
# Initializes bin support for a repository.
#
function _do_bin_repo_init() {
    local proj_dir=$1
    local repo=$2

    if ! _do_bin_repo_enabled "${proj_dir}" "${repo}"; then 
        return
    fi

    _do_log_debug "bin" "Initializes bin integration for $repo"

    _do_dir_push $proj_dir/$repo/bin

    local name
    for name in $(ls -A ); do
        _do_log_debug "bin" "  $repo/$name"

        if [ -f "./$name" ] && [[ -x "./$name" ]]; then 
            # removes the .sh extension from the file if any.
            # replace all weird characters to make it an alias friendly.
            # Example: 
            #   for bin/run_something.hello.sh 
            #   the cmd will be "bin-run-something-hello"
            #
            local cmd=$(echo $name | sed -e 's/\.sh$//g' -e 's/[[:blank:]]/_/g' -e 's/[\/_\.]/-/g')
            local repo_alias="${repo}-bin-${cmd}"

            _do_repo_alias_add $proj_dir $repo "bin" "${cmd}"
            alias "${repo_alias}"="_do_bin_repo_cmd ${proj_dir} ${repo} ${name}"
        fi
    done
    _do_dir_pop

    _do_repo_alias_add $proj_dir $repo "bin" "help"
}


# Displays helps for bin supports.
#
function _do_bin_repo_help() {
    local proj_dir=$1
    local repo=$2

    echo "  ${repo}-bin-help: See bin command helps"
}


# Runs any go command in docker.
# Arguments:
#   1. repo: The repository name.
#
function _do_bin_repo_cmd() {
    local proj_dir=$1
    shift

    local repo=$1
    shift

    local file=$1
    shift

    _do_repo_dir_push $proj_dir $repo

    _do_print_line_1 "bin/$file $@"

    bin/$file $@

    _do_dir_pop
    return $?
}
# ==============================================================================
# Plugin Init
# ==============================================================================
function _do_bin_plugin_init() {
    _do_log_info "bin" "Initialize plugin"
    _do_repo_cmd_hook_add "bin" "init help"
}
