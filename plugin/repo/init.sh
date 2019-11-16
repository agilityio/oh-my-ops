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

  # Provides alias for short commands that developer should use.
  alias _do_repo=_do_repo_dir_add
}
