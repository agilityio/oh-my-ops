# Creates a new set data structure.
#
# Arguments:
#  1. name: Required. The set name.
#  ... values: Optional. The set values
#
function _do_set_new() {
  local name=${1?'name arg required'}
  shift 1

  # Makes sure that the set not yet exists
  ! _do_array_exists "${name}" || _do_assert_fail "${name} set already exists."

  # shellcheck disable=SC2068
  _do_array_new "${name}" $@ || return 1
}

function _do_set_new_if_not_exists() {
  local name=${1?'name arg required'}
  _do_set_exists "${name}" || _do_set_new "${name}" || return 1
}

# Destroys an set data structure
#
# Arguments:
#  1. name: Required. The set name.
#
function _do_set_destroy() {
  local name=${1?'name arg required'}
  _do_array_destroy "${name}" || return 1
}

function _do_set_clear() {
  local name=${1?'name arg required'}
  _do_array_clear "${name}" || return 1
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
  _do_array_exists "${name}" || return 1
}

# Checks if the specified item exists in the set.
#
# Arguments:
# 1. name: Required. The set name.
# 2. val: Required. The value to find in the set.
#
# Returns:
#   If the set contains the specified value, returns 0.
#   Otherwise, return 1.
#
function _do_set_contains() {
  local name=${1?'name arg required'}
  local val=${2?'val arg required'}

  _do_array_contains "${name}" "${val}" || return 1
}

# Get the size of a set
#
# Arguments:
#   1. The set name.
#   2. The variable name to contains the size.
#
function _do_set_size() {
  local name=${1?'name arg required'}
  _do_array_size "${name}" || return 1
}

function _do_set_is_empty() {
  local name=${1?'name arg required'}

  _do_array_is_empty "${name}" || return 1
}

# Append 1 more item to the set
#
# Arguments:
#   1. name: The set name
#   ... values: One value or more to append.
#
function _do_set_append() {
  local name=${1?'name arg required'}
  shift 1

  # Makes sure there is at list 1 item to append
  : "${1?'Missing item(s) to append'}"

  # For each value, push it to the associate set.
  # This will help to make sure all values are unique.
  while (($# > 0)); do
    _do_array_contains "${name}" "${1}" || _do_array_append "${name}" "${1}"
    shift 1
  done
}

# Print a set to stdout.
# Arguments:
#   1. The set name.
#
function _do_set_print() {
  local name=${1?'Stack name required'}
  _do_array_print "${name}" || return 1
}
