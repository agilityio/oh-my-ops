function _do_hostfile_util_install() {
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  # Makes the docker file
  echo "
FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /bin
RUN wget -O /tmp/goodhosts.tar.gz https://github.com/goodhosts/cli/releases/download/v1.0.7/goodhosts_linux_amd64.tar.gz && \
  tar --extract --file=/tmp/goodhosts.tar.gz goodhosts && \
  rm -f /tmp/goodhosts.tar.gz && \
  chmod 755 goodhosts

# Default command
CMD [\"/bin/goodhosts\"]

" >"${tmp_dir}/Dockerfile"

  # Builds the docker image
  _do_docker_util_build_image "${tmp_dir}" "${_DO_HOSTFILE_DOCKER_IMAGE}" || return 1
}

function _do_hostfile_util_exists() {
  _do_docker_util_image_exists "${_DO_HOSTFILE_DOCKER_IMAGE}" || return 1
}

function _do_hostfile_util_install_if_missing() {
  _do_hostfile_util_exists ||
    _do_hostfile_util_install ||
    return 1
}
