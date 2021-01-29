# See: https://github.com/atmoz/sftp

_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'sftp'
_do_src_include_others_same_dir

# Initializes sftp plugin.
#
function _do_sftp_plugin_init() {
  _do_log_info 'sftp' 'Initialize plugin'

  # This is the default sftp version to run with.
  _DO_SFTP_VERSION=${_DO_SFTP_VERSION:-'latest'}

  # This is the default sftp port.
  _DO_SFTP_PORT=${_DO_SFTP_PORT:-2233}

  # This is the default database created, and credential to access it.
  _DO_SFTP_USER=${_DO_SFTP_USER:-user}
  _DO_SFTP_PASS=${_DO_SFTP_PASS:-pass}

  _DO_SFTP_CMDS=${_DO_SFTP_CMDS:-'install start stop status logs attach help'}
}
