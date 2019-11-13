function _do_flutter_repo_init() {
}

# Display helps about how to run a repository flutter commands.
function _do_flutter_repo_help() {
}


# Runs a flutter repository command.
# Arguments:
#  1. proj_dir: The project directory to find the repository.
#  2. repo: The repository directory to run the command.
#  3. cmd: The flutter command to run.
#
function _do_flutter_repo_cmd() {
  local proj_dir=${1?'proj_dir arg is required'}
  local repo=${2?'repo arg is required'}
  local cmd=${3?'arg command is required'}
  shift 3

  # By default, runs with flutter command.
  local run="flutter ${cmd}"

  _do_dir_push "${DO_PROJ_DIR}/${proj_dir}"
  _do_repo_dir_push 

  {
    { 
      # For command that is not the default flutter one, 
      # we need to append the "run" in front to run it with run script.
      case "${cmd}" in 
        pub-get)
          run="flutter pub get"
          ;;
        build-android)
          run="flutter build apk"
          ;;
        build-ios)
          run="flutter build ios"
          ;;
      esac
    } &&
    _do_print_header_2 "Starts ${cmd} ${repo}" &&
    _do_print_line_1 ${cmd} "${repo}" &&
    ${run} $@ &&
    _do_print_success "Successfully ${cmd} $@ ${repo}."
  } || {
    _do_print_error "Failed to ${cmd} $@ ${repo} project." && err=1
  }

  _do_dir_pop
  return ${err}
}
