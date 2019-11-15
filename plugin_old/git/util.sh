
# Gets the git root directory of the current dir
#
function _do_git_util_get_root() {
    local dir=$(git rev-parse --show-toplevel)
    local err=$?

    if _do_error $error; then
        echo ""
    else
        echo "$dir"
    fi
}
