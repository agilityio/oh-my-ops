# See: https://github.com/atmoz/jenkins

_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'jenkins'
_do_src_include_others_same_dir

# Initializes jenkins plugin.
#
function _do_jenkins_plugin_init() {
  _do_log_info 'jenkins' 'Initialize plugin'

  # This is the default jenkins version to run with.
  _DO_JENKINS_VERSION=${_DO_JENKINS_VERSION:-'lts'}

  # This is the default jenkins port.
  _DO_JENKINS_UI_PORT=${_DO_JENKINS_UI_PORT:-9080}
  _DO_JENKINS_SLAVE_PORT=${_DO_JENKINS_SLAVE_PORT:-50000}

  # This is the default database created, and credential to access it.
  _DO_JENKINS_USER=${_DO_JENKINS_USER:-user}
  _DO_JENKINS_PASS=${_DO_JENKINS_PASS:-pass}

  _DO_JENKINS_CMDS=${_DO_JENKINS_CMDS:-'install start stop status logs attach help'}
}
