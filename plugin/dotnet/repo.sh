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



# Builds the dotnet repository.
#
function _do_dotnet_repo_cmd() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    shift 2

    if ! _do_dotnet_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local err=0
    for dir in $(_do_repo_dir_array_print "${repo}" "dotnet-sln"); do
        _do_dotnet_repo_proj_cmd \"${proj_dir}\" \"${repo}\" \"${dir}\" $@ || err=1
    done

    _do_error_report $err "$title"
    return $err
}


# Runs any dotnet command in docker.
# Arguments:
#   1. repo: The repository name.
#
function _do_dotnet_repo_proj_cmd() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    local dir=${3?'dir arg required'}
    shift 3


    local title="$repo: Runs $@ at ${dir}"
    _do_print_header_2 $title

    _do_dir_push "${proj_dir}/${repo}/${dir}"
    _do_print_line_1 "$@"

    eval "$@"
    local err=$?

    _do_dir_pop
    return $err
}
