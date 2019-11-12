_do_log_level_warn "repo"

_do_src_include_others_same_dir

declare -ag _DO_REPO_INIT_LIST

# This function looks are a directory and if there is a file named ".do.sh" then
# devops is enabled for that repository. 
# 
function _do_repo_is_enabled() {
    local proj_dir=$1
    local repo=$2    
    if [ -f "$proj_dir/$repo/.do.sh" ]; then 
        return 0
    else 
        return 1
    fi
}


# Change directory and push it to stack.
#
function _do_repo_dir_push() {
    local proj_dir=$1
    local repo=$2

    pushd "$proj_dir/$repo" &> /dev/null
}


# Registers repo-level command alias. 
# Arguments:
#   1. plugin: The plugin name.
#   2: The space-delimited list of repo-level commands to add aliass for. 
# 
# For example, 
#   _do_repo_cmd_hook_add "${repo}" "django" "clean build"
#   Will register "_do_django_repo_clean" function for the hook "_do_repo_clean"
# 
#
function _do_repo_alias_add() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    local plugin=${3?'plugin arg required'}
    local cmds=$4

    _do_log_info "repo" "Register command alias for plugin ${plugin}"

    local cmd
    for cmd in $cmds; do
        local func="_do_${plugin}_repo_$(_do_string_to_undercase $cmd)"
        local repo_alias="do-${repo}-${plugin}-$(_do_string_to_dash ${cmd})"

        _do_log_debug "repo" "Register alias '${repo_alias}' to '${func}'"

         alias "${repo_alias}"="${func} ${proj_dir} ${repo}"
    done
}

# Runs 'git add .' on the specified directory.
# Arguments: 
#   1.proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_repo_cmd() {
    local proj_dir=$1 
    shift
    local repo=$1
    shift

    _do_print_header_2 "$repo: $@"
    _do_repo_dir_push $proj_dir $repo 

    eval $@
    local err=$?

    _do_dir_pop
    return $err
}

function _do_list_repo() {
    for repo in "${_DO_REPO_INIT_LIST[@]}"; do 
        echo "$repo"
    done
}

# Initializes plugin.
function _do_repo_plugin_init() {
    _do_log_info "repo" "Repo plugin initialize"

    alias "do-repo-gen"="_do_repo_gen"
    alias "do-repo-clone"="_do_repo_clone"
    alias "do-list-repo"="_do_list_repo"
    
    _do_hook_after "_do_prompt" "_do_repo_prompt_changed"

    # Adds alias that runs at repository level
    local cmds=( "status" "build" "test" "start" "stop" "deploy" )
    for cmd in ${cmds[@]}; do 
        alias "do-all-${cmd}"="_do_proj_default_exec_all_repo_cmds ${cmd}"
    done

}

function _do_repo_plugin_ready() {
    _do_log_info "repo" "Repo plugin ready"

    # For all loaded repos, trigger repo init function if that 
    # exists. For example, for 'hello-world' repo, the init function should be 
    # named '_do_hello_world_plugin_init'.
    #
    for repo in "${_DO_REPO_INIT_LIST[@]}"; do 
        local func="_do_$(_do_string_to_undercase $repo)_repo_plugin_init" 

        if _do_alias_exist "${func}"; then 
            _do_log_info "repo" "Repo ${repo} initialize"
            ${func}
        fi 
    done


    # Also do the same for ready functions, for example, '_do_hello_world_plugin_ready'.
    for repo in "${_DO_REPO_INIT_LIST[@]}"; do 
        local func="_do_$(_do_string_to_undercase $repo)_repo_plugin_ready" 

        if _do_alias_exist "${func}"; then 
            _do_log_info "repo" "Repo ${repo} ready"
            ${func}
        fi 
    done    
}
