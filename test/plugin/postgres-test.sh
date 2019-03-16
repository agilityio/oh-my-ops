function test_do_postgres() {
    # Removes the image
    local img=${_DO_POSTGRES_DOCKER_IMG}
    docker rmi ${img}
    _do_docker_assert_image_not_exists ${img}

    # Rebuilds it
    _do_postgres_docker_build
    _do_docker_assert_image_exists ${img}

    # Starts postgres deamon
    _do_postgres_start
    _do_docker_assert_process_exists ${img}

    # Stops postgres deamon
    _do_postgres_stop
    _do_docker_assert_process_not_exists ${img}
}
