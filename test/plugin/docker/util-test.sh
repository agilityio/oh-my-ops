_do_plugin "docker"


function test_build_run() {

  # Makes a new docker file to test. This file extends
  # from the well-known hello-world docker image.
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  echo """
  FROM hello-world
  """ > "$tmp_dir/Dockerfile"

  local n
  n="do_test_helloworld"

  # Builds the docker command
  _do_docker_util_build "$tmp_dir" "$n" || _do_assert_fail

  # The run it.
  _do_docker_util_run "$n" || _do_assert_fail
}

