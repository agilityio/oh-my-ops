declare -A _do_log_level_map

# Default root log level is DEBUG
_do_log_level_map[root]="4"

# ==============================================================================
# Log Level
# ==============================================================================

# Gets the log level name.
# Arguments:
#   1. level: The log level number (1->4)
#
function _do_log_level_name() {
  local level="$1"

  case $level in
  "1")
    echo "${_DO_FG_RED}ERROR${_DO_FG_NORMAL}"
    ;;
  "2")
    echo "${_DO_FG_YELLOW} WARN${_DO_FG_NORMAL}"
    ;;

  "3")
    echo "${_DO_FG_PURPLE} INFO${_DO_FG_NORMAL}"
    ;;
  "4")
    echo "${_DO_FG_BLUE}DEBUG${_DO_FG_NORMAL}"
    ;;
  esac
}

# Sets log level for a category.
# Arguments:
#   1. level: The log level to set.
#   2. category: The log category to set.
function _do_log_level() {
  local level=$1
  local category=$2

  _do_log_level_map[$category]=$level
}

# Sets the specified category to error log level.
# Arguments:
#   1. category: The log category.
#
function _do_log_level_error() {
  _do_log_level 1 "$1"
}

# Sets the specified category to warn log level.
# Arguments:
#   1. category: The log category.
#
function _do_log_level_warn() {
  _do_log_level 2 "$1"
}

# Sets the specified category to info log level.
# Arguments:
#   1. category: The log category.
#
function _do_log_level_info() {
  _do_log_level 3 "$1"
}

# Sets the specified category to debug log level.
# Arguments:
#   1. category: The log category.
#
function _do_log_level_debug() {
  _do_log_level 4 "$1"
}

# ==============================================================================
# Log Print
# ==============================================================================

# Prints out a log message
# 1. level: The log level
# 2. category: The log category. If missing, this will be default to root
# 3. msg: The log message.
#
function _do_log_print() {
  if [ "${_DO_NO_LOG}" == "yes" ]; then
    return
  fi

  local level=$1
  local level_name
  level_name=$(_do_log_level_name "$level")

  if [ $# -eq 2 ]; then
    # If only 2 arguments passed in,
    # the category argument is ignored and default to root.
    local msg="$2"
    local category_level=${_do_log_level_map[root]}
  else
    local category="$2"
    local msg="$3"
    local category_level=${_do_log_level_map[$category]}
    if [ -z "$category_level" ]; then
      category_level=${_do_log_level_map[root]}
    fi
  fi

  if [ "$level" -gt "$category_level" ]; then
    # Ignore this log message.
    return
  fi

  if [ $# -eq 2 ]; then
    echo -e "$level_name: $msg"
  else
    echo -e "$level_name: ${_DO_FG_CYAN}$category${_DO_FG_NORMAL}: $msg"
  fi
}

# Prints out an error log message.
# Arguments:
#   1. category (optional): The log category.
#   2. msg: The log message.
#
function _do_log_error() {
  _do_log_print 1 "$@"
}

# Prints out a warn log message.
# Arguments:
#   1. category (optional): The log category.
#   2. msg: The log message.
#
function _do_log_warn() {
  _do_log_print 2 "$@"
}

# Prints out a info log message.
# Arguments:
#   1. category (optional): The log category.
#   2. msg: The log message.
#
function _do_log_info() {
  _do_log_print 3 "$@"
}

# Prints out a debug log message.
# Arguments:
#   1. category (optional): The log category.
#   2. msg: The log message.
#
function _do_log_debug() {
  _do_log_print 4 "$@"
}
