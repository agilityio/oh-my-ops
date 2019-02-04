
function _do_dir_push() {
    pushd $1 &> /dev/null
}

function _do_dir_pop() {
    popd &> /dev/null
}

