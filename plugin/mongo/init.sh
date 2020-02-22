_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'mongo'
_do_src_include_others_same_dir

# Initializes mongo plugin.
#
function _do_mongo_plugin_init() {
  _do_log_info 'mongo' 'Initialize plugin'

  # This is the default docker image name & container
  local default="do-mongo"

  # This is the default docker image name.
  _DO_MONGO_DOCKER_IMAGE=${_DO_MONGO_DOCKER_IMAGE:-$default}

  # This is the default docker container name.
  _DO_MONGO_DOCKER_CONTAINER=${_DO_MONGO_DOCKER_CONTAINER:-$default}

  # This is the default mongo port.
  _DO_MONGO_PORT=${_DO_MONGO_PORT:-27017}

  # The default mongo admin credential.
  _DO_MONGO_ADMIN_USER=${_DO_MONGO_ADMIN_USER:-admin}
  _DO_MONGO_ADMIN_PASS=${_DO_MONGO_ADMIN_PASS:-admin}

  # This is the default database created, and credential to access it.
  _DO_MONGO_DB=${_DO_MONGO_DB:-db}
  _DO_MONGO_USER=${_DO_MONGO_USER:-user}
  _DO_MONGO_PASS=${_DO_MONGO_PASS:-pass}
}
