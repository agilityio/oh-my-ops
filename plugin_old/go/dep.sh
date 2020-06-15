# Determines if the specified directory has go enabled.
# Arguments:
#   1. dir: A directory.
#
# Returns:
#   0 if go enabled, 1 otherwise.
#
function _do_go_repo_dep_enabled() {
  local proj_dir=$1
  local repo=$2

  # On the first dep package found, return right away.
  local packages=($(_do_go_repo_dep_package_list $proj_dir $repo))
  if [ ${#packages[@]} -gt 0 ]; then
    if _do_alias_exist "dep"; then
      # go dep is enabled
      return 0
    else
      _do_log_warn "go" "$repo go dep support is disabled because of missing 'dep' command. Please install go dep to use."
    fi
  else
    return 1
  fi
}

function _do_go_repo_dep_package_cmd() {
  _do_log_debug "go" "_do_go_repo_dep_package_cmd $@"
  local proj_dir=${1?'proj_dir arg required'}
  shift

  local repo=${1?'repo arg required'}
  shift

  local package=${1?'package arg required'}
  shift

  _do_dir_push "${proj_dir}/${repo}/src/${package}"

  $@
  _do_dir_pop
}

function _do_go_repo_dep_package_install() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}
  local package=${3?'package arg required'}

  local title="Update '${package}' go dep dependencies"
  _do_print_line_1 "$title"

  _do_go_repo_dep_package_cmd $proj_dir $repo $package "dep ensure --update"
}

# Lists out the names of all repo dep packages found.
#
function _do_go_repo_dep_package_list() {
  local proj_dir=$1
  local repo=$2
  _do_go_repo_dep_package_walk $proj_dir $repo "echo"
}

# Walks through all go package found in the current repositories.
#
function _do_go_repo_dep_package_walk() {
  _do_log_debug "go" "_do_go_repo_dep_package_walk $@"

  local proj_dir=${1?'proj_dir arg required'}
  shift

  local repo=${1?'repo arg required'}
  shift

  # Looks for all
  local src_dir="$proj_dir/$repo/src"

  if [ ! -d "$src_dir" ]; then
    # If the source dir does not exist, no thing to walk.
    return
  fi

  # Walks through all directories under "src", and check if there is any
  # go package under it.
  _do_dir_push $src_dir

  local dir
  for dir in $(ls -A .); do
    if [ -f "$dir/Gopkg.toml" ]; then
      eval $@ $dir
      local err=$?
      if _do_error $err; then
        # stops
        return $err
      fi
    fi
  done
  _do_dir_pop
}
