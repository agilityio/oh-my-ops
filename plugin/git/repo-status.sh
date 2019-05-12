_do_log_level_warn "git"


# Runs git status on the specified repository.
# Arguments: 
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_status() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}    

    _do_repo_cmd $proj_dir $repo "git status"
}

