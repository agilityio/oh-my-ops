_do_plugin "docker-compose"

function test_build_run() {

  # Makes a new docker-compose file to test. This file extends
  # from the well-known hello-world docker-compose image.
  local dir
  dir="$(_do_dir_random_tmp_dir)"

  _do_repo "${dir}" 'fakerepo'

  echo """
version: \"3\"
services:
  hello-world:
    image: hello-world
""" > "$dir/docker-compose.yml"

  _do_docker_compose 'fakerepo'

  # Builds the docker-compose command
  do-fakerepo-docker-compose-build || _do_assert_fail

  # Builds the docker-compose command
  do-fakerepo-docker-compose-start || _do_assert_fail
}

