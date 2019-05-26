_do_plugin "yaml"

_do_log_level_warn "yaml"
_do_src_include_others_same_dir


# ==============================================================================
# Plugin Init
# ==============================================================================


# Initializes yaml plugin.
#
function _do_yaml_plugin_init() {
    if ! _do_alias_feature_check "yaml" "sed" "awk"; then 
        return 
    fi 

    _do_src_include_others_same_dir

    _do_log_info "yaml" "Initialize plugin"
}
