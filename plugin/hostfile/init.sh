# See: https://www.baeldung.com/linux/hostfile-command-json
_do_plugin 'docker'

_do_log_level_warn 'hostfile'
_do_src_include_others_same_dir

function _do_hostfile_plugin_init() {
  _do_log_info 'hostfile' 'Initialize plugin'
  _DO_HOSTFILE_DOCKER_IMAGE=${_DO_HOSTFILE_DOCKER_IMAGE:-'do-hostfile-cli'}

  # The hostfile backup
  _DO_HOSTFILE_BACKUP=${_DO_HOSTFILE_BACKUP:-'/tmp/.hosts.do.bak'}
}
