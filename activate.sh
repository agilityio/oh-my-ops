# The array of plugin name to be included. If this variable is not specified
# all plugins found will be included by default.
# DO_PLUGINS="proj git prompt"

# The array of plugin name to be excluded. This list have higher priority
# than the above plugins list.
# DO_PLUGINS_EXCLUDED=slack

# The array of environment names.
# DO_ENVS="local dev prod"

# The home directory of the devops repository.
DO_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# Activates the main source file.
# shellcheck source=src/main.sh
# shellcheck disable=SC2068
source "$DO_HOME/src/main.sh" $@
