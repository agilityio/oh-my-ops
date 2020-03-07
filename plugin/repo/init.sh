# Repository Plugin
# ------------------
#
# This plugin helps:
#   - Help to organizes a tree of aliases.
#   - Each alias can be mapped to a physical directory on disk.
#   - The root element of the tree will be named 'all.
#

_do_log_level_warn 'repo'
_do_src_include_others_same_dir

# Initializes the repo plugin.
#
function _do_repo_plugin_init() {
  _do_log_info 'repo' 'Initialize plugin.'

  _do_array_new '_repo_dir'
  _do_array_new '_repo_name'

  # Provides alias for short commands that developer should use.
  alias _do_repo=_do_repo_dir_add

  # Initializes common commands.
  # These are the base life-cycle commands that commonly found in any
  # project.
  if [ -z "${DO_REPO_BASE_CMDS}" ]; then
    DO_REPO_BASE_CMDS='status help clean install build doc test'
  fi

  # Provides some additional comands for apis development.
  if [ -z "${DO_REPO_API_CMDS}" ]; then
    DO_REPO_API_CMDS="${DO_REPO_BASE_CMDS} run package deploy"
  fi

  # Provides some additional commands for web app development.
  if [ -z "${DO_REPO_WEB_APP_CMDS}" ]; then
    DO_REPO_WEB_APP_CMDS="${DO_REPO_BASE_CMDS} run package deploy"
  fi

  # Provides some additional commands for mobile app development.
  if [ -z "${DO_REPO_MOBILE_APP_CMDS}" ]; then
    DO_REPO_MOBILE_APP_CMDS="${DO_REPO_BASE_CMDS} build:ios build:android run:ios run:android package deploy"
  fi

  # Provides some additional for a full project development.
  if [ -z "${DO_REPO_PROJ_CMDS}" ]; then
    DO_REPO_PROJ_CMDS="${DO_REPO_BASE_CMDS} package deploy"
  fi
}
