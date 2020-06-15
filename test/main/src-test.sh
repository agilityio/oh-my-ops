function test_src() {
  local file=$(_do_src_file)
  local name=$(_do_src_name ${file})
  local dir=$(_do_src_dir ${file})

  _do_assert_eq "src-test.sh" "${name}"
  _do_assert_eq "${file}" "${dir}/${name}"
}
