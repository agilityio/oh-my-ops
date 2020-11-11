# Runs an firebase command at the specified directory.
#
# Arguments:
# 1. dir: The absolute directory to run the command.
#
# 2. cmd: The command to run.
#
#   It is ok to put any command, as long as it is defined in the package.json.
#
function _do_firebase_repo_cmd() {
  local err=0
  local dir=${1?'dir arg required'}
  local cmd=${3?'cmd arg required'}

  shift 3

  local run="firebase"

  if [[ "${dir}" == "UNIT-TEST" ]]; then
    # For unit testing
    run="echo ${run}"
  fi

  # replaces the "start" prefix with the "emulators:start" prefix
  # see: https://wiki.bash-hackers.org/syntax/pe#search_and_replace
  cmd=${cmd/#start/emulators:start}

  # Supports deploy hosting command.
  # E.g.,deploy-hosting@web-demo => deploy --only hosting:web-demo
  cmd=${cmd/#deploy-hosting__/deploy --only hosting:}

  
  # Supports deploy only commands
  cmd=${cmd/#deploy-hosting/deploy --only hosting}
  cmd=${cmd/#deploy-firestore/deploy --only firestore}
  cmd=${cmd/#deploy-function/deploy --only functions}
  cmd=${cmd/#deploy-storage/deploy --only storage}

  # Replaces all '__' to 'space'
  cmd=${cmd//__/ }

  {
    ${run} ${cmd} $@
  } || {
    err=1
  }

  return ${err}
}

# Runs an firebase command at the specified directory.
# 
# Arguments:
# 1. dir: The absolute directory to run the command.
#
# 2. cmd: Always "cli"
#
function _do_firebase_repo_cmd_cli() {
  local err=0
  local dir=${1?'dir arg required'}
  shift 3

  local run="firebase"

  if [[ "${dir}" == "UNIT-TEST" ]]; then
    # For unit testing
    run="echo ${run}"
  fi


  {
    ${run} $@
  } || {
    err=1
  }

  return ${err}
}


# Prints out the firebase status.
#
function _do_firebase_repo_cmd_status() {
  echo "
Environment variables:
  GCLOUD_PROJECT : ${GCLOUD_PROJECT}
  GOOGLE_APPLICATION_CREDENTIALS: ${GOOGLE_APPLICATION_CREDENTIALS}
  FIRESTORE_EMULATOR_HOST: ${FIRESTORE_EMULATOR_HOST}
  "
}
