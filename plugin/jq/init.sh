# See: https://www.baeldung.com/linux/jq-command-json
_do_plugin 'jq'

_do_log_level_warn 'jq'
_do_src_include_others_same_dir

function _do_jq_plugin_init() {
  # Makes sure the 'make' command line exists.
  command -v jq &> /dev/null || {
    _do_log_warn 'jq' 'jq command is missing. Install it now.' &&
    sudo apt install -y jq
  } || return 1

  _do_log_info 'jq' 'Initialize plugin'
}
