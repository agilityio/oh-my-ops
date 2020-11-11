_DO_FIREBASE_REPO_CMDS="help status emulator-start"


# Displays helps about how to run a repository firebase commands.
#
function _do_firebase_repo_help() {
    local proj_dir=$1
    local repo=$2
    
    if ! _do_firebase_repo_enabled $proj_dir $repo; then 
        return
    fi 

    _do_print_header_2 "$repo: Firebase help"

    echo "  
  ${repo}-firebase-help: 
    See firebase command helps

  ${repo}-firebase-status: 
    Show firebase information."

    # Prints out all aliases for solution files
    for name in $(_do_repo_dir_array_print "${repo}" "firebase-sln"); do
        if [ "$name" != "." ]; then 
            local cmd=$(_do_string_to_alias_name ${name})
            echo "  
  ${repo}-firebase-emulator-start-${cmd}:
    Runs firebase build on $name"
        fi
    done
}

# Builds the firebase repository.
#
function _do_firebase_repo_status() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    _do_print_header_1 "Firebase status"
    echo "  GOOGLE_APPLICATION_CREDENTIALS: ${GOOGLE_APPLICATION_CREDENTIALS}"
}



# Determines if the specified directory has firebase enabled.
# Arguments:
#   1. dir: A directory.
# 
# Returns: 
#   0 if firebase enabled, 1 otherwise.
#
function _do_firebase_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if _do_repo_dir_array_is_empty "${repo}" "firebase-sln"; then 
        return 1
    else 
        return 0
    fi 
}


function _do_firebase_repo_uninit() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    # Removes all unalias
    _do_alias_remove_by_prefix "${repo}-firebase"
    _do_repo_cmd_hook_remove "${repo}" "firebase" "${_DO_FIREBASE_REPO_CMDS}"

    # Just keeps init alias so that it can be reinitialized
    _do_repo_alias_add ${proj_dir} ${repo} "firebase" "init"

    if _do_repo_dir_array_exists "${repo}" "firebase-sln"; then 
        _do_repo_dir_array_destroy "${repo}" "firebase-sln"
    fi
}

# Initializes firebase support for a repository.
#
function _do_firebase_repo_init() {
    local proj_dir=${1?'proj_dir argument required'}
    local repo=${2?'repo argument required'}

    # Uninits the repository first.
    _do_firebase_repo_uninit ${proj_dir} ${repo}

    # Scans the repository to find all firebase projects and solution files.
    _do_repo_dir_array_new "${proj_dir}" "${repo}" "firebase-sln" "firebase.json"

    if ! _do_firebase_repo_enabled ${proj_dir} ${repo}; then 
        # This directory does not have firebase support.
        _do_log_debug "firebase" "Skips firebase support for '$repo'"
        return
    fi 

    # Sets up the alias for showing the repo firebase status
    _do_log_info "firebase" "Initialize firebase for '$repo'"
    _do_repo_cmd_hook_add "${repo}" "firebase" "${_DO_FIREBASE_REPO_CMDS}"

    _do_repo_alias_add ${proj_dir} $repo "firebase" "uninit help"


    local name
    for name in $(_do_repo_dir_array_print "${repo}" "firebase-sln"); do
        _do_log_debug "firebase" "  $repo/$name"

        local cmd="-$(_do_string_to_alias_name_suffix ${name})"

        # Adds command to build a sub project
        alias "${repo}-firebase-emulator-start${cmd}"="_do_firebase_emulator_start ${proj_dir} ${repo} ${name}"
        alias "${repo}-firebase-emulator-stop${cmd}"="_do_firebase_emulator_stop ${proj_dir} ${repo} ${name}"
    done
}


# Starts firebase emulator a firebase project.
#
function _do_firebase_emulator_start() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    local dir=${3?'dir arg required'}

    _do_print_header_1 "${repo}:Runs emulator at ${dir}"
    _do_dir_push "${proj_dir}/${repo}/${dir}"

    # Starts the firebase emulator.
    firebase emulators:start

    _do_dir_pop

    local err=$?
}


# Stops firebase emulator for a firebase project.
function _do_firebase_emulator_stop() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    local dir=${3?'dir arg required'}

    _do_print_header_2 "${repo}:Runs emulator at ${dir}"
    _do_dir_push "${proj_dir}/${repo}/${dir}"
    echo "TODO"
    _do_dir_pop

    local err=$?
}


# Runs any firebase command in docker.
# Arguments:
#   1. repo: The repository name.
#
function _do_firebase_repo_proj_cmd() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    local dir=${3?'dir arg required'}
    shift 3

    local title="$repo: Runs $@ at ${dir}"
    _do_print_header_2 $title

    _do_dir_push "${proj_dir}/${repo}/${dir}"
    _do_print_line_1 "$@"

    eval "$@"
    local err=$?

    _do_dir_pop
    return $err
}
