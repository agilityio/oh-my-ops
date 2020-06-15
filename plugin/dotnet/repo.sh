# Adds a new project to the management list.
# Arguments:
#   1. repo: The repository name.
#
function _do_dotnet() {
  local repo=${1?'repo arg required'}
  shift 1

  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${repo}" 'dotnet' ${DO_DOTNET_CMDS} $@
}

function _do_dotnet_lib() {
  # shellcheck disable=SC2068
  _do_dotnet $@
}


function _do_dotnet_solution() {
  # shellcheck disable=SC2068
  _do_dotnet $@
}


function _do_dotnet_api() {
  local repo=${1?'repo arg required'}
  shift 1

  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${repo}" 'dotnet' ${DO_DOTNET_API_CMDS} $@
}


function _do_dotnet_cli() {
  local repo=${1?'repo arg required'}
  shift 1

  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${repo}" 'dotnet' ${DO_DOTNET_CLI_CMDS} $@
}

function _do_dotnet_web() {
  local repo=${1?'repo arg required'}
  shift 1

  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${repo}" 'dotnet' ${DO_DOTNET_WEB_CMDS} $@
}

function _do_dotnet_test() {
  local repo=${1?'repo arg required'}
  shift 1

  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${repo}" 'dotnet' ${DO_DOTNET_TEST_CMDS} $@
}


