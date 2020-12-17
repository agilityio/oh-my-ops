_do_plugin "exec"

function test_cmd() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  {
    # Makes two executable scripts to run
    cd "$dir" &&
      echo "echo 'hello!'" > "hello.sh" &&
      chmod +x "hello.sh" &&
      mkdir "good" &&
      echo "echo 'good bye!'" > "good/bye.sh" &&
      chmod +x "good/bye.sh" &&
      _do_exec 'fakerepo' '.'
  } || _do_assert_fail

  # Test all base commands
  do-fakerepo-exec-hello || _do_assert_fail
  do-fakerepo-exec-good-bye || _do_assert_fail
}
