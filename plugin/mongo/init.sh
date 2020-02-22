_do_plugin 'docker'

_do_log_level_warn 'mongo'
_do_src_include_others_same_dir

# Initializes mongo plugin.
#
function _do_mongo_plugin_init() {
  _do_log_info 'mongo' 'Initialize plugin'

  # This is the default docker image name & container
  local default="do-mongo"

  _DO_MONGO_DOCKER_IMAGE=${_DO_MONGO_DOCKER_IMAGE:-$default}
  _DO_MONGO_DOCKER_CONTAINER=${_DO_MONGO_DOCKER_CONTAINER:-$default}
}
