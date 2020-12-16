_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'sphinx'
_do_src_include_others_same_dir

# Initializes sphinx plugin.
#
function _do_sphinx_plugin_init() {
  _do_log_info 'sphinx' 'Initialize plugin'

  # This is the default sphinx version to run with.
  _DO_SPHINX_VERSION=${_DO_SPHINX_VERSION:-3.3.1}

  # This is the sphinx default sphinx port to run
  _DO_SPHINX_PORT=${_DO_SPHINX_PORT:-8383}

  # This is the default "Read The Docs" theme version to run with.
  _DO_SPHINX_RTD_THEME_VERSION=${_DO_SPHINX_RTD_THEME_VERSION:-0.5.0}

  # Default output format is html & epub.
  _DO_SPHINX_OUT_FORMAT=${_DO_SPHINX_OUT_FORMAT:-html epub}
}
