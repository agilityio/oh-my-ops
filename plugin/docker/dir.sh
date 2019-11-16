function _do_docker_dir_resolved() {
  local dir=$1

  dir=$(_do_dir_normalized $dir)

  if _do_os_is_win; then
    if which cygpath &>/dev/null; then
      # if cygpath is there, use it to resolve the actual
      # directory on windows.
      dir=$(cygpath -m ${dir})
    fi

    _do_dir_assert $dir
  fi

  echo "${dir}"
}
