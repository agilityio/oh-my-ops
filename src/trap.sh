declare -a _DO_TRAP_STACK

function _do_trap_push() {
  local func=$1
  # Adds a new element to the last of the array
  local len=${#_DO_TRAP_STACK[@]}
  _DO_TRAP_STACK[$len]="$func"
  trap "$func" EXIT
}

function _do_trap_pop() {
  local size=${#_DO_TRAP_STACK[@]}

  if [ "$size" != "0" ]; then
    # Removes the last element from the array.
    size=$((size - 1))
    _DO_TRAP_STACK=("${_DO_TRAP_STACK[@]:0:$size}")
  fi

  if [ "$size" != "0" ]; then
    size=$((size - 1))
    local func=${_DO_TRAP_STACK[$size]}
    trap "$func" EXIT
  else
    trap "" EXIT
  fi
}
