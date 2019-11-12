export DO_ENVS="local dev prod"

export DO_PLUGINS=test
source ./activate.sh --quick --no-log --plugins

_do_test $@
