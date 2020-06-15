function test_dir_random_tmp_dir() {
  local tmp_dir=$(_do_dir_random_tmp_dir)
  _do_dir_assert ${tmp_dir}
  _do_dir_assert_not "${tmp_dir}/nothing"
}

function test_push_pop_home() {
  _do_dir_home_push

  local tmp_dir=$(_do_dir_random_tmp_dir)
  _do_dir_push "${tmp_dir}"
  _do_dir_pop

  _do_dir_pop
}

function test_normalized() {
  mkdir -p 'test1'

  _do_dir_normalized 'test1' | grep '/test1' || _do_assert_fail
  _do_dir_normalized './test1' | grep '/test1' || _do_assert_fail
  _do_dir_normalized "$(pwd)/test1" | grep '/test1' || _do_assert_fail
}
