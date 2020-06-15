# Randomizes a new uuid
function _do_uuid_rand() {
  _do_alias_feature_check 'uuid' 'uuidgen'

  # Randomizes a uuid or empty
  uuidgen || return 1
}
