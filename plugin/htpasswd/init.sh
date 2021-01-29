# See: https://www.baeldung.com/linux/htpasswd-command-json
_do_plugin 'docker'

_do_log_level_warn 'htpasswd'
_do_src_include_others_same_dir

function _do_htpasswd_plugin_init() {
  _do_log_info 'htpasswd' 'Initialize plugin'
  _DO_HTPASSWD_DOCKER_IMAGE=${_DO_HTPASSWD_DOCKER_IMAGE:-'do-htpasswd-cli'}
}
