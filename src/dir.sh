
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

# Push the devops repository directory to directory stack. 
#
function _do_dir_home_push() {
    _do_dir_push ${DO_HOME}
}


# Generates a random temp directory
#
function _do_dir_random_tmp_dir() {
    local tmp_dir="$(mktemp -d)"
    _do_assert $tmp_dir
    echo $tmp_dir
}


function _do_dir_assert() {
    local dir=$1
    _do_assert $dir
    [ -d $dir ] || _do_assert_fail "Expected $dir a directory"
}

function _do_dir_assert_not() {
    local dir=$1
    [ ! -d $dir ] || _do_assert_fail "Expected $dir is not a directory"
}

