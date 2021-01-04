# See: https://github.com/atmoz/jupyter

_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'jupyter'
_do_src_include_others_same_dir

# Initializes jupyter plugin.
#
function _do_jupyter_plugin_init() {
  _do_log_info 'jupyter' 'Initialize plugin'

  # This is the default jupyter version to run with.
  _DO_JUPYTER_VERSION=${_DO_JUPYTER_VERSION:-'latest'}

  # This is the default jupyter port.
  _DO_JUPYTER_PORT=${_DO_JUPYTER_PORT:-8888}

  # This is the default database created, and credential to access it.
  _DO_JUPYTER_USER=${_DO_JUPYTER_USER:-user}
  _DO_JUPYTER_PASS=${_DO_JUPYTER_PASS:-pass}

  _DO_JUPYTER_CMDS=${_DO_JUPYTER_CMDS:-'install start stop status logs attach help'}
}
