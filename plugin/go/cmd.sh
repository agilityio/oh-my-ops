# Runs an go command at the specified directory.
#
function _do_go_repo_cmd() {
  local cmd=${3?'cmd arg required'}
  shift 3

  local run="go ${cmd}"

  {
    # shellcheck disable=SC2068
    {
      case "${cmd}" in
      start)
        run="go run ."
        ;;
      tidy)
        run="go mod tidy"
        ;;
      gen)
        run="go generate"
        ;;
      doctor)
        run="go env"
        ;;
      esac
    } &&
      ${run} $@
  } || return 1
}
