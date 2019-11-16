function _do_error() {
  local err="$1"

  if [ -z "$err" ] || [ "$err" = "0" ]; then
    # No error found
    return 1
  else
    # True, error found.
    return 0
  fi
}

function do_error_assert_not() {
  local $err="$1"
  shift

  [ ! do_error $1 ] || _do_assert_fail $@
}

function _do_error_report() {
  local err=$1
  shift

  if _do_error $err; then
    _do_print_error "ERROR!" $@

  else
    _do_print_finished "SUCCESS!" $@
  fi
}

function _do_error_report_line() {
  local err=$1
  shift

  local msg=$1
  shift

  local line=$(printf '%0.1s' "."{1..75})

  local pad=${line:${#msg}}
  local color
  local char

  if _do_error $err; then
    char="F"
    color=${_DO_FG_RED}
  else
    char="P"
    color=${_DO_FG_GREEN}
  fi

  printf "${color}%s${_DO_FG_NORMAL} ${_DO_TX_DIM}%s${_DO_FG_NORMAL}[${color}${char}${_DO_FG_NORMAL}]\n" "$msg" "${pad}"
}
