export DO_ENVS="local dev prod"

export DO_PLUGINS=test
source ./activate.sh --quick --no-log --plugins



# shellcheck disable=SC2068
_do_test $@
