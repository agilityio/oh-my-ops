function _do_arg_required() {
    local val=$1
    _do_assert $val
    echo $val
}
