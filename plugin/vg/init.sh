_do_plugin 'repo'

_do_log_level_warn "vg"

_do_src_include_others_same_dir

function _do_vg_plugin_init() {
  # Checks that the `vagrant` command is available or not.
  if ! _do_alias_feature_check "vg" "vagrant"; then
    _do_log_warn 'vg' 'Skips vg plugin because missing vagrant command.'
    return
  fi

  _do_log_info "vg" "Initialize plugin"

  # This is the default vg commands supported
  if [ -z "${DO_VG_CMDS}" ]; then
    DO_VG_CMDS='help install build start stop attach suspend resume status package validate'
  fi
}
