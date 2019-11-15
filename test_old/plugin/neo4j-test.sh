_do_plugin "neo4j"

function test_do_neo4j() {
    local img=${_DO_NEO4J_DOCKER_IMG}
    
    _do_neo4j_stop

    # Removes the image
    _do_neo4j_clean
    _do_docker_assert_image_not_exists ${img}

    # Rebuilds it
    _do_neo4j_build
    _do_docker_assert_image_exists ${img}

    # Starts neo4j deamon
    _do_neo4j_start
    _do_docker_assert_process_exists ${img}

    # Stops neo4j deamon
    _do_neo4j_stop
    _do_docker_assert_process_not_exists ${img}
}
