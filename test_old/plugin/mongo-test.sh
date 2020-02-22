_do_plugin "mongo"

function test_do_mongo() {
  # Removes the image
  local img=${_DO_MONGO_DOCKER_IMG}
  docker rmi ${img}
  _do_docker_image_assert_not_exists ${img}

  # Rebuilds it
  _do_mongo_docker_build
  _do_docker_image_assert_exists ${img}

  # Starts mongo deamon
  _do_mongo_start
  _do_docker_container_assert_exists ${img}

  # Stops mongo deamon
  _do_mongo_stop
  _do_docker_container_assert_not_exists ${img}
}
