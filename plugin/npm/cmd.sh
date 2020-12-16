# Runs an npm command at the specified directory.
#
# Arguments:
# 1. dir: The absolute directory to run the command.
# 2. repo: The repo name
#
# 3. cmd: The command to run.
#   * install: Installs the dependencies specified in package.json.
#
#   * start: For start any nodejs program. This command must be defined in
#       package.json file. Running this will automatically trigger 'install'
#       if the `node_modules directory is not there.`
#
#   * clean: For cleaning up build artifacts. This command must be defined
#       in package.json file.
#
#   * build: For building up the package. This command must be defined in
#       package.json file. Running this will automatically trigger `install`
#       command if the `node_modules` directory is not there.
#
#   * test: For testing the package. This command must be defined in
#       package.json file. Running this will automatically trigger `install`
#       command if the `node_modules` directory is not there.
#
#   * link, unlink: for link or unlink local packages.
#
#   * publish, unpublish: For working with publish/unpublish package to remote
#       package management server (e.g., npmjs, artifactory, etc).
#
#   It is ok to put any command, as long as it is defined in the package.json.
#
function _do_npm_repo_cmd() {
  local err=0
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}

  shift 3
  local opts=""

  _do_dir_push "${dir}" || return 1

  {
    {
      # For command that is not the default npm one,
      # we need to append the "run" in front to run it with run script.
      [ "${cmd}" == "start" ] ||
        [ "${cmd}" == "install" ] ||
        [ "${cmd}" == "link" ] ||
        [ "${cmd}" == "unlink" ] ||
        [ "${cmd}" == "publish" ] ||
        [ "${cmd}" == "unpublish" ] ||
        cmd="run ${cmd}"
    } &&
      {
        # If node module is not available, install node module.
        [ "${cmd}" == "install" ] ||
          [ -d "./node_modules" ] ||
          npm install
      } &&

      npm ${cmd} $@ &&
      {
        # In the case of link command, we need some special handling
        {
          [ ! "${cmd}" == "link" ] &&
            [ ! "${cmd}" == "unlink" ]
        } ||
          {
            # For unlink command, add --no-save opts to avoid overwrite package.json
            # by accident.
            [ ! "${cmd}" == "unlink" ] || opts=" --no-save"

            # Gets the links specification from .do.yml
            local links
            links="$(_do_repo_conf_var_name "${dir}" "npm.link")[@]"

            for link in ${!links}; do
              # Links additional repository
              _do_print_line_1 "${cmd} ${link}"

              # shellcheck disable=SC2086
              npm ${cmd} ${opts} ${link}
            done
          }
      }
  } || {
    err=1
  }

  _do_dir_pop
  return ${err}
}
