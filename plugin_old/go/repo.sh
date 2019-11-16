# Displays helps about how to run a repository go commands.
#
function _do_go_repo_help() {
  local proj_dir=$1
  local repo=$2
  local mode=$3

  if ! _do_go_repo_enabled $proj_dir $repo; then
    return
  fi

  if [ "${mode}" = "--short" ]; then
    echo "
  ${repo}-go-help:
    See go command helps"
    return
  fi

  _do_print_header_2 "$repo: Go help"

  _do_print_line_1 "repository's commands"

  echo "
  ${repo}-go-help:
    See this help.

  ${repo}-go-clean:
    Cleans go build output

  ${repo}-go-build:
    Builds all go modules or godep packages found in the repository.

  ${repo}-go-test:
    Tests all go modules or godep packages found in the repository.

  ${repo}-go-start:
    Starts the go web server as daemon, with live-reloading.

  ${repo}-go-watch:
    Watches the go web server, with live-reloading.

  ${repo}-go-stop:
    Stops the go web server.

  ${repo}-go-status:
    Displays the go status.

  ${repo}-go-web:
    Opens the go web page.
"
  _do_dir_push $proj_dir/$repo/src

  _do_print_line_1 "go run commands"

  local name
  for name in $(find . -mindepth 2 -maxdepth 5 -name main.go -print); do
    if [ -f "$name" ]; then
      # Removes the main.go out of the command name.
      local name=$(dirname ${name})

      # Removes the first 2 characters './'.
      name=$(echo $name | cut -c 3-)

      # Example:
      #   for master/cmd/main.go
      #   the cmd will be "master-cmd"
      #
      local cmd=$(_do_string_to_dash ${name})
      echo "
  ${repo}-go-run-${cmd}:
    Runs src/${name}/main.go command.
            "
    fi
  done

  _do_dir_pop

  _do_print_line_1 "global commands"

  echo "
  do-all-go-clean:
    Cleans all go build output for all repositories.

  do-all-go-build:
    Go build for all repositories.

  do-all-go-test:
    Go test for all repositories.
"
}

# Cleans the repository go output.
#
function _do_go_repo_clean() {
  local proj_dir=$1
  local repo=$2

  if ! _do_go_repo_enabled $proj_dir $repo; then
    return
  fi

  local title="$repo: cleans go build result"
  _do_print_header_2 $title

  local err=$?
  _do_error_report $err "$title"
  return $err
}

# Builds the go repository.
#
function _do_go_repo_build() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  if ! _do_go_repo_enabled $proj_dir $repo; then
    return
  fi

  local title="$repo: Builds go repository"
  _do_print_header_2 $title

  _do_go_repo_venv_start "$proj_dir" "$repo"

  if _do_go_repo_mod_enabled $proj_dir $repo; then
    # Do go build on all go modules found.
    local cmd="_do_go_repo_mod_package_install $proj_dir $repo"
    _do_go_repo_mod_package_walk "$proj_dir" "$repo" "$cmd"
  fi

  if _do_go_repo_dep_enabled $proj_dir $repo; then
    local cmd="_do_go_repo_dep_package_install $proj_dir $repo"
    _do_go_repo_dep_package_walk "$proj_dir" "$repo" "$cmd"
  fi

  _do_go_repo_venv_stop "$proj_dir" "$repo"

  local err=$?
  _do_error_report $err "$title"
  return $err
}

# Test the go repository.
#
function _do_go_repo_test() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  if ! _do_go_repo_enabled $proj_dir $repo; then
    return
  fi

  local title="$repo: Tests go repository"
  _do_print_header_2 $title

  _do_go_repo_venv_start "$proj_dir" "$repo"

  if _do_go_repo_mod_enabled $proj_dir $repo; then
    # Do go build on all go modules found.
    local cmd="_do_go_repo_mod_package_test $proj_dir $repo"
    _do_go_repo_mod_package_walk "$proj_dir" "$repo" "$cmd"
  fi

  # TODO: Test with go dep
  # if _do_go_repo_dep_enabled $proj_dir $repo; then
  #     local cmd="_do_go_repo_dep_package_install $proj_dir $repo"
  #     _do_go_repo_dep_package_walk "$proj_dir" "$repo" "$cmd"
  # fi

  _do_go_repo_venv_stop "$proj_dir" "$repo"

  local err=$?
  _do_error_report $err "$title"
  return $err
}

# Determines if the specified directory has go enabled.
# Arguments:
#   1. dir: A directory.
#
# Returns:
#   0 if go enabled, 1 otherwise.
#
function _do_go_repo_enabled() {
  local proj_dir=$1
  local repo=$2

  if _do_go_repo_mod_enabled ${proj_dir} ${repo} || _do_go_repo_dep_enabled ${proj_dir} ${repo}; then
    return 0

  else
    # Go is enabled for the specified directory
    return 1
  fi
}

# Initializes go support for a repository.
#
function _do_go_repo_init() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  if ! _do_go_repo_enabled ${proj_dir} ${repo}; then
    _do_log_debug "go" "Skips go support for '$repo'"
    # This directory does not have go support.
    return
  fi

  # Sets up the alias for showing the repo go status
  _do_log_info "go" "Initialize go for '$repo'"
  _do_repo_cmd_hook_add "${repo}" "go" "help clean build test"

  _do_repo_alias_add $proj_dir $repo "go" "help clean build test cmd"

  _do_dir_push $proj_dir/$repo/src

  local name
  for name in $(find . -mindepth 2 -maxdepth 5 -name main.go -print); do
    _do_log_debug "go" "  $repo/$name"

    if [ -f "$name" ]; then
      # Removes the main.go out of the command name.
      local name=$(dirname ${name})

      # Removes the first 2 characters './'.
      name=$(echo $name | cut -c 3-)

      # Example:
      #   for master/cmd/main.go
      #   the cmd will be "master-cmd"
      #
      local cmd=$(_do_string_to_dash ${name})
      local repo_alias="${repo}-go-run-${cmd}"

      alias "${repo_alias}"="_do_go_repo_cmd ${proj_dir} ${repo} run ${name}"
    fi
  done
  _do_dir_pop
}

# Runs any go command in docker.
# Arguments:
#   1. repo: The repository name.
#
function _do_go_repo_cmd() {
  local proj_dir=$1
  shift

  local repo=$1
  shift

  _do_go_repo_venv_start "$proj_dir" "$repo"

  _do_repo_dir_push $proj_dir $repo

  _do_print_line_1 "go $@"
  go $@

  _do_go_repo_venv_stop "$proj_dir" "$repo"

  _do_dir_pop
  return $?
}
