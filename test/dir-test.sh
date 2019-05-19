function test_dir_random_tmp_dir() {
    local tmp_dir=$(_do_dir_random_tmp_dir)
    _do_dir_assert ${tmp_dir}
    _do_dir_assert_not "${tmp_dir}/nothing"
}