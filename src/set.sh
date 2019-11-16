# Creates a new set data structure.
#
# Arguments:
#  1. name: Required. The set name.
#  ... values: Optional. The set values
#
function _do_set_new() {
  local name=${1?'name arg required'}

  # Makes sure that the set not yet exists
  ! _do_set_exists "${name}" || _do_assert_fail "${name} set already exists."

  local var
  var=$(__do_set_var_name ${name})

  # Declares an associate set globally.
  declare -Ag "${var}"

  if [[ $# -gt 1 ]]; then
    # if there set value is passed in then append that to the set
    # shellcheck disable=SC2068
    _do_set_append $@
  fi
}

function _do_set_new_if_not_exists() {
  local name=${1?'name arg required'}
  _do_set_exists "${name}" || _do_set_new "${name}"
}

# Destroys an set data structure
#
# Arguments:
#  1. name: Required. The set name.
#
function _do_set_destroy() {
  local name=${1?'name arg required'}
  local var
  var=$(__do_set_var_name_required ${name})

  unset "${var}"
}

function _do_set_clear() {
  local name=${1?'name arg required'}
  local var

  var=$(__do_set_var_name_required ${name})
  eval "${var}=()"
}

# Checks if an set exists.
#
# Arguments:
#   1. name: Required. The set name.
#
# Returns:
#   0 if the set exists; Otherwise, 1.
#
function _do_set_exists() {
  local name=${1?'name arg required'}
  local var

  var=$(__do_set_var_name ${name})

  if declare -p "${var}" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

# Checks if the specified item exists in the set.
#
# Arguments:
# 1. name: Required. The set name.
# 2. key: Required. The value to find in the set.
#
# Returns:
#   If the set contains the specified value, returns 0.
#   Otherwise, return 1.
#
function _do_set_contains() {
  local name=${1?'name arg required'}
  local key=${2?'key arg required'}

  local var
  var="$(__do_set_var_name ${name})"

  # Dynamically get out the value of the key and that must
  # not be empty.
  local v
  eval "v=\${${var}[${key}]}"
  if [[ -z "${v}" ]]; then
    # Not found the element
    return 1
  fi
}

# Get the size of a set
#
# Arguments:
#   1. The set name.
#   2. The variable name to contains the size.
#
function _do_set_size() {
  local name=${1?'name arg required'}
  local var

  var=$(__do_set_var_name_required ${name})

  eval "echo \${#${var}[@]}"
}

function _do_set_is_empty() {
  local name=${1?'name arg required'}

  if [ "$(_do_set_size ${name})" == "0" ]; then
    return 0
  else
    return 1
  fi
}

# Append 1 more item to the set
#
# Arguments:
#   1. name: The set name
#   ... values: One value or more to append.
#
function _do_set_append() {
  local name=${1?'name arg required'}
  local var

  var=$(__do_set_var_name_required "${name}")
  shift 1

  # Makes sure there is at list 1 item to append
  : ${1?'Missing item(s) to append'}

  # For each value, push it to the associate set.
  # This will help to make sure all values are unique.
  while (($# > 0)); do
    eval "${var}[$1]=1"
    shift 1
  done
}

# Print a set to stdout.
# Arguments:
#   1. The set name.
#
function _do_set_print() {
  local name=${1?'Stack name required'}
  local var

  var="$(__do_set_var_name ${name})"
  eval "echo \${!${var}[@]}"
}

# ==============================================================================
# Private methods
# ==============================================================================

# Converts a logical set name to the physical one.
#
# Arguments:
#  1. name: Required. The logical set name.
#
# Output:
#  The physical set name.
#
function __do_set_var_name() {
  local name=${1?'name arg required'}
  echo "__do_set_$(_do_string_to_lowercase_var ${name})"
}

# Converts a logical set name to the physical one and make sure
# that set does exist.
#
# Arguments:
#  1. name: Required. The set logical name.
#
# Outputs:
#  The set physical name.
#
function __do_set_var_name_required() {
  local name=${1?'name arg required'}

  _do_set_exists "${name}" || _do_assert_fail "${name} set doest not exist"
  __do_set_var_name "${name}"
}
