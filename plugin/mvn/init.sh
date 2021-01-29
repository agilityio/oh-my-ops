_do_plugin 'repo'

_do_log_level_warn "mvn"

_do_src_include_others_same_dir

function _do_mvn_plugin_init() {
  # Checks that the `mvn` command is available or not.
  if ! _do_alias_feature_check "mvn" "mvn"; then
    _do_log_warn 'mvn' 'mvn command is missing. Please install maven!'
  fi

  _do_log_info "mvn" "Initialize plugin"


  # This is the default mvn commands supported
  if [ -z "${DO_MVN_CMDS}" ]; then
    DO_MVN_CMDS='help install clean build test package validate verify deploy'
  fi
}
