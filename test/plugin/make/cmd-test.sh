_do_plugin "make"

function test_cli() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  {
    cd "$dir" &&


    # Creates a fake make file for test
    printf "
clean:
\techo Just a clean here

build:
\techo Just a build here

install:
\techo Just a install here

test:
\techo Just a test here
" >"${dir}/Makefile"
  } || _do_assert_fail

  _do_make_cli 'fakerepo'

  # Test all base commands
  do-fakerepo-make-help || _do_assert_fail
  do-fakerepo-make-clean || _do_assert_fail
  do-fakerepo-make-install || _do_assert_fail
  do-fakerepo-make-build || _do_assert_fail
  do-fakerepo-make-test || _do_assert_fail
  do-fakerepo-make-doctor || _do_assert_fail
}
