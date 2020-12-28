_do_plugin 'docker'
_do_plugin 'gitlab'
_do_plugin 'repo'

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
  _DO_DRONE_SERVER_HOST=${_DO_DRONE_SERVER_HOST:-"localhost:${_DO_DRONE_HTTP_PORT}"}
  _DO_DRONE_SERVER_PROTO=${_DO_DRONE_SERVER_PROTO:-http}

  # See: https://docs.drone.io/server/provider/gitlab/
  # _DO_DRONE_GITLAB_SERVER=${_DO_DRONE_GITLAB_SERVER:-"http://localhost:${_DO_GITLAB_HTTP_PORT}"}
  _DO_DRONE_GITLAB_SERVER=${_DO_DRONE_GITLAB_SERVER:-"http://$(_do_docker_host_ip):${_DO_GITLAB_HTTP_PORT}"}
  _DO_DRONE_GITLAB_CLIENT_ID=${_DO_DRONE_GITLAB_CLIENT_ID:-7bd7074378956edce103bfb6a110d658a6f5eb9f8049512b46a570ea6f6c1a63}
  _DO_DRONE_GITLAB_CLIENT_SECRET=${_DO_DRONE_GITLAB_CLIENT_SECRET:-9ae609b5ab7babbe8c70befdd3c5d5f8a8cec8ff3fa70429661f3c512308e919}
  _DO_DRONE_RPC_SECRET=${_DO_DRONE_RPC_SECRET:-dronerpcsecret}

  # This is the default database created, and credential to access it.
  _DO_DRONE_USER=${_DO_DRONE_USER:-root}
  _DO_DRONE_PASS=${_DO_DRONE_PASS:-pass}
}
