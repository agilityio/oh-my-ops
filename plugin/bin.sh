_do_plugin "proj"

# Docker Supports
_do_log_level_warn "bin"

# The array of all plugin repo comamnds.
_DO_BIN_REPO_CMDS=( "help" )


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

    # Registers tmux command such as 'repo-tmux-start', etc.
    _do_repo_plugin "${proj_dir}" "${repo}" "bin" _DO_BIN_REPO_CMDS 
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
   
    # Listens to init proj repo hook.
    _do_proj_plugin "bin"
}
