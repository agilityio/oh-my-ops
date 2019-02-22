img=${_DO_GO_DOCKER_IMG}


function test_docker_build() {
    # Removes the docker image.
    _do_go_clean
    _do_docker_assert_image_not_exists ${img}

    # Rebuilds the docker image.
    _do_go_build_ensured
    _do_docker_assert_image_exists ${img}
}
