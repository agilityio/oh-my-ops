
# Install jenkins database to local system. Internally, it will build a docker
# image that contains jenkins to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_jenkins_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # The temporary directory that contains a copy of the src
  # docker directory.
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  # Makes the docker file
  # https://www.jenkins.io/doc/book/installing/docker/
  # https://hub.docker.com/r/jenkins/jenkins/
  echo "
FROM jenkins/jenkins:${_DO_JENKINS_VERSION}
USER root
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       \"deb [arch=amd64] https://download.docker.com/linux/debian \
       \$(lsb_release -cs) stable\"
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
ENV DOCKER_TLS_VERIFY=0
ENV JAVA_OPTS=\"-Djenkins.install.runSetupWizard=false\"
ENV JENKINS_OPTS=\"--argumentsRealm.roles.user=${_DO_JENKINS_USER} --argumentsRealm.passwd.admin=${_DO_JENKINS_PASS} --argumentsRealm.roles.admin=${_DO_JENKINS_USER}\"
RUN jenkins-plugin-cli --plugins blueocean:1.24.3
" > "${tmp_dir}/Dockerfile"


  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_jenkins_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_util_build_image "${tmp_dir}" "${image}" || return 1
}

# Starts jenkins server.
#
function _do_jenkins_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_jenkins_docker_image_name "${repo}")

  # The name of the jenkins container, running for this repository only.
  local container
  container=$(_do_jenkins_docker_container_name "${repo}")

  ! _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_util_image_exists "${image}" ||
      _do_jenkins_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&

    # Runs the jenkins server as deamon
    docker run --rm -d --name "${container}" \
      --publish "${_DO_JENKINS_UI_PORT}:8080" \
      --publish "${_DO_JENKINS_SLAVE_PORT}:50000" \
      "${image}" \
      &&

    # Notifies run success
    echo "jenkins is running at port ${_DO_JENKINS_UI_PORT} as '${container}' docker container." &&

    # Prints out some status about the server
    _do_jenkins_repo_cmd_status "${dir}" "${repo}"

  } || return 1
}


# Stops jenkins server.
#
function _do_jenkins_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the jenkins container, running for this repository only.
  local container
  container=$(_do_jenkins_docker_container_name "${repo}")

  _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_util_kill_container "${container}" &> /dev/null || return 1
}


# Attach
#
function _do_jenkins_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the jenkins container, running for this repository only.
  local container
  container=$(_do_jenkins_docker_container_name "${repo}")

  _do_docker_util_attach_to_container "${container}" || return 1
}

# View logs
#
function _do_jenkins_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the jenkins container, running for this repository only.
  local container
  container=$(_do_jenkins_docker_container_name "${repo}")

  _do_docker_util_show_container_logs "${container}" || return 1
}



# Stops jenkins db server.
#
function _do_jenkins_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_jenkins_docker_container_name "${repo}")

  local status
  if _do_docker_util_container_exists "${container}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
App: http://${_DO_DOCKER_HOST_NAME}:${_DO_JENKINS_UI_PORT}
Environment variables:
  docker image: $(_do_jenkins_docker_image_name "${repo}")
  docker container: $(_do_jenkins_docker_container_name "${repo}")

  _DO_JENKINS_VERSION: ${_DO_JENKINS_VERSION}
  _DO_JENKINS_USER: ${_DO_JENKINS_USER}
  _DO_JENKINS_PASS: ${_DO_JENKINS_PASS}
  _DO_JENKINS_UI_PORT: ${_DO_JENKINS_UI_PORT}
  _DO_JENKINS_SLAVE_PORT: ${_DO_JENKINS_SLAVE_PORT}
  "
}
