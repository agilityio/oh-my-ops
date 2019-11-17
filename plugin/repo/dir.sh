# Adds a new repository.
#
# Arguments:
#   1. dir: The directory to add. It must be not a parent of any
#       existing directory in the current list.
#
#   2. repo: Optional. The alias of the directory.
#       If this is missing, the alias will be set by the following rules:
#
#       a. If this is not a sub dir of any existing repository directories.
#           It will be the name of the last directory in the path.
#           For example, if the specified directory to add is :
#           `/home/someone/myprojects/lime`, then the alias would be `lime`.
#
#       b. If this is a sub dir of any existing repository directory,
#           It will be set to a combine of parent dir alias, with the
#           alias of the remain path.
#           For example, if the `home/someone/lime/proj1/src/package1`
#           is added and the `lime` alias has been already mapped to
#           `/home/someone/lime` then the new alias would be:
#           `lime-package1`. It is important to note that the `src` keyword
#           is removed from the alias in this case. In general, commonly
#           used keywords like `src`, `bin`, ... will be removed.
#
function _do_repo_dir_add() {
  local dir=${1?'dir arg required'}
  local repo=${2:-}
  shift 2

  # Normalizes the directory to physical one.
  dir=$(_do_dir_normalized "${dir}") || return 1

  _do_log_debug 'repo' "add repo '${repo}', dir: ${dir}"

  # Makes sure the existing directory does not conflicts with any
  # existing directory.
  local idx=-1
  local i=0
  local parent_dir=""

  for d in $(_do_array_print '_repo_dir'); do
    if _do_string_startswith "${d}" "${dir}"; then
      _do_assert_fail "Cannot add repo dir ${dir} because it conflicts with existing dir ${d}"
    fi

    if _do_string_startswith "${dir}" "${d}"; then
      let idx=i
      parent_dir="${d}"
    fi

    i=$((i + 1))
  done

  if [[ -z "${repo}" ]]; then
    if [[ idx -lt 0 ]]; then
      # Founds a root alias
      repo=$(basename "${dir}")
    else
      # Removes the parent dir prefix from the current dir.
      local sub_dir=${dir#"${parent_dir}"}

      # Computes the repo name from the remaining.
      repo=$(_do_string_to_alias_name "${sub_dir}")

      # builds the parent name
      local parent_repo
      parent_repo=$(_do_array_get '_repo_name' "${idx}")

      _do_array_print '_repo_name'
      echo "parent: ${parent_repo}, ${idx}"
      repo="${parent_repo}-${repo}"
    fi
  fi

  # Triggers hook so that other plugins can response to it.
  _do_hook_call 'before_repo_dir_add' "${dir}" "${repo}"

  _do_array_append '_repo_dir' "${dir}"
  _do_array_append '_repo_name' "${repo}"

  # Adds alias for quickly go to the repository directory.
  alias "do-${repo}-cd"="cd ${dir}"

  # Triggers hook so that other plugins can response to it.
  _do_hook_call 'after_repo_dir_add' "${dir}" "${repo}"
}

function _do_repo_dir_exists() {
  local dir=${1?'dir arg required'}

  dir=$(_do_dir_normalized "${dir}") || return 1

  if _do_array_exists '_repo_dir' && _do_array_contains '_repo_dir' "${dir}"; then
    return 0
  else
    return 1
  fi

}

# Lists out all directories that are currently managed.
#
# Arguments:
#  1. dir: Optional. If specified, only list out the sub directories of
#   this one. Otherwise, list out all directories.
#
function _do_repo_dir_list() {
  local dir=${1:-}

  if [[ -z "${dir}" ]]; then
    _do_array_print '_repo_dir'
  else
    # Normalizes the directory to physical one.
    dir=$(_do_dir_normalized "${dir}") || return 1

    for d in $(_do_array_print '_repo_dir'); do
      if _do_string_startswith "${d}" "${dir}"; then
        echo "${d}"
      fi
    done
  fi
}

# Lists out all repository names that are currently managed.
#
# Arguments:
#  1. name: Optional. If specified, only list out the sub names of
#   this one. Otherwise, list out all name.
#
function _do_repo_name_list() {
  local name=${1:-}

  if [[ -z "${name}" ]]; then
    _do_array_print '_repo_name'

  else
    # Givens the repository name, find its corresponding directory.
    local idx
    idx=$(_do_array_index_of '_repo_name' "${name}")
    [[ idx -ge 0 ]] || _do_assert_fail "Invalid repo name ${name}."

    local dir
    dir=$(_do_array_get '_repo_dir' "${idx}")

    # Filters the dir list by the current dir.
    # For each match, convert back from dir to name to return.
    local i=0
    for d in $(_do_array_print '_repo_dir'); do
      if _do_string_startswith "${d}" "${dir}"; then
        _do_array_get '_repo_name' "${i}"
      fi

      i=$((i + 1))
    done
  fi
}

# Lists out all directories that are currently managed.
#
# Arguments:
#  1. dir: Optional. If specified, only list out the sub directories of
#   this one. Otherwise, list out all directories.
#
function _do_repo_list() {
  local dir=${1:-}

  local name
  local i=0

  if [[ -z "${dir}" ]]; then
    for d in $(_do_array_print '_repo_dir'); do
      name=$(_do_array_get '_repo_name' "${i}")
      echo "${d} ${name}"
      i=$((i + 1))
    done
  else
    # Normalizes the directory to physical one.
    dir=$(_do_dir_normalized "${dir}") || return 1

    for d in $(_do_array_print '_repo_dir'); do
      if _do_string_startswith "${d}" "${dir}"; then
        name=$(_do_array_get '_repo_name' "${i}")
        echo "${d} ${name}"
      fi
      i=$((i + 1))
    done
  fi
}

# Givens a directory, return the parent repository directory.
#
function _do_repo_get() {
  local dir=${1?'dir arg required'}

  # Normalizes the directory to physical one.
  dir=$(_do_dir_normalized "${dir}") || return 1

  # Makes sure the existing directory does not conflicts with any
  # existing directory.
  local idx=-1
  local i=0

  for d in $(_do_array_print '_repo_dir'); do
    if _do_string_startswith "${dir}" "${d}"; then
      let idx=i
    fi

    i=$((i + 1))
  done

  [[ idx -ge 0 ]] || _do_assert_fail "could not found repo for dir ${dir}"

  # Founds a sub alias
  dir=$(_do_array_get '_repo_dir' "${idx}")

  local name
  name=$(_do_array_get '_repo_name' "${idx}")

  echo "${dir} ${name}"
}

# Givens a directory, return the parent repository directory.
#
function _do_repo_dir_get() {
  local name=${1?'name arg required'}

  # Makes sure the existing directory does not conflicts with any
  # existing directory.

  local dir
  local i=0
  for n in $(_do_array_print '_repo_name'); do
    if [[ "${name}" == "${n}" ]]; then
      # Founds the repository
      dir=$(_do_array_get '_repo_dir' "${i}")
      echo "${dir}"
      return
    fi

    i=$((i + 1))
  done

  _do_assert_fail "Invalid repo name: ${name}"
}
