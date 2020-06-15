# Creates a new aay data structure.
#
# Arguments:
#  1. name: Required. The vlistmap name.
#  ... values: Optional. The vlistmap values
#
function _do_vlistmap_new() {
  local name=${1?'name arg required'}

  # Makes sure that the vlistmap not yet exists
  ! _do_vlistmap_exists "${name}" || _do_assert_fail "${name} vlistmap already exists."

  local var_name

  var_name=$(_do_vlistmap_var_name "${name}")
  declare -Ag "${var_name}"

  if [[ $# -gt 1 ]]; then
    # if there vlistmap value is passed in then append that to the vlistmap
    _do_vlistmap_value_append $@
  fi
}

function _do_vlistmap_new_if_not_exists() {
  local name=${1?'name arg required'}
  _do_vlistmap_exists "${name}" || _do_vlistmap_new "${name}"
}

# Destroys an vlistmap data structure
#
# Arguments:
#  1. name: Required. The vlistmap name.
#
function _do_vlistmap_destroy() {
  local name=${1?'name arg required'}
  local var_name=
  var_name=$(_do_vlistmap_var_name_required "${name}")

  unset "${var_name}"
}

function _do_vlistmap_clear() {
  local name=${1?'name arg required'}
  local var_name
  var_name=$(_do_vlistmap_var_name_required "${name}")

  eval "${var_name}=()"
}

# Clears out all value of a specified key in the map.
#
# Arguments:
#   1. name: The map name.
#   2. key: The map key to clear.
#
function _do_vlistmap_value_clear() {
  local name=${1?'name arg required'}
  local key=${2?'key arg required'}

  local arr
  arr="$(_do_vlistmap_var_name "${name}")[@]"

  if _do_array_exists "${arr}"; then
    _do_array_clear "${arr}"
  fi
}

# Checks if an vlistmap exists.
#
# Arguments:
#   1. name: Required. The vlistmap name.
#
# Returns:
#   0 if the vlistmap exists; Otherwise, 1.
#
function _do_vlistmap_exists() {
  local name=${1?'name arg required'}
  local var_name
  var_name=$(_do_vlistmap_var_name "${name}")

  if declare -p "${var_name}" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

# Checks if the specified item exists in the vlistmap.
#
# Arguments:
# 1. name: Required. The vlistmap name.
# 2. val: Required. The value to find in the vlistmap.
#
# Returns:
#   If the vlistmap contains the specified value, returns 0.
#   Otherwise, return 1.
#
function _do_vlistmap_has_key() {
  local name=${1?'name arg required'}
  local key=${2?'key arg required'}

  local arr
  arr="$(_do_vlistmap_var_name "${name}")[@]"

  for v in ${!arr}; do
    if [ "${v}" == "${key}" ]; then
      return 0
    fi
  done

  # Not found the element
  return 1
}

# Checks if the specified item exists in the vlistmap.
#
# Arguments:
# 1. name: Required. The vlistmap name.
# 2. val: Required. The value to find in the vlistmap.
#
# Returns:
#   If the vlistmap contains the specified value, returns 0.
#   Otherwise, return 1.
#
function _do_vlistmap_has_value() {
  local name=${1?'name arg required'}
  local key=${2?'key arg required'}
  local val=${3?'val arg required'}

  local arr
  arr=$(_do_vlistmap_value_var_name "${name}" "${key}")
  if ! _do_array_contains "${arr}" "${val}"; then
    return 1
  fi
}

# Get the size of a vlistmap
#
# Arguments:
#   1. The vlistmap name.
#   2. The variable name to contains the size.
#
function _do_vlistmap_size() {
  local name=${1?'name arg required'}
  local var_name
  var_name=$(_do_vlistmap_var_name_required "${name}")

  local size
  eval "size"='$'"{#${var_name}[@]}"
  echo "${size}"
}

# Get the size of a key's value list.
#
# Arguments:
#   1. name: The vlistmap name.
#   2. key: The key to count the value size.
#
function _do_vlistmap_value_size() {
  local name=${1?'name arg required'}
  local key=${2?'key arg required'}

  local arr
  arr=$(_do_vlistmap_value_var_name "${name}" "${key}")
  _do_array_size "${arr}"
}

# Determines if the map is empty or not.
function _do_vlistmap_is_empty() {
  local name=${1?'name arg required'}

  if [ "$(_do_vlistmap_size "${name}")" == "0" ]; then
    return 0
  else
    return 1
  fi
}

# Determines if a key's value list is empty or not.
#
# Arguments:
#   1. name: The vlistmap name.
#   2. key: The key to count the value size.
#
function _do_vlistmap_value_is_empty() {
  local name=${1?'name arg required'}
  local key=${2?'key arg required'}

  local arr
  arr=$(_do_vlistmap_value_var_name "${name}" "${key}")

  if _do_array_is_empty "${arr}"; then
    return 0
  else
    return 1
  fi
}

# Append 1 more item to the vlistmap
#
# Arguments:
#   1. name: The vlistmap name
#   2. key: The vlistmap key
#   ... values: One value or more to append.
#
function _do_vlistmap_value_append() {
  local name=${1?'name arg required'}
  local key=${2?'key arg required'}

  shift 2
  : "${1?'Missing item(s) to append'}"

  local var_name
  var_name=$(_do_vlistmap_var_name_required "${name}")

  local size
  size=$(_do_vlistmap_size "$name")

  # Makes sure there is at list 1 item to append
  : "${1?'Missing item(s) to append'}"

  # Push the key to the vlist key array
  eval "${var_name}[$size]='$key'"

  # Push all remaining values to a dedicated array
  local vl
  vl=$(_do_vlistmap_value_var_name "${name}" "${key}")

  _do_array_new_if_not_exists "${vl}"
  _do_array_append "${vl}" $@
}

# Print all keys of the map to stdout.
# Arguments:
#   1. The vlistmap name.
#
function _do_vlistmap_print() {
  local name=${1?'Stack name required'}
  local arr
  arr="$(_do_vlistmap_var_name "${name}")[@]"

  for v in ${!arr}; do
    echo "${v}"
  done
}

# Print all values of a key to stdout.
# Arguments:
#   1. The vlistmap name.
#
function _do_vlistmap_value_print() {
  local name=${1?'name arg required'}
  local key=${2?'key arg required'}

  local arr
  arr=$(_do_vlistmap_value_var_name "${name}" "${key}")
  _do_array_print "${arr}"
}

# ==============================================================================
# Private methods
# ==============================================================================

# Converts a logical vlistmap name to the physical one.
#
# Arguments:
#  1. name: Required. The logical vlistmap name.
#
# Output:
#  The physical vlistmap name.
#
function _do_vlistmap_var_name() {
  local name=${1?'name arg required'}
  echo "__do_vlistmap_$(_do_string_to_lowercase_var "${name}")"
}

function _do_vlistmap_value_var_name() {
  local name=${1?'name arg required'}
  echo "__do_vlistmap_$(_do_string_to_lowercase_var "${name}")__v"
}

# Converts a logical value array name to the physical one and make sure
#  that exists
#
# Arguments:
#  1. name: Required.
#
# Outputs:
#   The physical name.
#
function _do_vlistmap_var_name_required() {
  local name=${1?'name arg required'}

  _do_vlistmap_exists "${name}" || _do_assert_fail "${name} vlistmap doest not exist"
  _do_vlistmap_var_name "${name}"
}
