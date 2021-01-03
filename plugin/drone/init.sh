_do_plugin 'docker'
_do_plugin 'gitlab'
_do_plugin 'repo'
_do_plugin 'curl'
_do_plugin 'jq'

_do_log_level_warn 'drone'
_do_src_include_others_same_dir

# Initializes drone plugin.
#
function _do_drone_plugin_init() {
  _do_log_info 'drone' 'Initialize plugin'

  # This is the default drone version to run with.
  _DO_DRONE_VERSION=${_DO_DRONE_VERSION:-"latest"}

  # This is the default drone port.
  _DO_DRONE_HTTP_PORT=${_DO_DRONE_HTTP_PORT:-8480}
  _DO_DRONE_HTTPS_PORT=${_DO_DRONE_HTTPS_PORT:-18443}
  _DO_DRONE_SERVER_HOST=${_DO_DRONE_SERVER_HOST:-"${_DO_DOCKER_HOST_IP}"}
  _DO_DRONE_SERVER_PROTO=${_DO_DRONE_SERVER_PROTO:-'http'}

  # See: https://docs.drone.io/server/provider/gitlab/
  _DO_DRONE_GITLAB_SERVER=${_DO_DRONE_GITLAB_SERVER:-"http://${_DO_DOCKER_HOST_IP}:${_DO_GITLAB_HTTP_PORT}"}

  # This Gitlab application is inserted to gitlab database
  # during drone start command.
  # See: https://docs.drone.io/server/provider/gitlab/ to see how this
  # application should be setup via UI.
  _DO_DRONE_GITLAB_CLIENT_ID=${_DO_DRONE_GITLAB_CLIENT_ID:-7bd7074378956edce103bfb6a110d658a6f5eb9f8049512b46a570ea6f6c1a63}
  _DO_DRONE_GITLAB_CLIENT_SECRET=${_DO_DRONE_GITLAB_CLIENT_SECRET:-9ae609b5ab7babbe8c70befdd3c5d5f8a8cec8ff3fa70429661f3c512308e919}

  # This the secret to be shared with the drone runner.
  _DO_DRONE_RPC_SECRET=${_DO_DRONE_RPC_SECRET:-dronerpcsecret}

  _DO_DRONE_RUNNER_CAPACITY=${_DO_DRONE_RUNNER_CAPACITY:-1}
  _DO_DRONE_RUNNER_PORT=${_DO_DRONE_RUNNER_PORT:-3000}

  # This is the default database created, and credential to access it.
  _DO_DRONE_USER=${_DO_DRONE_USER:-root}

  # This is the bearer token that can be used to access drone's api.
  _DO_DRONE_USER_TOKEN=${_DO_DRONE_USER_TOKEN:-pass}
}
