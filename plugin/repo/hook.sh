# Calls a repository hook with the specified arguments.
#
# Arguments:
#   1. dir: The repository dir.
#   2. repo: The repository name.
#   3. plugin: The plugin to call.
#   4. cmd: The command to call.
#
function _do_repo_plugin_cmd_hook_call() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local plugin=${3?'plugin arg required'}
  local cmd=${4?'cmd arg required'}
  shift 4

  local hook="do-${repo}-${plugin}-${cmd}"
  hook=$(_do_string_to_dash "${hook}")

  _do_hook_call "${hook}" "${dir}" "${repo}" "${cmd}" $@
}


# Adds a hook before the plugin command execution.
#
# Arguments:
#   1. repo: The repository name to add.
#   2. plugin: The plugin to add this hook to.
#   3. cmd: The plugin command to hook.
#
# An example of such usage is before build any flutter program, we might
# want to add custom code to generate source code before that.
#
function _do_repo_plugin_cmd_hook_before() {
  local repo=${1?'repo arg required'}
  local plugin=${2?'plugin arg required'}
  local cmd=${3?'cmd arg required'}
  local func=${4?'func arg required'}

  local hook="do-${repo}-${plugin}-${cmd}"
  hook=$(_do_string_to_dash "${hook}")

  _do_hook_before "${hook}" "${func}"
}

# Adds a hook before a plugin command execution.
#
# Arguments:
#
#   1. repo: The repository name to add.
#   2. plugin: The plugin to add this hook to.
#   3. cmd: The plugin command to hook.
#
# An example of such usage is before adding any new repository, we might
# want to detech if that is a git repository and automatically add git
# commands to it.
#
function _do_repo_plugin_cmd_hook_after() {
  local repo=${1?'repo arg required'}
  local plugin=${2?'plugin arg required'}
  local cmd=${3?'cmd arg required'}
  local func=${4?'func arg required'}

  local hook="do-${repo}-${plugin}-${cmd}"
  hook=$(_do_string_to_dash "${hook}")

  _do_hook_after "${hook}" "${func}"
}

# Just removes a function from an existing hook.
#
function _do_repo_plugin_cmd_hook_remove() {
  local repo=${1?'repo arg required'}
  local plugin=${2?'plugin arg required'}
  local cmd=${3?'cmd arg required'}
  local func=${4?'func arg required'}

  local hook="do-${repo}-${plugin}-${cmd}"
  hook=$(_do_string_to_dash "${hook}")

  _do_hook_remove "${hook}" "${func}"
}
