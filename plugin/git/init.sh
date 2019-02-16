_do_plugin "repo"

_do_log_level_debug "git"

_do_src_include_others_same_dir

# ==============================================================================
# Proj plugin integration
# ==============================================================================

# The array of all plugin repo comamnds.
_DO_GIT_REPO_CMDS=( "help" "status" "add" )


# Runs git status on the specified repository.
# Arguments: 
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_status() {
    _do_repo_cmd $@ "git status"
}

# Runs 'git add .' on the specified directory.
# Arguments: 
#   1.proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_add() {
    _do_repo_cmd $@ "git add ."
}


# ==============================================================================
# Proj plugin integration
# ==============================================================================

# Determines if the specified directory has git enabled.
# Arguments:
#   1. dir: A directory.
# 
# Returns: 
#   0 if git enabled, 1 otherwise.
#
function _do_git_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if [ -d "$proj_dir/$repo/.git" ]; then 
        return 0
    else 
        # Git is enabled for the specified directory
        return 1
    fi 
}


# Initializes git support for a repository.
#
function _do_git_repo_init() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    if ! _do_git_repo_enabled ${proj_dir} ${repo}; then 
        _do_log_debug "git" "Skips git support for '$repo'"
        # This directory does not have git support.
        return
    fi 

    # Sets up the alias for showing the repo git status
    _do_log_debug "git" "Initialize git for '$repo'"

    # Register hooks for command repo life cycle command.
    _do_repo_plugin "${proj_dir}" "${repo}" "git" _DO_GIT_REPO_CMDS 

    _do_git_repo_branch_init $proj_dir $repo
    _do_git_repo_remote_init $proj_dir $repo
}


function _do_git_repo_help() {
    local proj_dir=$1
    local repo=$2

    echo "  
  ${repo}-git-help: 
    See git command helps

  ${repo}-git-status: 
    See the repository git status
        
  ${repo}-git-add:
    Stage all modified file."
}


# ==============================================================================
# Plugin Init
# ==============================================================================

function _do_git_plugin_init() {
    _do_log_info "git" "Initialize plugin"
}


# Listens to init proj repo hook.
_do_proj_plugin "git"
