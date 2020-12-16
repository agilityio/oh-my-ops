# See: https://www.gnu.org/software/gawk/manual/html_node/String-Functions.html
#

# Converts a string to uppercase.
# Arguments:
# - 1. The string to convert.
#
function _do_string_to_upper() {
  echo "${1^^}"
}

# Converts a string to lowercase.
# Arguments:
# - 1. The string to convert.
#
function _do_string_to_lower() {
  echo "${1,,}"
}

# Converts a string to undercase string
# Rules:
# - non alphabet or digits will be converted to _
# - __ will be converted to _
# - leading & trailing _ will be removed.
#
function _do_string_to_undercase() {
  echo "$1" | sed -e 's/[^a-zA-Z0-9]/_/g' | sed -e 's/___*/_/g' | sed -e 's/^_*//g' | sed -e 's/_*$//g'
}

# Converts a string to a dash string
# Rules:
# - non alphabet or digits will be converted to _
# - __ will be converted to _
# - leading & trailing _ will be removed.
#
function _do_string_to_dash() {
  echo "$1" | sed -e 's/[^a-zA-Z0-9]/-/g' | sed -e 's/\-\-\-*/-/g' | sed -e 's/^\-*//g' | sed -e 's/\-*$//g'
}

# Converts a string to a environment variable uppercase var.
# Rules:
# - non alphabet or digits will be converted to _
# - __ will be converted to _
# - leading & trailing _ will be removed.
# - all characters will be converted to upper case.
#
function _do_string_to_uppercase_var() {
  _do_string_to_undercase "$1" | awk '{print toupper($0)}'
}

# Converts a string to a lower case var.
# Rules:
# - non alphabet or digits will be converted to _
# - __ will be converted to _
# - leading & trailing _ will be removed.
# - all characters will be converted to lower case.
#
function _do_string_to_lowercase_var() {
  _do_string_to_undercase "$1" | awk '{print tolower($0)}'
}

function _do_string_to_alias_name() {
  _do_string_to_dash "$1" | awk '{print tolower($0)}' | sed -E 's/(src|bin)-//g'
}

function _do_string_urlencode() {
  # urlencode <string>
  old_lc_collate=$LC_COLLATE
  LC_COLLATE=C

  local length="${#1}"
  for ((i = 0; i < length; i++)); do
    local c="${1:i:1}"
    case $c in
    [a-zA-Z0-9.~_-]) printf "%s" "$c" ;;
    *) printf '%%%02X' "'$c" ;;
    esac
  done

  LC_COLLATE=$old_lc_collate
}

function _do_string_urldecode() {
  # urldecode <string>

  local url_encoded="${1//+/ }"
  printf '%b' "${url_encoded//%/\\x}"
}

function _do_string_contains() {
  local s1=${1?'s1 arg required'}
  local suffix=${2?'suffix arg required'}

  if [[ "${s1}" == *"${suffix}"* ]]; then
    return 0
  else
    return 1
  fi
}

# Checks if the specified string start with the specified prefix.
#
# Arguments:
#   1. s1: The string to check.
#   2. prefix: The prefix to check.
#
function _do_string_startswith() {
  local s1=${1?'s1 arg required'}
  local prefix=${2?'prefix arg required'}

  if [[ "${s1}" == "${prefix}"* ]]; then
    return 0
  else
    return 1
  fi
}

# Checks if the specified string ends with the specified suffix.
#
# Arguments:
#   1. s1: The string to check.
#   2. suffix: The prefix to check.
#
function _do_string_endswith() {
  local s1=${1?'s1 arg required'}
  local suffix=${2?'suffix arg required'}

  if [[ "${s1}" == *"${suffix}" ]]; then
    return 0
  else
    return 1
  fi
}
