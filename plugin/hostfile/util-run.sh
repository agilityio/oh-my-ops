# Runs the goodhosts command line
# See: https://github.com/goodhosts/cli
function _do_hostfile_util_run() {
  _do_hostfile_util_install_if_missing || return 1

  # shellcheck disable=SC2068
  [[ -f "${_DO_HOSTFILE_BACKUP}" ]] || cp "/etc/hosts" "${_DO_HOSTFILE_BACKUP}" || {
    _do_log_error 'hostfile' "Failed to backup /etc/hosts to ${_DO_HOSTFILE_BACKUP}."
    return 1
  }

  # shellcheck disable=SC2068
  docker run --rm -i \
    -v "/etc/hosts:/etc/hosts" \
    -v "${_DO_HOSTFILE_BACKUP}:/data/.hosts.bak" \
    "${_DO_HOSTFILE_DOCKER_IMAGE}" goodhosts $@  || return 1
}

# Determines if the specified host name or ip exists.
# Arguments:
# 1. host_or_ip: A host name or ip.
function _do_hostfile_util_host_exists() {
  local host_or_ip=${1?'host_or_ip arg required.'}
  _do_hostfile_util_run 'check' "${host_or_ip}" &> /dev/null || return 1
}

# Creates a new host entry in the /etc/hosts file.
# Arguments:
# 1. ip: The ip to be added.
# 2. host: The host name of the ip.
#
function _do_hostfile_util_create_host() {
  local ip=${1?'ip arg required.'}
  local host=${2?'host arg required.'}
  _do_hostfile_util_run 'add' "${ip}" "${host}" &> /dev/null || return 1
}

# Removes a host name from the /etc/hosts file.
# Arguments:
# 1. ip: The ip to be added.
# 2. host: The host name of the ip.
#
function _do_hostfile_util_remove_host() {
  local host=${1?'host arg required.'}
  _do_hostfile_util_run 'rm' "${host}" &> /dev/null || return 1
}

# Backup the existing /etc/hosts file.
#
function _do_hostfile_util_backup() {
  _do_hostfile_util_run 'backup --output /data/.hosts.bak' &> /dev/null || return 1
}

# Restores the previously backed up /etc/hosts file.
#
function _do_hostfile_util_restore() {
  _do_hostfile_util_run 'restore --input /data/.hosts.bak' &> /dev/null || return 1
}

# Creates a new host entry in the /etc/hosts file, if the host name cannot be found.
# Arguments:
# 1. ip: The ip to be added.
# 2. host: The host name of the ip.
#
function _do_hostfile_util_create_host_if_missing() {
  local ip=${1?'ip arg required.'}
  local host=${2?'host arg required.'}

  _do_hostfile_util_host_exists "${host}" ||
    _do_hostfile_util_create_host "${ip}" "${host}" || return 1
}

function _do_hostfile_util_create_docker_host_if_missing() {
  _do_hostfile_util_create_host_if_missing "${_DO_DOCKER_HOST_IP}" "${_DO_DOCKER_HOST_NAME}" || return 1
}
