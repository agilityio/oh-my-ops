# Runs 'git add .' on the specified directory.
# Arguments:
#   1.proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_add() {
  _do_repo_cmd $@ "git add ."
  _do_repo_cmd $@ "git status"
}

# Determines if the specified directory has git enabled.
# Arguments:
#   1. dir: A directory.
#
# Returns:
#   0 if git enabled, 1 otherwise.
#
function _do_git_repo_enabled() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  if [ -d "${proj_dir}/${repo}/.git" ]; then
    return 0
  else
    # Git is not enabled for the specified directory
    return 1
  fi
}

# Initializes git support for a repository.
#
function _do_git_repo_init() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  if ! _do_git_repo_enabled ${proj_dir} ${repo}; then
    _do_log_debug "git" "Skips git support for '$repo'"
    # This directory does not have git support.
    return
  fi

  # Sets up the alias for showing the repo git status
  _do_log_info "git" "Initialize git for '$repo'"
  _do_repo_cmd_hook_add "${repo}" "git" "help gen clone status"

  # Register hooks for command repo life cycle command.
  _do_repo_alias_add $proj_dir $repo "git" "help status add commit"

  _do_git_repo_branch_init $proj_dir $repo
  _do_git_repo_remote_init $proj_dir $repo
}

function _do_git_repo_help() {
  local proj_dir=$1
  local repo=$2
  local mode=$3

  if ! _do_git_repo_enabled $proj_dir $repo; then
    return
  fi

  if [ "${mode}" = "--short" ]; then
    echo "
  do-${repo}-git-help:
    See git command helps"
    return
  fi

  _do_print_header_2 "$repo: git help"

  _do_print_line_1 "repository's commands"

  echo "
  do-${repo}-git-help:
    See this help.

  do-${repo}-git-status:
    See the repository git status.

  do-${repo}-git-add:
    Stage all modified file.

  do-${repo}-git-commit <message>:
    Git commit all changes with the specifed commit message.
"

  _do_print_line_1 "global commands"

  echo "
  do-all-git-status:
    See git status for all repositories.

  do-all-git-add:
    Git add changes for all repositories.

  do-all-git-commit <message>:
    Git commit changes for all repositories with the specified commit message.
"
}
