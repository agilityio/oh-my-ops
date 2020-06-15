_do_plugin "go"

function test_cli() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  {
    cd "$dir" &&
    echo '
    module fakerepo.com/m/v1
go 1.13

require rsc.io/quote v1.5.2
    ' > "${dir}/go.mod" &&
    echo '
package main

import (
	"fmt"
)

//go:generate echo "Go generate has been called"
func main() {
	fmt.Println("Hello, playground")
}
' > "${dir}/hello.go"
  } || _do_assert_fail

  _do_go_cli 'fakerepo'

  # Test all base commands
  do-fakerepo-go-help || _do_assert_fail
  do-fakerepo-go-clean || _do_assert_fail
  # do-fakerepo-go-install || _do_assert_fail

  do-fakerepo-go-get "rsc.io/quote" || _do_assert_fail
  do-fakerepo-go-mod "tidy" || _do_assert_fail
  do-fakerepo-go-tidy || _do_assert_fail

  do-fakerepo-go-build || _do_assert_fail
  do-fakerepo-go-gen || _do_assert_fail
  do-fakerepo-go-test || _do_assert_fail
  do-fakerepo-go-start || _do_assert_fail
  do-fakerepo-go-doctor || _do_assert_fail
}
