# Display a banner.
# Arguments:
#   1. file: Optional. The custom banner file. If missing, the default banner will be used.
#   ...: Optional. Whatever text to be displayed inside the banner.
#
# To generates this logo
# http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=oh-my-ops
#
function _do_banner() {
  local file=${1:-}

  if [ -f "$file" ]; then
    shift 1
  else
    file="$(_do_src_dir)/banner.txt"
  fi

  echo -e "${_DO_FG_ENVIRONMENT}
$(cat "${file}")
    ${*}Powered by oh-my-ops.
------------------------------------------------------------------------------${_DO_FG_NORMAL}"
}
