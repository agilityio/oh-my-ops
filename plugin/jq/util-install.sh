function _do_jq_util_install() {
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  # Makes the docker file
  echo "
FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /bin
RUN wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
  chmod 755 jq

# Default command
CMD [\"/bin/jq\"]

" >"${tmp_dir}/Dockerfile"

  # Builds the docker image
  _do_docker_container_build "${tmp_dir}" "${_DO_JQ_DOCKER_IMAGE}" || return 1
}

function _do_jq_util_exists() {
  _do_docker_image_exists "${_DO_JQ_DOCKER_IMAGE}" || return 1
}

function _do_jq_util_install_if_missing() {
  _do_jq_util_exists ||
    _do_jq_util_install ||
    return 1
}
