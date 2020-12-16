# This function help to replace the builtin "alias" command
# That does not persists to the child shell.
# For example, instead of doing "alias my_cd=cd", you would
# do "_do_alias "my_cd" "cd"
#
# Arguments:
#   1: The alias name
#   2: The alias body.
#
function _do_alias() {
  local from=${1?'from name required'}
  local to=${2?'to name required'}
  shift 2

  # Generates a function that serves as the alias
  local src
  src="
    function ${from} {
      ${to} \$@
      return \$?
    }
  "

  eval "${src}"
}

# This function checks if an alias or type exists
# Return: "yes" if exists; otherwise, return "no"
#
# Arguments:
#   ...name: The list of alias to check.
#
function _do_alias_exist() {
  : "${1?'Alias name is required'}"

  while (($# > 0)); do
    local name=$1
    shift 1

    if (alias "${name}" &>/dev/null || type "${name}" &>/dev/null); then
      continue
    else
      # The current alias does not exist
      return 1
    fi
  done

  return 0
}

# If the alias exists, call it.
# Arguments:
# 1. name: Optional. The alias name to call.
#
function _do_alias_call_if_exists() {
  local name=${1?'alias name required'}
  local err=0

  {
    ! _do_alias_exist "$name"
  } || {
      eval "$@"
  } || {
    err=1
  }

  return $err
}

# Gets the list of alias given a prefix.
# Arguments:
# 1. prefix: Optional. The alias prefix to search.
#
function _do_alias_list() {
  local prefix=${1:-}
  local expr="s/declare[[:blank:]]*-f[[:blank:]]${prefix}\(.*\)/\1/"
  declare -F | grep "declare -f ${prefix}" | sed -e "${expr}"
}

function _do_alias_feature_check() {
  local feature=${1?'Support name required'}
  shift 1

  : "${1?'Alias name is required'}"

  local miss=()

  while (($# > 0)); do
    local name=$1
    shift 1

    if (alias "${name}" &>/dev/null || type "${name}" &>/dev/null); then
      continue
    else
      # This alias is missing
      miss+=("${name}")
    fi
  done

  if ((${#miss[@]} > 0)); then
    _do_log_warn "${feature}" "Disable ${feature} supports because of missing ${miss[*]} commands"
    return 1

  else
    return 0
  fi
}

function _do_alias_remove_by_prefix() {
  local prefix=${1?'prefix required'}

  # Removes all aliases begin with the specified prefix
  for cmd in $(_do_alias_list "${prefix}"); do
    # Removes the function
    unset -f "${prefix}${cmd}"
  done
}

# Asserts that the specified alias exists.
# Arguments:
# 1. name: Required. The alias name.
#
function _do_alias_assert() {
  local name=${1?'name required'}
  _do_alias_exist "${name}" || _do_assert_fail "'${name}' alias does not exist"
}
