# See: https://github.com/atmoz/maildev

_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'maildev'
_do_src_include_others_same_dir

# Initializes maildev plugin.
#
function _do_maildev_plugin_init() {
  _do_log_info 'maildev' 'Initialize plugin'

  # This is the default maildev version to run with.
  _DO_MAILDEV_VERSION=${_DO_MAILDEV_VERSION:-'latest'}

  # This is the default maildev port.
  _DO_MAILDEV_UI_PORT=${_DO_MAILDEV_UI_PORT:-10080}
  _DO_MAILDEV_SMTP_PORT=${_DO_MAILDEV_SMTP_PORT:-1025}

  # This is the default database created, and credential to access it.
  _DO_MAILDEV_USER=${_DO_MAILDEV_USER:-user}
  _DO_MAILDEV_PASS=${_DO_MAILDEV_PASS:-pass}

  _DO_MAILDEV_OUTGOING_HOST=${_DO_MAILDEV_OUTGOING_HOST:-}
  _DO_MAILDEV_OUTGOING_PORT=${_DO_MAILDEV_OUTGOING_PORT:-}
  _DO_MAILDEV_OUTGOING_USER=${_DO_MAILDEV_OUTGOING_USER:-}
  _DO_MAILDEV_OUTGOING_PASS=${_DO_MAILDEV_OUTGOING_PASS:-}
  _DO_MAILDEV_AUTO_RELAY=${_DO_MAILDEV_AUTO_RELAY:-}
  _DO_MAILDEV_OUTGOING_SECURE=${_DO_MAILDEV_OUTGOING_SECURE:-}

  _DO_MAILDEV_CMDS=${_DO_MAILDEV_CMDS:-'install start stop status logs attach help'}
}
