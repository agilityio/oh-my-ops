function _do_htpasswd_util_run() {
  local user=${1?'user arg required'}
  local pass=${2?'pass arg required'}

  # See: https://linux.die.net/man/1/htpasswd
  _do_htpasswd_util_install_if_missing || return 1

  # Generates a new htpasswd line and just print it to console output.
  docker run --rm \
    "${_DO_HTPASSWD_DOCKER_IMAGE}" \
    -nb "${user}" "${pass}" || return 1
}

