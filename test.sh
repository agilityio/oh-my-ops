export DO_ENVS="local dev prod"

source ./activate.sh --quick --no-log --plugins

_do_test $@
