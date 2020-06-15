function _do_python_repo_venv_start() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  if ! _do_python_repo_venv_enabled $proj_dir $repo; then
    return
  fi

  _do_repo_dir_push $proj_dir $repo

  if [ ! -d ".venv" ]; then
    _do_print_line_1 "activate virtual environment"
    python -m venv .venv

    # Activates the python virtual environmebnt
    source .venv/bin/activate

    pip install --upgrade pip
    pip install -r $proj_dir/$repo/requirements.txt
  else
    _do_print_line_1 "activate virtual environment"
    # Activates the python virtual environmebnt
    source .venv/bin/activate
  fi

  _do_dir_pop
}

function _do_python_repo_venv_stop() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  if ! _do_python_repo_venv_enabled $proj_dir $repo; then
    return
  fi

  _do_print_line_1 "deactivate virtual environment"
  deactivate
}

# Determines if the specified directory has python enabled.
# Arguments:
#   1. dir: A directory.
#
# Returns:
#   0 if python enabled, 1 otherwise.
#
function _do_python_repo_venv_enabled() {
  local proj_dir=$1
  local repo=$2

  if [ -f $proj_dir/$repo/requirements.txt ]; then
    return 0

  else
    # Python is enabled for the specified directory
    return 1
  fi
}
