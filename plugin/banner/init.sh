# To generates this logo
# http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=oh-my-ops
#
function _do_banner() {
  local file=$1
  shift 1

  if [ -z "${file}" ]; then
    file="$(_do_src_dir)/banner.txt"
  fi

  echo -e "${_DO_FG_ENVIRONMENT}
$(cat ${file})
    $@
------------------------------------------------------------------------------${_DO_FG_NORMAL}"
}
