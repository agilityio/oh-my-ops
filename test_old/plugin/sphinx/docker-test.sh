_do_plugin "sphinx"

img=${_DO_SPHINX_DOCKER_IMG}

function test_do_sphinx_docker() {
  # Removes the docker image.
  _do_sphinx_clean
  _do_docker_image_assert_not_exists ${img}

  # Rebuilds the docker image.
  _do_sphinx_build_ensured
  _do_docker_image_assert_exists ${img}
}
