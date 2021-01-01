# See: https://www.baeldung.com/linux/jq-command-json
_do_plugin 'docker'

_do_log_level_warn 'jq'
_do_src_include_others_same_dir

function _do_jq_plugin_init() {
  _do_log_info 'jq' 'Initialize plugin'
  _DO_JQ_DOCKER_IMAGE=${_DO_JQ_DOCKER_IMAGE:-'do-jq-cli'}
}
