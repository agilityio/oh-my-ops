
function _do_dir_push() {
    pushd $1 &> /dev/null
}

function _do_dir_pop() {
    popd &> /dev/null
}

function _do_dir_normalized() {
    _do_dir_push $1 
    echo $(pwd)
    _do_dir_pop
}
