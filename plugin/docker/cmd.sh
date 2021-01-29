function _do_docker_repo_cmd() {
  local repo=${2?'repo arg required'}
  local cmd=${3?'arg command is required'}
  shift 3

  local image
  image="do-${repo}:latest"

  # shellcheck disable=SC2068
  case "${cmd}" in
  package)
    # This is just a hook for other plugins to run
    [[ -z "${_DO_DOCKER_REGISTRY}" ]] ||
      docker tag "${image}" "${_DO_DOCKER_REGISTRY}/${image}" ||
      return 1
    ;;

  deploy)
    # This is just a hook for other plugins to run
    [[ -z "${_DO_DOCKER_REGISTRY}" ]] ||
      docker push "${_DO_DOCKER_REGISTRY}/${image}" ||
      return 1
    ;;

  clean)
    docker rmi "${image}" || return 1
    return
    ;;

  build)
    # Builds the docker image with the default tag.
    docker build . --tag "${image}" || return 1
    return
    ;;
  *)
    # shellcheck disable=SC2068
    docker $@ || return 1
    ;;
  esac
}
