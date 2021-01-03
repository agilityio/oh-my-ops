_do_plugin 'jq'
_do_plugin 'curl'
_do_plugin 'hostfile'
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

  # The API version to work with.
  # https://docs.gitlab.com/ce/api/
  _DO_GITLAB_API_VERSION=${_DO_GITLAB_API_VERSION:-"v4"}

  # This is the default gitlab port.
  _DO_GITLAB_HTTP_PORT=${_DO_GITLAB_HTTP_PORT:-8280}
  _DO_GITLAB_HTTPS_PORT=${_DO_GITLAB_HTTPS_PORT:-16443}

  # Notes that gitlab ssh port is a non-standard one.
  # Might need special setting
  _DO_GITLAB_SSH_PORT=${_DO_GITLAB_SSH_PORT:-2222}

  # The gitlab root user cannot be changed.
  # This is just the place holder just in case this can be changed later.
  _DO_GITLAB_USER=${_DO_GITLAB_USER:-root}

  # Default root password for gitlab.
  # It is required to have capital case, special characters. etc.
  _DO_GITLAB_PASS=${_DO_GITLAB_PASS:-"Password@123"}

  # This key will be added to gitlab on start command.
  _DO_GITLAB_RSA_PUB_KEY=${_DO_GITLAB_RSA_PUB_KEY:-"~/.ssh/id_rsa.pub"}
}
