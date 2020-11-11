# Runs an nx command at the specified directory.
#
# Arguments:
# 1. dir: The absolute directory to run the command.
#
# 2. cmd: The command to run.
#
#   It is ok to put any command, as long as it is defined in the package.json.
#
function _do_nx_repo_cmd() {
  local err=0
  local dir=${1?'dir arg required'}
  local cmd=${3?'cmd arg required'}

  shift 3

  local run="nx"

  if [[ "${dir}" == "UNIT-TEST" ]]; then
    # For unit testing
    run="echo ${run}"
  fi

  # replaces the "start " prefix with the "serve " prefix
  # see: https://wiki.bash-hackers.org/syntax/pe#search_and_replace
  cmd=${cmd/#start::/serve::}

  # Replaces watch prefix with the "build --watch" prefix
  cmd=${cmd/#watch::/build --watch::}

  # Replaces all '::' to 'space'
  cmd=${cmd//::/ }

  {
    ${run} ${cmd} $@
  } || {
    err=1
  }

  return ${err}
}


# Runs an nx command at the specified directory.
# 
# Arguments:
# 1. dir: The absolute directory to run the command.
# 2. cmd: Always "cli"
#
function _do_nx_repo_cmd_cli() {
  local err=0
  local dir=${1?'dir arg required'}
  shift 3

  local run="nx"

  if [[ "${dir}" == "UNIT-TEST" ]]; then
    # For unit testing
    run="echo ${run}"
  fi

  {
    ${run} $@
  } || {
    err=1
  }

  return ${err}
}

