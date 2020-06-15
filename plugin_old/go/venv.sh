_do_stack_new "_DO_GO_VENV"

function _do_go_repo_venv_start() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  _do_repo_dir_push $proj_dir $repo

  _do_print_line_1 "activate virtual environment"

  if _do_go_repo_dep_enabled $proj_dir $repo; then
    # adds the current repository to go path
    _do_stack_push "_DO_GO_VENV" "$GOPATH" "$GOBIN"

    export GOPATH="$proj_dir/$repo:$GOPATH"

    # Adds any binary produced by this package to the path.
    export PATH="$proj_dir/$repo/bin:$PATH"

    export GOBIN="$proj_dir/$repo"
  fi

  _do_dir_pop
}

function _do_go_repo_venv_stop() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  _do_print_line_1 "deactivate virtual environment"

  if _do_go_repo_dep_enabled $proj_dir $repo; then
    _do_stack_pop "_DO_GO_VENV" "__do_old_bin"
    _do_stack_pop "_DO_GO_VENV" "__do_old_path"

    export GOPATH=$__do_old_path
    export GOBIN=$__do_old_bin
  fi
}
