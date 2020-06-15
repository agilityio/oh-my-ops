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

# Checks if the given git repository is up to date or not.
#
function _do_git_repo_is_up_to_date() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  _do_repo_dir_push $proj_dir $repo

  local err=0
  local text=$(git status)
  if [[ ${text} == *"Your branch is up-to-date"* ]]; then
    err=0
  else
    err=1
  fi

  _do_dir_pop
  return $err
}

# Checks if the given git repository is dirty or not.
# Arugments:
#   1. repo: The git repository name.
#
function _do_git_repo_is_dirty() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  _do_repo_dir_push $proj_dir $repo

  local err=0
  local text=$(git status)
  if [[ ${text} == *"Changes not staged"* ]] ||
    [[ ${text} == *"Changes to be committed"* ]] ||
    [[ ${text} == *"Not committing merge"* ]]; then
    err=0
  else
    err=1
  fi

  _do_dir_pop
  return $err
}
