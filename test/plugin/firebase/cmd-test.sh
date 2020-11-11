_do_plugin "firebase"

function test_start_cmd() {
  local s

  s=$(_do_firebase_repo_cmd "UNIT-TEST" "fake-repo" "start")
  _do_assert_eq "firebase emulators:start" "$s"
}


function test_deploy_hosting_cmd() {
  local s

  s=$(_do_firebase_repo_cmd "UNIT-TEST" "fake-repo" "deploy-hosting")
  _do_assert_eq "firebase deploy --only hosting" "$s"
}


function test_deploy_function_cmd() {
  local s

  s=$(_do_firebase_repo_cmd "UNIT-TEST" "fake-repo" "deploy-function")
  _do_assert_eq "firebase deploy --only function" "$s"
}


function test_deploy_firestore_cmd() {
  local s

  s=$(_do_firebase_repo_cmd "UNIT-TEST" "fake-repo" "deploy-firestore")
  _do_assert_eq "firebase deploy --only firestore" "$s"
}

function test_deploy_storage_cmd() {
  local s

  s=$(_do_firebase_repo_cmd "UNIT-TEST" "fake-repo" "deploy-storage")
  _do_assert_eq "firebase deploy --only storage" "$s"
}


function test_deploy_hosting_sub_cmd() {
  local s

  s=$(_do_firebase_repo_cmd "UNIT-TEST" "fake-repo" "deploy-hosting__web-demo")
  _do_assert_eq "firebase deploy --only hosting:web-demo" "$s"
}