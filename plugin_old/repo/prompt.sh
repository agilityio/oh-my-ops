# Listens to "_do_prompt" event and update the list of repo aliases
# Arguments:
#   1. dir: The current directory. This is sent from prompt plugin.
#
function _do_repo_prompt_changed() {
  local dir=$1

  if [ ! -f "$dir/.do.sh" ]; then
    # Repository is not enabled for this directory
    return
  fi

  local repo=$(basename $dir)
  _do_log_info "repo" "Updates aliases for repo '${repo}'"

  # Removes all aliases begin with "repo-"
  _do_alias_remove_by_prefix "repo-"

  # Creates new aliases for the current repo
  for cmd in $(_do_alias_list "do-${repo}-"); do
    alias "repo-${cmd}"="do-${repo}-${cmd}"
  done
}
