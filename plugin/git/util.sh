# Gets the git root directory of the current dir
#
# Arguments:
#   1. dir: A git directory to test
#
function _do_git_util_get_root() {
  local dir
  dir=$(git rev-parse --show-toplevel)

  local err
  err=$?

  if _do_error $err; then
    echo ""
  else
    echo "$dir"
  fi
}

# Checks if the given git repository is up to date or not.
#
# Arguments:
#   1. dir: A git directory to test
function _do_git_util_is_up_to_date() {
  local dir=${1?'proj_dir arg required'}

  _do_dir_push "${dir}" || return 1

  local err=0
  local text
  text=$(git status)

  git status

  if [[ ${text} == *"Your branch is up-to-date"* ]]; then
    err=0
  else
    err=1
  fi

  _do_dir_pop
  return $err
}

# Checks if the given git repository is dirty or not.
#   1. dir: A git directory to test
#
function _do_git_util_is_dirty() {
  local dir=${1?'proj_dir arg required'}

  _do_dir_push "${dir}" || return 1

  local err=0
  local text
  text=$(git status)

  if [[ ${text} == *"Changes not staged"* ]] ||
    [[ ${text} == *"Untracked files"* ]] ||
    [[ ${text} == *"Changes to be committed"* ]] ||
    [[ ${text} == *"Not committing merge"* ]]; then
    err=0
  else
    err=1
  fi

  _do_dir_pop
  return $err
}
