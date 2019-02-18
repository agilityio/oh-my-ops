# Retrieved a required argument.
function _do_arg_required() {
    local val=$1
    _do_assert $val
    echo $val
}


# Retrieves a directory and normalized it
#
function _do_arg_dir() {
    local dir=$(_do_arg_required $@)
    echo $(_do_dir_normalized $dir)
}
