_do_plugin "proj"

# Docker Supports
_do_log_level_warn "bin"


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

    _do_repo_alias_add $proj_dir $repo "bin" "help"
}


# Displays helps for bin supports.
#
function _do_bin_repo_help() {
    local proj_dir=$1
    local repo=$2

    echo "  ${repo}-bin-help: See bin command helps"
}

# ==============================================================================
# Plugin Init
# ==============================================================================
function _do_bin_plugin_init() {
    _do_log_info "bin" "Initialize plugin"
    _do_repo_cmd_hook_add "bin" "init help"
}
