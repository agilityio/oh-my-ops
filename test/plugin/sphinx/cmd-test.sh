_do_plugin "sphinx"

function test_common_commands() {
  local dir
  #  dir=$(_do_dir_random_tmp_dir)
  dir="${DO_HOME}/.test/sphinx"
  rm -rfd "${dir}"
  mkdir -p "${dir}"

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_sphinx 'fakerepo'

  echo "
  Welcome to sphinx.
  ==================
  " >"${dir}/index.rst"

  echo "
import sphinx_rtd_theme

project = 'Hello'
copyright = '2020, AgilityIO'
author = 'Trung'

extensions = [
    'sphinx_rtd_theme',
]
exclude_patterns = []

html_theme = 'sphinx_rtd_theme'
  " >>"${dir}/conf.py"

  # Prints out help
  do-fakerepo-sphinx-help || _do_assert_fail

  # Builds the sphinx command
  # shellcheck disable=SC2086
  do-fakerepo-sphinx-install || _do_assert_fail
  do-fakerepo-sphinx-status || _do_assert_fail
  do-fakerepo-sphinx-build || _do_assert_fail
}
