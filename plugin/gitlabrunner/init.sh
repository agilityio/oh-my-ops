_do_plugin 'docker'
_do_plugin 'repo'
_do_plugin 'gitlab'

_do_log_level_warn 'gitlabrunner'
_do_src_include_others_same_dir

# Initializes gitlabrunner plugin.
# See: https://docs.gitlab.com/runner/
function _do_gitlabrunner_plugin_init() {
  _do_log_info 'gitlabrunner' 'Initialize plugin'

  # This is the default gitlabrunner version to run with.
  _DO_GITLABRUNNER_VERSION=${_DO_GITLABRUNNER_VERSION:-"latest"}

  # See: https://docs.gitlab.com/runner/executors/README.html
  _DO_GITLABRUNNER_EXECUTOR=${_DO_GITLABRUNNER_EXECUTOR:-"docker"}

  # Additional settings when executor is docker
  _DO_GITLABRUNNER_EXECUTOR_DOCKER_IMAGE=${_DO_GITLABRUNNER_EXECUTOR_DOCKER_IMAGE:-'alpine'}
}
