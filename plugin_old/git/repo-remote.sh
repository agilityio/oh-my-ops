_do_log_level_warn "git-remote"

# This function is a util function to compute the remote uri for a given
# repository and remote name.
# Arguments:
#   1. proj_dir: The project repository
#   2. repo: The repository
#   3. remote: The remote name.
#
function _do_git_repo_get_remote_uri() {
  local proj_dir=${1?'proj_dir arg required.'}
  local repo=${2?'repo arg required'}
  local remote=${3?'remote arg required'}

  # Makes sure that the default repository is available for the current project
  local default_repo=$(_do_proj_repo_get_default ${proj_dir})
  _do_assert "${default_repo}"

  _do_repo_dir_push "${proj_dir}" "${default_repo}"

  # Remove the last .git
  # For example, if a remote is ssh://git@bitbucket.org/abc/devops.git
  # The result would be ssh://git@bitbucket.org/abc
  # local uri=$( git config --local --get "remote.${remote}.url" | sed -e 's/\/[^\/]*\.git$//' )
  local uri=$(git config --local --get "remote.${remote}.url" | sed -e "s/${default_repo}.git$/${repo}.git/")

  _do_dir_pop

  if [ -z "$uri" ]; then
    echo ""
    return 1
  else
    echo ${uri}
    return 0
  fi
}

# Gets the list of all remotes registered for the specified repositories.
#
function _do_git_repo_get_remote_list() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  _do_repo_dir_push $proj_dir $repo

  git remote

  _do_dir_pop
}

# Gets the default git remote list available
# at devops repository.
#
function _do_git_get_default_remote_list() {
  local proj_dir=${1?'proj_dir arg required.'}
  local repo=$(_do_proj_repo_get_default "${proj_dir}")

  _do_git_repo_get_remote_list "${proj_dir}" "${repo}"
}

# Fetch changes from a git remote.
# Arguments:
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_remote_fetch() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}
  local remote=${3?'remote arg required'}

  local title="${repo}: Git fetch '${remote}'"
  _do_print_header_2 "${title}"

  # Runs the actual fetch command.
  _do_repo_cmd $proj_dir $repo "git fetch $remote"

  local err=$?
  _do_error_report ${err} "${title}"
  return $err
}

# Pull changes from a git remote.
# Arguments:
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_remote_pull() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}
  local remote=${3?'remote arg required'}

  local branch=$(_do_git_repo_get_branch $proj_dir $repo)

  local title="${repo}: Git pull '${remote}' at branch ${branch}"
  _do_print_header_2 "${title}"

  _do_repo_cmd $proj_dir $repo "git pull $remote $branch"

  local err=$?
  _do_error_report ${err} "${title}"
  return $err
}

# Sync changes from a git remote.
# Arguments:
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_git_repo_remote_sync() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}
  local remote=${3?'remote arg required'}

  # Display header.
  local title="${repo}: Git sync '${remote}' at branch ${branch}"
  _do_print_header_2 "${title}"

  # Don't allow to sync dirty git repository.
  if _do_git_repo_is_dirty $proj_dir $repo; then
    _do_print_error "Repository is dirty. Please commit first."
    return 1
  fi

  _do_repo_dir_push $proj_dir $repo

  # Gets the current repository git branch.
  # We will sync this branch with the remote repository.
  local branch=$(_do_git_repo_get_branch $proj_dir $repo)

  # Pull all changes to remote repository
  _do_print_line_1 "git pull ${remote} ${branch}"
  git pull $remote $branch
  local err=$?

  if _do_error $err; then
    _do_print_warn "Cannot pull changes from $remote $branch"
  fi

  # Push all changes to remote repository
  _do_print_line_1 "git push ${remote} ${branch}"
  git push $remote $branch

  err=$?
  _do_error_report ${err} "${title}"
  _do_dir_pop

  return $err
}

# Listens to event that initializes a repository and adding aliases
# for git commands support. For example, for 'devops' repository,
# the following git aliases might be registered.
#   'devops-git-fetch-origin'
#       For fetch latest code from origin remote.
#
#   'devops-git-pull-origin'
#       For pull changes from origin remote.
#
#   'devops-git-sync-origin'
#       For sync code with origin remote.
#
function _do_git_repo_remote_init() {
  local proj_dir=${1?'proj_dir arg required'}
  local repo=${2?'repo arg required'}

  # For all git remotes, register additional command such as git fetch, git sync, ...
  for remote in $(_do_git_repo_get_remote_list $proj_dir $repo); do
    _do_log_info "git-remote" "Initialize git remote for '$remote'"

    # Triggers hook for additional extensions if any.
    _do_hook_call "_do_git_repo_remote_init" $proj_dir $repo $remote

    # Register git remote commands
    local names=("fetch" "pull" "sync")
    local name
    for name in ${names[@]}; do
      local cmd="${repo}-git-${name}-${remote}"

      _do_log_debug "git-remote" "  Register '$cmd' alias"
      alias "${cmd}"="_do_git_repo_remote_${name} ${proj_dir} ${repo} ${remote}"
    done
  done
}

function _do_git_proj_remote_cmd() {
  local cmd=$1
  local remote=$2
  _do_proj_exec_all_repo_cmds "$(_do_proj_default_get_dir)" "git-${cmd}-${remote}"
  return $?
}
