_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'gitlab'
_do_src_include_others_same_dir

# Initializes gitlab plugin.
#
function _do_gitlab_plugin_init() {
  _do_log_info 'gitlab' 'Initialize plugin'

  # This is the default gitlab version to run with.
  _DO_GITLAB_VERSION=${_DO_GITLAB_VERSION:-"latest"}

  # This is the default gitlab port.
  _DO_GITLAB_HTTP_PORT=${_DO_GITLAB_HTTP_PORT:-8280}
  _DO_GITLAB_HTTPS_PORT=${_DO_GITLAB_HTTPS_PORT:-16443}
  _DO_GITLAB_SSH_PORT=${_DO_GITLAB_SSH_PORT:-2222}

  # This is the default database created, and credential to access it.
  _DO_GITLAB_USER=${_DO_GITLAB_USER:-root}
  _DO_GITLAB_PASS=${_DO_GITLAB_PASS:-pass}
}
