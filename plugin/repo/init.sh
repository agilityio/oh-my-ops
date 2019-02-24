_do_log_level_debug "repo"

_do_src_include_others_same_dir

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



# Registers repo-level command hooks. 
# Arguments:
#   1. plugin: The plugin name.
#   2: The space-delimited list of repo-level commands to add hook for. 
# 
# For example, 
#   _do_repo_cmd_hook_add "django" "clean build"
#   Will register "_do_django_repo_clean" function for the hook "_do_repo_clean"
# 
#
function _do_repo_cmd_hook_add() {
    local plugin=$(_do_arg_required $1)
    local cmds=$2
    _do_log_info "repo" "Register command hooks for plugin ${plugin}"

    local cmd
    for cmd in $cmds; do
        local func="_do_${plugin}_repo_$(_do_string_to_undercase $cmd)"
        local hook="_do_repo_$(_do_string_to_undercase ${cmd})"

        _do_log_debug "repo" "Register hook '${hook}' to '${func}'"

        _do_hook_after "${hook}" "${func}"
    done
}


# Registers repo-level command alias. 
# Arguments:
#   1. plugin: The plugin name.
#   2: The space-delimited list of repo-level commands to add aliass for. 
# 
# For example, 
#   _do_repo_cmd_hook_add "django" "clean build"
#   Will register "_do_django_repo_clean" function for the hook "_do_repo_clean"
# 
#
function _do_repo_alias_add() {
    local proj_dir=$1
    local repo=$2
    local plugin=$(_do_arg_required $3)
    local cmds=$4
    _do_log_info "repo" "Register command alias for plugin ${plugin}"

    local cmd
    for cmd in $cmds; do
        local func="_do_${plugin}_repo_$(_do_string_to_undercase $cmd)"
        local repo_alias="${repo}-${plugin}-$(_do_string_to_dash ${cmd})"

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


# Initializes plugin.
function _do_repo_plugin_init() {
    _do_log_info "repo" "Plugin initialize"

    alias "do-repo-gen"="_do_repo_gen"
    alias "do-repo-clone"="_do_repo_clone"
    
    _do_hook_after "_do_prompt" "_do_repo_prompt_changed"
}
