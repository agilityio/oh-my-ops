# Runs an sphinx command at the specified directory.
# Arguments:
# 1. dir: The absolute directory to run the command.
# 2. repo: The repo name
#
# 3. cmd: The command to run.
#
#   * start: Starts the autobuild web server for live-reload html build.
#   * clean: For clean up build artifact.
#   * build: For building up, html, epub, ... output, depending on the
#     settings.
#
function _do_sphinx_repo_cmd() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_sphinx_docker_image_name "${repo}")

  # The name of the sphinx container, running for this repository only.
  local container
  container=$(_do_sphinx_docker_container_name "${repo}")

  ! _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is already running. "
    return 1
  }

  # Checks if the repository has the conf.py file or not.
  _do_sphinx_repo_enabled "${dir}" || {
    _do_print_error "${repo} repo is not an sphinx repo. Expects to have a conf.py file."
    return 1
  }

  local port_opts
  local deamon_opts
  local interactive_opts
  local volume_opts
  local exec_opts

  if [[ "${cmd}" == "start" ]] || [[ "${cmd}" == "build" ]]; then
    volume_opts="-v ${dir}:/app/src"
    port_opts="-p ${_DO_SPHINX_PORT}:8000"
  fi

  if [[ "${cmd}" == "start" ]]; then
    _do_log_info "Sphinx live-reload html server is running at port http://localhost:${_DO_SPHINX_PORT},
      as '${container}' docker container. The following commands are helpful:
      * do-${repo}-logs: To view the build logs
      * do-${repo}-attach: To attach to the docker container that do the auto build.
      * do-${repo}-stop: To stop the build process.
    " &&

    deamon_opts="-d"
    interactive_opts="-it"
  fi

  if [[ "${cmd}" == "build" ]]; then
    exec_opts="${_DO_SPHINX_OUT_FORMAT}"
  else
    exec_opts="${cmd}"
  fi

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_util_image_exists "${image}" ||
        _do_sphinx_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } && {
      # shellcheck disable=SC2086
      docker run --rm --name "$container" \
        ${volume_opts} ${port_opts} ${deamon_opts} ${interactive_opts} \
        "${image}" make ${exec_opts} &> /dev/null
    }
  } || return 1
}

# Install sphinx database to local system. Internally, it will build a docker
# image that contains sphinx to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_sphinx_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # The directory that contains the docker file
  # to build the docker image to run sphinx database server.
  local src_dir
  src_dir="$DO_HOME/plugin/sphinx/docker"

  # The temporary directory that contains a copy of the src
  # docker directory.
  local tmp_dir
  tmp_dir=$(_do_dir_copy_to_random_tmp_dir "${src_dir}") || return 1

  # Makes the docker file
  echo "
FROM python:3.6-slim

WORKDIR /app

RUN apt-get update \
&& apt-get install --no-install-recommends -y \
    graphviz \
    imagemagick \
    make \
&& apt-get autoremove \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir -U pip
RUN python3 -m pip install --no-cache-dir \
Sphinx==${_DO_SPHINX_VERSION} \
Pillow \
sphinx-autobuild==2020.9.1 \
sphinx-rtd-theme==${_DO_SPHINX_RTD_THEME_VERSION}
ADD Makefile /app

VOLUME [ \"/app\" ]
" >"${tmp_dir}/docker/Dockerfile"

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_sphinx_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_util_build_image "${tmp_dir}"/docker "${image}" || {
    _do_dir_pop
    return 1
  }
}

# Stops sphinx server.
#
function _do_sphinx_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the sphinx container, running for this repository only.
  local container
  container=$(_do_sphinx_docker_container_name "${repo}")

  _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_util_kill_container "${container}" &>/dev/null || return 1
}

# Attach
#
function _do_sphinx_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the sphinx container, running for this repository only.
  local container
  container=$(_do_sphinx_docker_container_name "${repo}")

  _do_docker_util_attach_to_container "${container}" || return 1
}

# View logs
#
function _do_sphinx_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the sphinx container, running for this repository only.
  local container
  container=$(_do_sphinx_docker_container_name "${repo}")

  _do_docker_util_show_container_logs "${container}" || return 1
}

# Displays the sphinx server status.
#
function _do_sphinx_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_sphinx_docker_container_name "${repo}")

  local status
  if _do_docker_util_container_exists "${container}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
Environment variables:
  docker image: $(_do_sphinx_docker_image_name "${repo}")
  docker container: $(_do_sphinx_docker_container_name "${repo}")

  _DO_SPHINX_VERSION: ${_DO_SPHINX_VERSION}
  _DO_SPHINX_PORT: ${_DO_SPHINX_PORT}
  _DO_SPHINX_RTD_THEME_VERSION: ${_DO_SPHINX_RTD_THEME_VERSION}
  _DO_SPHINX_OUT_FORMAT: ${_DO_SPHINX_OUT_FORMAT}
  "
}
