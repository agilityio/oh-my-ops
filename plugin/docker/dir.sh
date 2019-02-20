
function _do_docker_dir_normalized() {
    local dir=$1

    if [ "${DO_OS}" == "cygwin" ]; then 
        dir=$(cygpath -m $dir)
    fi

    echo "${dir}"
}
