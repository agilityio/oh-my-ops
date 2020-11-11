_do_plugin 'repo'

_do_log_level_warn "firebase"

_do_src_include_others_same_dir

function _do_firebase_plugin_init() {
  # Checks that the `firebase` command is available or not.
  _do_alias_feature_check "firebase" "firebase"; 
  _do_log_info "firebase" "Initialize plugin"

  # This is the default firebase commands supported
  if [ -z "${DO_FIREBASE_CMDS}" ]; then
    DO_FIREBASE_CMDS='help cli status login logout start deploy'
  fi

  if [ -z "${DO_FIREBASE_HOSTING_CMDS}" ]; then
    DO_FIREBASE_HOSTING_CMDS='deploy-hosting'
  fi

  if [ -z "${DO_FIREBASE_HOSTING_SUB_CMDS}" ]; then
    DO_FIREBASE_HOSTING_SUB_CMDS='deploy-hosting'
  fi

  if [ -z "${DO_FIREBASE_FIRESTORE_CMDS}" ]; then
    DO_FIREBASE_FIRESTORE_CMDS='deploy-firestore'
  fi

  if [ -z "${DO_FIREBASE_FUNCTION_CMDS}" ]; then
    DO_FIREBASE_FUNCTION_CMDS='deploy-function'
  fi

  if [ -z "${DO_FIREBASE_STORAGE_CMDS}" ]; then
    DO_FIREBASE_STORAGE_CMDS='deploy-storage'
  fi
}
