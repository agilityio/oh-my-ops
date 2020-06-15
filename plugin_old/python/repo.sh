# Displays helps about how to run a repository python commands.
#
function _do_python_repo_help() {
  local proj_dir=$1
  local repo=$2

  if ! _do_python_repo_venv_enabled $proj_dir $repo; then
    return
  fi

  _do_print_header_2 "$repo: Python help"

  echo "
  ${repo}-python-help:
    See python command helps

  ${repo}-python-venv-start:
    Activates python virtual environment


  ${repo}-python-venv-stop:
    Deactivates python virtual environment.
"
}

# Initializes python support for a repository.
#
function _do_python_repo_init() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  if ! _do_python_repo_venv_enabled ${proj_dir} ${repo}; then
    _do_log_debug "python" "Skips python support for '$repo'"
    # This directory does not have python support.
    return
  fi

  # Sets up the alias for showing the repo python status
  _do_log_info "python" "Initialize python for '$repo'"
  _do_repo_cmd_hook_add "${repo}" "python" "help"

  _do_repo_alias_add $proj_dir $repo "python" "venv-start venv-stop"
}
