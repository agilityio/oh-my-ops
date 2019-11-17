_DO_TIMER=$(date +%s)

function _do_timer_start() {
  _DO_TIMER=$(date +%s)
}

function _do_timer_end() {
  local end=$(date +%s)
  echo "$(expr $end - ${_DO_TIMER})"
  _DO_TIMER=${end}
}
