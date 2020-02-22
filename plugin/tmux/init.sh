_do_plugin 'repo'

_do_log_level_warn "tmux"

_do_src_include_others_same_dir

function _do_tmux_plugin_init() {
  if ! _do_alias_feature_check "tmux" "tmux"; then
    _do_log_warn 'tmux' 'Skips tmux plugin because missing tmux command.'
    return
  fi

  _do_log_info "tmux" "Initialize plugin"
}
