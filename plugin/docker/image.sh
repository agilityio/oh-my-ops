# Checks if the specified docker image exists or not.
#
function _do_docker_image_exists() {
    local img=$1
    if [[ "$(docker images -q ${img} 2> /dev/null)" == "" ]]; then 
        return 1
    else 
        return 0
    fi
}


# Asserts that the docker image exists.
#
function _do_docker_assert_image_exists() {
    local img=$1
    _do_docker_image_exists $img || _do_assert_fail "Expected docker image '${img}' exists"
}


# Asserts that the docker image does not exist.
function _do_docker_assert_image_not_exists() {
    local img=$1
    ! _do_docker_image_exists $img || _do_assert_fail "Expected docker image '${img}' not exists"
}

function _do_docker_image_remove() {
    local img=$1

    if _do_docker_image_exists $img; then 
        docker rmi ${img}
        return $?
    fi 
}
