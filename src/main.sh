function __do_main_activate_file() {
  # Gets the first file that activate everything.
  local n=${#BASH_SOURCE[@]}
  ((n--))
  local src="${BASH_SOURCE[$n]}"

  # Gets the file name
  local name
  name=$(basename "$src")

  # Gets the directory
  local dir
  dir=$(dirname "$src")

  # Normalizes the directory
  pushd "$dir" &> /dev/null || exit
  dir=$(pwd)
  popd &> /dev/null || exit

  # Prints out the absolute script that activate everything.
  echo "${dir}/${name}"
}

# This is the file that activates the whole thing.
# This is useful in the case we need to open more terminal
# starting from this root file. (e.g., see tmux plugin)
# shellcheck disable=SC2034
DO_ACTIVATE_FILE=$(__do_main_activate_file)


# Figures out which operating system we are on.
DO_OS="$(uname -s)"

case "${DO_OS}" in
Linux*) DO_OS=linux ;;
Darwin*) DO_OS=mac ;;
CYGWIN*) DO_OS=cygwin ;;
*)
  echo "Sorry! We don't support '$(uname)' operating system yet. Please hang on tight!"
  return
  ;;
esac

# The remaining arguments that cannot be parsed.
_DO_MAIN_ARGS=()

# Plugins system should be loaded
_DO_PLUGINS_ENABLED="yes"

# Boots up the framework fastest possible.
_DO_MAIN_QUICK="no"

# Parse input arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
  -nl | --no-log)
    _DO_NO_LOG="yes"
    shift
    ;;
  -np | --no-plugins)
    _DO_PLUGINS_ENABLED="no"
    shift
    ;;

  -q | --quick)
    _DO_MAIN_QUICK="yes"
    shift
    ;;

  *) # unknown option
    _DO_MAIN_ARGS+=("$1") # save it in an array for later
    shift                 # past argument
    ;;
  esac
done

# Checks if the current shell is bash
if [ "${_DO_MAIN_QUICK}" == "no" ]; then
  if ! echo "$0" | grep -q "bash"; then
    echo "Only support bash! Please executes 'bash' to change to bash shell instead."
    return
  fi
fi

# Loads core libraries
src_files=(
  "version"
  "os"
  "src"
  "dir"
  "file"
  "string"
  "set"
  "array"
  "stack"
  "vlistmap"
  "alias"
  "color"
  "print"
  "trap"
  "assert"
  "uuid"
  "log"
  "error"
  "alias"
  "hook"
  "curl"
  "browser"
  "timer"
  "plugin"
)

# Loads all core source files.
for src_file in "${src_files[@]}"; do
  source "${DO_HOME}/src/${src_file}.sh"
done

_do_timer_start

_do_log_level_warn "main"

if [ "${_DO_PLUGINS_ENABLED}" == "yes" ]; then
  if [ -z "${DO_PLUGINS}" ]; then
    _do_log_debug "main" "load all plugins"

    # Loads all plugins.
    for plugin in $(ls -A ${DO_HOME}/plugin); do
      _do_plugin $(_do_file_name_without_ext $plugin)
    done

  else
    _do_log_debug "main" "load just specified plugins"
    # Just loads the specified plugins.
    _do_plugin "${DO_PLUGINS}"
  fi
fi

# Initializes all plugins registered
_do_plugin_init

echo "Activated in $(_do_timer_end) seconds."
