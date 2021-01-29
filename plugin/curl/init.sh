# See: https://www.baeldung.com/linux/curl-command-json
_do_plugin 'curl'

_do_log_level_warn 'curl'
_do_src_include_others_same_dir

function _do_curl_plugin_init() {
  # Makes sure the 'make' command line exists.
  command -v curl &> /dev/null || {
    _do_log_warn 'curl' 'curl command is missing. Install it now.' &&
    sudo apt install -y curl
  } || return 1

  _do_log_info 'curl' 'Initialize plugin'
}
